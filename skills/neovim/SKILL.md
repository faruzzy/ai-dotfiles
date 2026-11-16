---
name: neovim
description: Reach the user's running Neovim over RPC. Use when the user refers to what's open in their editor ("this file", "this line", "my selection", "the error here"), including an editor in another tmux session or project ("the backend session", "server.go"), when you need their unsaved edits or live diagnostics, or to open a file or quickfix list in their editor.
---

Neovim runs in another tmux pane, so the files on disk can lag behind what the user sees. Ask the editor itself.

## 1. Find the editor

```bash
S=$(nvim-here)
```

`nvim-here` (dotfiles `bin/`) prints the socket of the Neovim in your tmux window, else the one whose working directory is in your project.

- Exit 2: several match, listed on stderr with window, cwd and file. Show the list and ask the user which one; then use that socket as `S`.
- Exit 1: no running Neovim. Tell the user and work from the files on disk.

When the user points at another editor (a tmux session such as "the backend session", another project, or a file open elsewhere such as "server.go"), run `nvim-here --list` instead: one line per editor with its socket, tmux `window=session:index`, `cwd` and current `file`. Take the socket of the line that matches; if none or several do, show the list and ask. The rules in step 3 apply to that editor too.

## 2. Query it

Every call has this shape; `EXPR` is a Vim expression, usually `luaeval("...")`:

```bash
nvim --headless --server "$S" --remote-expr 'EXPR' </dev/null
```

Keep `--headless` and `</dev/null`: if the socket is dead, a client attached to a terminal opens a full editor instead of printing the error. Inside `luaeval("...")`, write Lua strings as `[[...]]`, since the shell quotes are single and the Vim string is double. Return structured data with `vim.json.encode(...)`. A failing expression exits 2 with the Lua error on stderr.

"Current" means the window the user last had focused, which can be a file tree, terminal or picker rather than a file: trust `file` only when `buftype` is empty.

| Need | EXPR |
|---|---|
| What's in front of them | `luaeval("vim.json.encode({file=vim.api.nvim_buf_get_name(0), buftype=vim.bo.buftype, filetype=vim.bo.filetype, line=vim.fn.line([[.]]), col=vim.fn.col([[.]]), modified=vim.bo.modified, cwd=vim.fn.getcwd()})")` |
| Their selection | `luaeval("vim.json.encode({file=vim.api.nvim_buf_get_name(0), mode=vim.fn.mode(), active={vim.fn.line([[v]]), vim.fn.line([[.]])}, last={vim.api.nvim_buf_get_mark(0, [[<]])[1], vim.api.nvim_buf_get_mark(0, [[>]])[1]}})")` |
| Buffer text, unsaved edits included (`null` if the file isn't open: read it from disk) | `luaeval("vim.json.encode((function() for _, b in ipairs(vim.api.nvim_list_bufs()) do if vim.api.nvim_buf_get_name(b) == vim.fn.resolve([[/abs/path]]) then return vim.api.nvim_buf_get_lines(b, 0, -1, false) end end return vim.NIL end)())")` |
| Diagnostics in the current buffer | `luaeval("vim.json.encode(vim.tbl_map(function(d) return {line=d.lnum+1, severity=d.severity, source=d.source, message=d.message} end, vim.diagnostic.get(0)))")` |
| Files with unsaved changes | `luaeval("vim.json.encode(vim.tbl_map(vim.api.nvim_buf_get_name, vim.tbl_filter(function(b) return vim.bo[b].modified end, vim.api.nvim_list_bufs())))")` |

Selection: they often select, then switch to your pane with the editor still in visual mode, and Vim records a selection only when it ends. If `mode` is `v`, `V` or Ctrl-V (`"\u0016"`, blockwise), the selection is the lines in `active` (either order); otherwise it's `last` (0 when there's none).

Buffer names are absolute with symlinks resolved (`/tmp/x` is `/private/tmp/x` on macOS), hence the `resolve()` above. Match names exactly: `bufnr()` also matches partial names, so `index.ts` would find `index.tsx`.

## 3. Act in it

Read and navigate freely. Change buffer text, save, or quit only when the user asked for that in this conversation: the buffers can hold unsaved work.

- Show a file at a line: `execute("drop +42 " . fnameescape("/abs/path"))` (jumps to its window if it's already open).
- Show a list of locations: write `path:line:col: message` lines to a file from `mktemp`, then `execute("cgetfile " . fnameescape("/that/file") . " | copen | wincmd p")`; `wincmd p` keeps their focus off the list, so later "current" queries still see their file.
