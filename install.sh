#!/usr/bin/env bash
# Links this repo's agent config into ~/.claude and ~/.codex.
# Idempotent: safe to re-run. Existing real files are moved to
# ~/.ai-dotfiles-backup/<timestamp>/ before being replaced.
#
#   ./install.sh            apply
#   ./install.sh --dry-run  print what would change, touch nothing

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_HOME="$HOME/.claude"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
BACKUP_DIR="$HOME/.ai-dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

BLUE='\033[0;34m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
log_info()    { printf '%b\n' "${BLUE}[INFO]${NC} $1"; }
log_success() { printf '%b\n' "${GREEN}[OK]${NC} $1"; }
log_warning() { printf '%b\n' "${YELLOW}[WARN]${NC} $1"; }

run() {
    if (( DRY_RUN )); then printf '  would run: %s\n' "$*"; else "$@"; fi
}

backup() {
    local target="$1"
    local dest="$BACKUP_DIR${target#"$HOME"}"
    run mkdir -p "$(dirname "$dest")"
    run mv "$target" "$dest"
    log_warning "backed up $target -> $dest"
}

# link <source in repo> <target in $HOME>
link() {
    local src="$1" target="$2"
    if [[ -L "$target" && "$(readlink "$target")" == "$src" ]]; then
        return 0
    fi
    run mkdir -p "$(dirname "$target")"
    if [[ -L "$target" ]]; then
        run rm "$target"
    elif [[ -e "$target" ]]; then
        backup "$target"
    fi
    run ln -s "$src" "$target"
    log_success "linked ${target/#"$HOME"/\~}"
}

# Remove symlinks in <dir> that point into this repo but whose source is gone
# (a skill that was deleted or renamed here).
prune_dangling() {
    local dir="$1" entry
    [[ -d "$dir" ]] || return 0
    for entry in "$dir"/*; do
        if [[ -L "$entry" && "$(readlink "$entry")" == "$REPO"/* && ! -e "$entry" ]]; then
            run rm "$entry"
            log_info "removed stale link ${entry/#"$HOME"/\~}"
        fi
    done
}

link_instructions() {
    log_info "Global instructions"
    link "$REPO/global/AGENTS.md" "$CLAUDE_HOME/CLAUDE.md"
    link "$REPO/global/AGENTS.md" "$CODEX_HOME/AGENTS.md"
}

link_skills() {
    log_info "Skills"
    local skill name
    for skill in "$REPO"/skills/*/; do
        skill="${skill%/}"
        name="$(basename "$skill")"
        link "$skill" "$CLAUDE_HOME/skills/$name"
        link "$skill" "$CODEX_HOME/skills/$name"
    done
    prune_dangling "$CLAUDE_HOME/skills"
    prune_dangling "$CODEX_HOME/skills"
}

link_claude_settings() {
    log_info "Claude settings"
    link "$REPO/claude/settings.json" "$CLAUDE_HOME/settings.json"
}

link_codex_rules() {
    log_info "Codex rules"
    link "$REPO/codex/ai-dotfiles.rules" "$CODEX_HOME/rules/ai-dotfiles.rules"
}

# Write each top-level `key = value` from codex/config.base.toml into
# config.toml: replace the key where it is defined at top level, else insert
# it before the first [table].
merge_codex_config() {
    log_info "Codex config baseline"
    local config="$CODEX_HOME/config.toml"
    local base="$REPO/codex/config.base.toml"
    local tmp key line
    [[ -f "$config" ]] || { run mkdir -p "$CODEX_HOME"; run touch "$config"; }

    tmp="$(mktemp)"
    cp "$config" "$tmp" 2>/dev/null || : > "$tmp"

    while IFS= read -r line; do
        [[ "$line" =~ ^([A-Za-z0-9_]+)[[:space:]]*= ]] || continue
        key="${BASH_REMATCH[1]}"
        awk -v key="$key" -v line="$line" '
            BEGIN { done = 0; in_table = 0 }
            /^[[:space:]]*\[/ {
                if (!done) { print line; print ""; done = 1 }
                in_table = 1
            }
            !in_table && $0 ~ "^[[:space:]]*" key "[[:space:]]*=" {
                if (!done) { print line; done = 1 }
                next
            }
            { print }
            END { if (!done) print line }
        ' "$tmp" > "$tmp.next"
        mv "$tmp.next" "$tmp"
    done < "$base"

    if cmp -s "$tmp" "$config"; then
        rm "$tmp"
        return 0
    fi
    if (( DRY_RUN )); then
        diff -u "$config" "$tmp" || true
        rm "$tmp"
        return 0
    fi
    mkdir -p "$BACKUP_DIR"
    cp "$config" "$BACKUP_DIR/codex-config.toml"
    mv "$tmp" "$config"
    log_success "updated ${config/#"$HOME"/\~} (previous copy in $BACKUP_DIR)"
}

main() {
    (( DRY_RUN )) && log_info "Dry run: nothing will be changed"
    link_instructions
    link_skills
    link_claude_settings
    link_codex_rules
    merge_codex_config
    log_success "Done. Start a new Claude Code / Codex session to pick up changes."
}

main
