vim.cmd("source " .. vim.fn.stdpath("config") .. "/vimrc")

-- Settings
--=============================================================================

vim.o.confirm = true
vim.o.updatetime = 50
vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"
vim.o.exrc = true
vim.o.backspace = "indent,eol,start"
vim.o.mouse = "a"
vim.o.fileformats = "unix,dos,mac"
vim.opt.autowriteall = true
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.o.undofile = true

-- Title
vim.opt.title = true
vim.opt.titlestring = "%{fnamemodify(getcwd(), ':t')} - Nvim"

-- Split
vim.o.splitright = true
vim.o.splitbelow = true

-- Tabs
vim.o.tabstop = 4      -- Number of spaces a tab counts for
vim.o.shiftwidth = 4   -- Spaces for each (auto)indent step
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.softtabstop = 4

-- Search and Replace
vim.o.inccommand = "nosplit"

-- Useless Settings
vim.o.swapfile = false
vim.o.backup = false

-- Auto Reload file
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    pattern = { "*" },
    callback = function()
        if vim.fn.getcmdwintype() == "" and vim.fn.mode() ~= "c" then
            vim.cmd("checktime")
        end
    end,
})

-- Clipboard
--=============================================================================

local function is_termux()
    return vim.env.TERMUX_VERSION ~= nil
end

vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
end)

-- Keybindings
--=============================================================================

local function keymap_set(mode, map, func, desc, opt_override)
    local opt = { desc = desc, noremap = true, silent = true }
    for k, v in pairs(opt_override or {}) do
        opt[k] = v
    end
    vim.keymap.set(mode, map, func, opt)
end

keymap_set("t", "<Esc>", "<C-\\><C-n>",    "Exit terminal mode")
keymap_set("n", "L", vim.diagnostic.open_float, "Show Diagnostic")

keymap_set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==",                   "Move Line Down")
keymap_set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==",             "Move Line Up")
keymap_set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi",                                   "Move Line Down")
keymap_set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi",                                   "Move Line Up")
keymap_set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",       "Move Line Down")
keymap_set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", "Move Line Up")

keymap_set("n", "<A-[>", function() vim.fn.search("^\\s\\+$", "bW") end, "Prev filled whitespace line")
keymap_set("n", "<A-]>", function() vim.fn.search("^\\s\\+$", "W") end,  "Next filled whitespace line")

-- Paste
keymap_set("n", "<leader>ep", ":iput<CR>", "[e]dit [p]aste");
keymap_set("x", "P", function() vim.cmd("normal! p") end, "[P]uts before cursor")
keymap_set("x", "p", function() vim.cmd("normal! P") end, "[p]uts after cursor")
keymap_set("n", "<A-[>", function()
    if vim.fn.search("^\\s*$", "bW") == 0 then
        vim.cmd("normal! gg")
    end
end, "Prev blank line or start of file")
keymap_set("n", "<A-]>", function()
    if vim.fn.search("^\\s*$", "W") == 0 then
        vim.cmd("normal! G")
    end
end, "Next blank line or end of file")

local toggle_state = false
keymap_set("n", "<leader>w/", function()
    toggle_state = not toggle_state
    if toggle_state then
        -- Maximize current window vertically and horizontally
        vim.cmd("wincmd |")
        vim.cmd("wincmd _")
    else
        -- Equalize all windows
        vim.cmd("wincmd =")
    end
end, "[w]indow Toggle")
keymap_set("n", "<leader>wd", function()
    local current_win = vim.api.nvim_get_current_win()
    local current_buf = vim.api.nvim_get_current_buf()
    local current_line = vim.api.nvim_win_get_cursor(0)
    local wins = vim.api.nvim_list_wins()
    local target_win = nil
    for _, win in ipairs(wins) do
        if win ~= current_win then
            target_win = win
            break
        end
    end
    if target_win then
        vim.api.nvim_set_current_win(target_win)
    else
        vim.cmd("vsplit")
        vim.api.nvim_set_current_buf(current_buf)
    end
    if vim.api.nvim_win_get_buf(target_win) ~= current_buf then
        vim.api.nvim_set_current_buf(current_buf)
    end
    vim.api.nvim_win_set_cursor(0, current_line)
end, "[w]indow [d]uplicate")

local function get_visual_selection()
    local s_start = vim.fn.getpos("'<")
    local s_end = vim.fn.getpos("'>")
    local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
    if #lines == 0 then return "" end
    lines[1] = lines[1]:sub(s_start[3], -1)
    lines[#lines] = lines[#lines]:sub(1, s_end[3])
    return table.concat(lines, "\n")
end

keymap_set({"n", "v"}, "<leader>wf", function()
    local original_win = vim.api.nvim_get_current_win()
    local mode = vim.api.nvim_get_mode().mode
    local file_spec
    if mode == "v" or mode == "V" or mode == "\22" then
        file_spec = get_visual_selection():match("^[^\n]+")  -- Get first line of selection
    else
        file_spec = vim.fn.expand("<cWORD>")
    end
    local fileInfo = vim.fn.split(file_spec, ":")
    local file = fileInfo[1]
    local line = fileInfo[2] or "1"
    local column = fileInfo[3] or "1"
    if mode == "v" or mode == "V" or mode == "\22" then
        vim.cmd("normal! \27")  -- Exit visual mode
    end
    local wins = vim.api.nvim_list_wins()
    local target_win
    if #wins == 1 then
        vim.cmd("vsplit")
        target_win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_call(target_win, function()
            vim.cmd("edit " .. vim.fn.fnameescape(file))
        end)
        vim.api.nvim_win_set_cursor(target_win, {tonumber(line), tonumber(column) - 1})
        vim.api.nvim_set_current_win(original_win)
    else
        for _, win in ipairs(wins) do
            if win ~= original_win then
                target_win = win
                break
            end
        end
        vim.api.nvim_win_call(target_win, function()
            vim.cmd("edit " .. vim.fn.fnameescape(file))
        end)
        vim.api.nvim_win_set_cursor(target_win, {tonumber(line), tonumber(column) - 1})
    end
end, "[w]indow goto [f]ile")

-- Better Search Next
keymap_set("n", "n", "'Nn'[v:searchforward].'zv'", "[n]ext Search Result", { expr = true })
keymap_set("x", "n", "'Nn'[v:searchforward]",      "[n]ext Search Result", { expr = true })
keymap_set("o", "n", "'Nn'[v:searchforward]",      "[n]ext Search Result", { expr = true })
keymap_set("n", "N", "'nN'[v:searchforward].'zv'", "Prev Search Result", { expr = true })
keymap_set("x", "N", "'nN'[v:searchforward]",      "Prev Search Result", { expr = true })
keymap_set("o", "N", "'nN'[v:searchforward]",      "Prev Search Result", { expr = true })

-- Autocommands
--=============================================================================

-- Better whitespace handling
keymap_set("i", "<CR>", "<Space><BS><CR>",   "Enter new line (keep cursor at start of line)")
keymap_set("i", "<Esc>", "<Space><BS><Esc>", "Exit insert mode (keep cursor position unchanged)")
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    callback = function()
        local dir = vim.fn.expand("%:p:h")
        if dir:match("NeoBullion") then
            return
        end
        local save_cursor = vim.fn.getpos(".")
        pcall(function()
            vim.cmd([[%s/\S\zs\s\+$//e]])
        end)
        vim.fn.setpos(".", save_cursor)
    end,
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Save the last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- Buffers
--=============================================================================

keymap_set("n", "[b", "<cmd>bprevious<cr>",    "Prev Buffer")
keymap_set("n", "]b", "<cmd>bnext<cr>",        "Next Buffer")
vim.api.nvim_create_user_command("Bda", function() vim.cmd("%bdelete | edit # | bdelete #") end, { desc = "Close all other buffers, keep only current" })
vim.api.nvim_create_user_command("Bd",  function() vim.cmd("bn | bd#") end,                      { desc = "Close previous buffer and move to next" })

-- Autocomplete
--=============================================================================

vim.o.omnifunc = "syntaxcomplete#Compete"
vim.opt.completeopt:append { "menuone", "preview", "noselect" }
vim.o.complete = ".,w,b,u,U"
keymap_set("i", "<A-n>", "<C-n>",      "Completion from sources specified in the 'complete'")
keymap_set("i", "<A-b>", "<C-x><C-n>", "[b]uffer completion'")
keymap_set("i", "<A-f>", "<C-x><C-f>", "[f]ilename completion")
keymap_set("i", "<A-s>", "<C-x><C-s>", "[s]pell completion")
keymap_set("i", "<A-l>", "<C-x><C-l>", "[l]ine completion")
keymap_set("i", "<Tab>",   'pumvisible() ? "\\<C-n>" : "\\<Tab>"',   "Next completion item (or normal Tab if no menu)",           { expr = true })
keymap_set("i", "<S-Tab>", 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', "Previous completion item (or normal Shift+Tab if no menu)", { expr = true })

-- Terminal
--=============================================================================

if (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1) then
    vim.o.shell = 'bash.exe'
    vim.o.shellcmdflag = "-c"
    vim.o.shellxquote = ""
end

local function open_split_terminal(dir)
    vim.cmd.new()
    if not dir then
        vim.cmd.wincmd "J"
    end
    vim.api.nvim_win_set_height(0, 12)
    vim.wo.winfixheight = true
    vim.fn.termopen("bash", { cwd = dir or "" })
    vim.cmd.startinsert()
end

keymap_set({"i", "n"}, "<C-`>", open_split_terminal, "Open Split Termainl")
keymap_set({"i", "n"}, "<M-`>", function()
    local dir = vim.fn.expand("%:p:h")
    open_split_terminal(dir)
end, "Open in current file directory")

vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
        vim.opt_local.bufhidden = "delete"
    end,
})

vim.api.nvim_create_autocmd("TermClose", {
    pattern = "*",
    callback = function(event)
        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(event.buf) then
                pcall(vim.cmd, "bdelete! " .. event.buf)
            end
        end)
    end,
})

-- Make
--=============================================================================

vim.api.nvim_create_user_command("Make", function(opts)
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].modified and vim.bo[bufnr].buftype == "" and vim.api.nvim_buf_get_name(bufnr) ~= "" then
            pcall(vim.api.nvim_buf_call, bufnr, function()
                vim.cmd("update")
            end)
        end
    end
    local lines = {}

    -- Respect $* placeholder in makeprg (e.g. "make $*"), fall back to appending
    local cmd
    if opts.args ~= "" then
        local expanded = vim.o.makeprg:gsub("%$%*", opts.args)
        cmd = expanded ~= vim.o.makeprg and expanded or (vim.o.makeprg .. " " .. opts.args)
    else
        cmd = vim.o.makeprg:gsub("%$%*", "")
    end

    -- Run via shell so makeprg strings like "cargo build 2>&1" work correctly
    vim.fn.jobstart({ vim.o.shell, vim.o.shellcmdflag, cmd }, {
        stdout_buffered = true,
        stderr_buffered = true,
        on_stdout = function(_, data)
            if data then vim.list_extend(lines, data) end
        end,
        on_stderr = function(_, data)
            if data then vim.list_extend(lines, data) end
        end,
        on_exit = function(_, exit_code)
            vim.schedule(function()
                vim.fn.setqflist({}, " ", {
                    title = "Make",
                    lines = lines,
                    efm = vim.o.errorformat,
                })
                vim.api.nvim_exec_autocmds("QuickfixCmdPost", { pattern = "make" })
            end)
        end,
    })
end, {
    desc = "Modern `make`",
    nargs = "*",
})

local severity_map = {
    E = vim.diagnostic.severity.ERROR,
    W = vim.diagnostic.severity.WARN,
    I = vim.diagnostic.severity.INFO,
    N = vim.diagnostic.severity.HINT,
}
vim.api.nvim_create_autocmd("QuickfixCmdPost", {
    pattern = "make",
    callback = function()
        local ns = vim.api.nvim_create_namespace("make_diagnostics")
        local qflist = vim.fn.getqflist()
        local diagnostics = {}
        for _, entry in ipairs(qflist) do
            -- Only process entries with a valid buffer and line number
            if entry.bufnr ~= 0 and entry.lnum > 0 then
                local type = entry.type:upper()
                local severity = severity_map[type] or vim.diagnostic.severity.ERROR
                local d = {
                    bufnr = entry.bufnr,
                    lnum = entry.lnum - 1, -- Quickfix is 1-indexed, diagnostics are 0-indexed
                    col = entry.col > 0 and entry.col - 1 or 0,
                    severity = severity,
                    message = entry.text,
                    source = "make",
                }
                -- Group diagnostics by buffer
                if not diagnostics[entry.bufnr] then
                    diagnostics[entry.bufnr] = {}
                end
                table.insert(diagnostics[entry.bufnr], d)
            end
        end
        -- Clear old diagnostics and set new ones
        vim.diagnostic.reset(ns)
        for bufnr, diags in pairs(diagnostics) do
            vim.diagnostic.set(ns, bufnr, diags)
        end
    end,
})


-- Build Command
if vim.fn.filereadable("build.c") == 1 then
    vim.opt.makeprg="cc build.c && ./a.out build-run"
end
if vim.fn.filereadable("build.xml") == 1 then
    vim.opt.makeprg="ant compile"
    vim.opt.errorformat="%A\\ %#[javac]\\ %f:%l:\\ error:\\ %m,%-Z\\ %#[javac]\\ %p^,%-C%.%#,%-G%.%#BUILD\\ FAILED%.%#,%-GTotal\\ time:\\ %.%#"
end

local autogroup_auto_make = vim.api.nvim_create_augroup("AutoMake", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    group = autogroup_auto_make,
    callback = function()
        if vim.fn.filereadable("build.c") == 1 then
            vim.cmd("Make")
        end
        if vim.fn.filereadable("build.xml") == 1 then
            vim.cmd("Make")
        end
    end,
})

-- Open quickfix in full width
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("QuickFix", { clear = true }),
    pattern = "qf",
    callback = function()
        vim.cmd("wincmd J")
    end,
})

keymap_set("n", "<F5>", "<CMD>make<CR>", "Make", { noremap = false })

-- Neovim Gui
--=============================================================================

if vim.g.neovide then
    vim.o.guifont = "CommitMono,Consolas:h10"
    keymap_set({ "n", "v" }, "<C-=>",   ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>", "Neovide: Increase font size")
    keymap_set({ "n", "v" }, "<C-->",   ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>", "Neovide: Decrease font size")
    keymap_set({ "n", "v" }, "<C-0>",   ":lua vim.g.neovide_scale_factor = 1<CR>",                                "Neovide: Reset font size to default")
    keymap_set("n",          "<C-S-v>", '"+P',         "Paste from system clipboard (after cursor)")
    keymap_set("v",          "<C-S-v>", '"+P',         "Paste from system clipboard (replace selection)")
    keymap_set("i",          "<C-S-v>", '<ESC>l"+Pli', "Paste from system clipboard in insert mode")
    keymap_set("c",          "<C-S-v>", "<C-R>+",      "Paste from system clipboard in command-line mode")
    local neovide_fullscreen = false
    keymap_set({"n", "i", "t", "x"}, "<F11>", function()
        neovide_fullscreen = not neovide_fullscreen
        vim.g.neovide_fullscreen = neovide_fullscreen
        vim.notify("Full Screen")
    end, "Full Screen")
end

-- Session
--=============================================================================

local session_dir = vim.fs.joinpath(vim.fn.stdpath("state"), "sessions")
vim.fn.mkdir(session_dir, "p")

local auto_save_enabled = true

---Generate a safe session filename from a directory path
---@param dir? string
---@return string
local function get_session_file(dir)
    local target = vim.fs.normalize(dir or vim.uv.cwd() or "")
    -- Use '+' instead of '%' because '%' is Vim's special character for current file
    local encoded = target:gsub("[\\/:]", "+") .. ".vim"
    return vim.fs.joinpath(session_dir, encoded)
end

---Check if current Neovim state has real file buffers worth saving
---@return boolean
local function should_save()
    if vim.o.diff then return false end
    local ft = vim.bo.filetype
    if ft == "gitcommit" or ft == "gitrebase" then return false end

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
            local name = vim.api.nvim_buf_get_name(buf)
            local bt = vim.bo[buf].buftype
            if name ~= "" and bt == "" and not name:match("COMMIT_EDITMSG$") and not name:match("git%-rebase%-todo$") then
                return true
            end
        end
    end
    return false
end

---Save session for given directory (defaults to cwd)
---@param dir? string
local function save_session(dir)
    if not auto_save_enabled then return end
    if not should_save() then return end
    local file = get_session_file(dir)
    pcall(vim.cmd, "%argdelete")
    vim.cmd("mksession! " .. vim.fn.fnameescape(file))
end

---Restore session for given directory (defaults to cwd)
---@param dir? string
---@return boolean
local function restore_session(dir)
    local file = get_session_file(dir)
    if vim.uv.fs_stat(file) then
        vim.cmd("silent! source " .. vim.fn.fnameescape(file))
        return true
    end
    return false
end

-- Autocommand Group
local group = vim.api.nvim_create_augroup("AutoSession", { clear = true })

-- Auto-restore on startup
vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    nested = true,
    callback = function()
        auto_save_enabled = true
        -- Skip if piped from stdin
        if vim.v.stdin == 1 or vim.g.started_with_stdin then
            return
        end
        local argv = vim.fn.argv()
        -- Auto-restore if launched with no args or with a single directory argument (e.g. `nvim .`)
        if #argv == 0 then
            restore_session()
        elseif #argv == 1 and vim.fn.isdirectory(argv[1]) == 1 then
            local target_dir = vim.fs.normalize(vim.fn.fnamemodify(argv[1], ":p"))
            restore_session(target_dir)
        end
    end,
})

-- Auto-save on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
        save_session()
    end,
})

-- Handle directory changes (:cd, :tcd)
vim.api.nvim_create_autocmd("DirChanged", {
    group = group,
    callback = function(ev)
        save_session(vim.v.event.old_dir)
        auto_save_enabled = true
        restore_session(ev.file)
    end,
})

-- Convenient User Commands
vim.api.nvim_create_user_command("SessionSave", function()
    auto_save_enabled = true
    save_session()
    vim.notify("Session saved for " .. vim.uv.cwd(), vim.log.levels.INFO)
end, { desc = "Save current directory session" })

vim.api.nvim_create_user_command("SessionRestore", function()
    auto_save_enabled = true
    if restore_session() then
        vim.notify("Session restored for " .. vim.uv.cwd(), vim.log.levels.INFO)
    else
        vim.notify("No session found for " .. vim.uv.cwd(), vim.log.levels.WARN)
    end
end, { desc = "Restore current directory session" })

vim.api.nvim_create_user_command("SessionDelete", function()
    auto_save_enabled = false
    vim.v.this_session = ""
    local file = get_session_file()
    if vim.uv.fs_stat(file) then
        local ok, err = vim.uv.fs_unlink(file)
        if ok then
            vim.notify("Session deleted (auto-save disabled) for " .. vim.uv.cwd(), vim.log.levels.INFO)
        else
            vim.notify("Failed to delete session: " .. tostring(err), vim.log.levels.ERROR)
        end
    else
        vim.notify("No session found for " .. vim.uv.cwd(), vim.log.levels.WARN)
    end
end, { desc = "Delete current directory session" })

-- Plugins
--=============================================================================

-- Load Built-in Plugins ======================================================

vim.cmd("packadd justify")
vim.cmd("packadd nvim.difftool")
vim.cmd("packadd nvim.undotree")

-- Load External Plugins ======================================================

local plugin_path = vim.fn.stdpath("config") .. "/plugins"
vim.opt.runtimepath:append(plugin_path .. "/*")

-- Theme ======================================================================
-- Colorscheme
vim.o.termguicolors = true
vim.g.gruvbox_material_enable_italic = true
vim.g.gruvbox_material_background = 'dark'
vim.g.gruvbox_material_background = 'soft'
vim.g.gruvbox_material_better_performance = 1
vim.cmd.colorscheme('gruvbox-material')

local function set_color()
    vim.api.nvim_set_hl(0, "Comment",      { fg = vim.o.background == "dark" and "#B8BB26" or "#79740E" })
    vim.api.nvim_set_hl(0, "NoteKeyword",  { bg = vim.o.background == "dark" and "#D8A657" or "#B47109", fg = vim.o.background == "dark" and "#3C3836" or "#F2E5BC", bold = true })
    vim.api.nvim_set_hl(0, "LineNr",       { fg = "#928374" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = vim.o.background == "dark" and "#BDAE93" or "#7C6F64", bold = true })
end
set_color()

-- Auto switch light/dark modes
if (vim.fn.has("win32") == 0 or vim.fn.has("win64") == 0) then
  require("darkman").setup({
    change_background = true,
    send_user_event = true,
  })

  vim.api.nvim_create_autocmd("OptionSet", {
    pattern = "background",
    callback = set_color,
  })
end
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
    vim.fn.matchadd("NoteKeyword", [[\<NOTE\>]])
  end,
})

-- Status Line
require("lualine").setup({
    sections = {
        lualine_c = {
            {
                "filename",
                path = 1, -- Show absolute path
                file_status = true, -- Show file status
            }
        }
    },
    inactive_sections = {
        lualine_c = {
            {
                "filename",
                path = 1, -- Show absolute path
                file_status = true, -- Show file status
            }
        }
    },
    options = { theme = "gruvbox-material" },
})

-- Wildcard
require('mini.cmdline').setup()

-- Editing ====================================================================

-- Undo
require("select-undo").setup()

-- Bracket Split and Join
require("mini.splitjoin").setup({
    mappings = {
        toggle = "<leader>et",
    },
})

-- Better "f", "t", "F", "T"
require("mini.jump").setup()
keymap_set({ "n", "x", "o" }, "<leader>ef", function() require("mini.jump").smart_jump() end,     "[e]dit [f]orward jump")
keymap_set({ "n", "x", "o" }, "<leader>eF", function() require("mini.jump").smart_jump(true) end, "[e]dit [F]orward jump backward")

-- Better "w", "e" and "b"
keymap_set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", "Next sub[w]ord")
keymap_set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", "[e]nd of next subword")
keymap_set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", "[b]ack subword")
keymap_set({ "n", "o", "x" }, "<M-w>", "w", "Next [w]ord")
keymap_set({ "n", "o", "x" }, "<M-e>", "e", "[e]nd of next word")
keymap_set({ "n", "o", "x" }, "<M-b>", "b", "[b]ack word")

-- Surround
require("mini.surround").setup({
    mappings = {
        add = "<leader>sa", -- Add surrounding in Normal and Visual modes
        delete = "<leader>sd", -- Delete surrounding
        find = "<leader>sf", -- Find surrounding (to the right)
        find_left = "<leader>sF", -- Find surrounding (to the left)
        highlight = "<leader>sh", -- Highlight surrounding
        replace = "<leader>sr", -- Replace surrounding
        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
    },
    highlight_duration = 1000,
})
require("mini.ai").setup()

-- Macro ======================================================================
require("macrothis").setup()
vim.api.nvim_create_user_command("Macro", function(opts)
    local subcmd = opts.args ~= "" and opts.args or "find_saved"
    local actions = {
        delete   = function() require('macrothis').delete() end,
        edit     = function() require('macrothis').edit() end,
        load     = function() require('macrothis').load() end,
        rename   = function() require('macrothis').rename() end,
        quickfix = function() require('macrothis').quickfix() end,
        run      = function() require('macrothis').run() end,
        save     = function() require('macrothis').save() end,
        register = function() require('macrothis').register() end,
        copy_register_printable = function() require('macrothis').copy_register_printable() end,
        copy_macro_printable    = function() require('macrothis').copy_macro_printable() end,
        find_saved = function() require('macrothis').load() end,
    }
    local fn = actions[subcmd]
    if fn then
        fn()
    else
        vim.notify("Macro: unknown subcommand '" .. subcmd .. "'", vim.log.levels.ERROR)
    end
end, {
    nargs = "?",
    complete = function(arglead)
        local subcommands = {
            "delete", "edit", "load", "rename", "quickfix",
            "run", "save", "register",
            "copy_register_printable", "copy_macro_printable",
        }
        return vim.tbl_filter(function(s)
            return s:find("^" .. arglead)
        end, subcommands)
    end,
    desc = "Macro commands",
})

-- Keymap Helper ==============================================================
local miniclue = require("mini.clue")
miniclue.setup({
    triggers = {
        { mode = { "n", "x" }, keys = "<Leader>" },
        { mode = "n", keys = "[" },
        { mode = "n", keys = "]" },
        { mode = "i", keys = "<C-x>" },
        { mode = { "n", "x" }, keys = "g" },
        { mode = { "n", "x" }, keys = "'" },
        { mode = { "n", "x" }, keys = "`" },
        { mode = { "n", "x" }, keys = '"' },
        { mode = { "i", "c" }, keys = "<C-r>" },
        { mode = "n", keys = "<C-w>" },
        { mode = { "n", "x" }, keys = "z" },
    },
    clues = {
        miniclue.gen_clues.square_brackets(),
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
        { mode = "n", keys = "<leader>f",  desc = "[f]ind" },
        { mode = "n", keys = "<leader>e",  desc = "[e]dit" },
        { mode = "n", keys = "<leader>m",  desc = "[m]ark" },
        { mode = "n", keys = "<leader>s",  desc = "[s]urround" },
        { mode = "n", keys = "<leader>w",  desc = "[w]indow" },
        { mode = "n", keys = "<leader>g",  desc = "[g]it" },
        { mode = "n", keys = "<leader>d",  desc = "[d]ebugger" },
        { mode = "n", keys = "<leader>dg", desc = "[d]ebugger [g]oto" },
    },
    window = {
        -- Floating window config
        config = {
            width = "auto"
        },
        -- Delay before showing clue window
        delay = 10,
        -- Keys to scroll inside the clue window
        scroll_down = "<C-d>",
        scroll_up = "<C-u>",
    },
})

-- Better Quickfix ============================================================
require("quicker").setup()
keymap_set("n", "<leader>l", function() require("quicker").toggle({ loclist = true }) end, "Toggle [l]oclist")
require("quicker").setup({
  keys = {
    {
      ">",
      function()
        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
      end,
      desc = "Expand quickfix context",
    },
    {
      "<",
      function()
        require("quicker").collapse()
      end,
      desc = "Collapse quickfix context",
    },
  },
})

-- Mark Management ============================================================
-- Files Marks

local harpoon = require("harpoon")
harpoon:setup()
keymap_set("n", "<leader>mf", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, "[m]ark [f]iles menu")
keymap_set("n", "<leader>ma", function() harpoon:list():add() end,                         "[m]ark [a]dd file")
keymap_set("n", "<leader>m1", function() harpoon:list():select(1) end,                     "[m]ark goto [1]'st file")
keymap_set("n", "<leader>m2", function() harpoon:list():select(2) end,                     "[m]ark goto [2]'nd file")
keymap_set("n", "<leader>m3", function() harpoon:list():select(3) end,                     "[m]ark goto [3]'rd file")
keymap_set("n", "<leader>m4", function() harpoon:list():select(4) end,                     "[m]ark goto [4]'th file")

-- File Manager ===============================================================
function _G.get_oil_winbar()
    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local dir = require("oil").get_current_dir(bufnr)
    if dir then
        return vim.fn.fnamemodify(dir, ":~")
    else
        -- If there is no current directory (e.g. over ssh), just show the buffer name
        return vim.api.nvim_buf_get_name(0)
    end
end

require("oil").setup({
    default_file_explorer = true,
    delete_to_trash = true,
    watch_for_changes = true,
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = false,
    columns = {
        "icon",
        "permissions",
        "size",
        "birthtime",
        "mtime",
        "atime",
    },
    keymaps = {
        ["<CR>"] = "actions.select",
        ["<leader>wv"] = { "actions.select", opts = { vertical = true } },
        ["<leader>wo"] = { "actions.select", opts = { horizontal = true } },
        ["-"]   = { "actions.parent",        mode = "n" },
        ["_"]   = { "actions.open_cwd",      mode = "n" },
        ["g?"]  = { "actions.show_help",     mode = "n" },
        ["gs"]  = { "actions.change_sort",   mode = "n" },
        ["g."]  = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash",  mode = "n" },
        ["g`"]  = { "actions.cd",            mode = "n" },
        ["gp"]  = "actions.preview",
        ["gr"]  = "actions.refresh",
        ["gx"]  = "actions.open_external",
        ["<leader>fF"]  = {
            function()
                require("mini.pick").builtin.files({}, { source = { cwd = require("oil").get_current_dir() } })
            end,
            mode = "n",
            nowait = true,
            desc = "[f]ind [F]iles in the current dir"
        },
        ["<leader>fG"]  = {
            function()
                require("mini.pick").builtin.grep_live({}, { source = { cwd = require("oil").get_current_dir() } })
            end,
            mode = "n",
            nowait = true,
            desc = "[f]ind by [G]rep files in the current dir"
        },
        ["<M-`>"] = {
            function()
                local dir = require("oil").get_current_dir()
                open_split_terminal(dir)
            end,
            nowait = true,
            mode = "n",
            desc = "Open terminal in current file's directory"
        },
    },
    float = {
        preview_split = "auto",
    },
    win_options = {
        winbar = "%!v:lua.get_oil_winbar()",
        signcolumn = "yes:2",
        wrap = true,
        signcolumn = "yes",
        foldcolumn = "0",
        list = true,
        conceallevel = 3,
        concealcursor = "nvic",
    },
    view_options = {
        show_hidden = true,
        natural_order = "fast",
        case_insensitive = false,
        sort = {
            { "type", "asc" },
            { "name", "asc" },
        },
        highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
            return nil
        end,
        is_always_hidden = function(name, bufnr)
            return false
        end,
    },
})
require("oil-git-status").setup()
keymap_set("n", "<leader>-", "<CMD>Oil<CR>", "Open parent directory")

-- Fuzzy Finder ===============================================================
local MiniPick = require("mini.pick")
local MiniExtra = require("mini.extra")

local paste_clipboard = function()
    local reg = vim.fn.getreg("+") or ""
    local text = reg:gsub("[\n\t]", " ")
    local query = MiniPick.get_picker_query() or {}
    for _, ch in ipairs(vim.fn.split(text, [[\zs]])) do
        table.insert(query, ch)
    end
    MiniPick.set_picker_query(query)
end

MiniPick.setup({
    mappings = {
        paste_clipboard = { char = "<C-S-v>", func = paste_clipboard },
    },
})
MiniExtra.setup()

local function grep_word()
    local mode = vim.fn.mode()
    local pattern
    if mode == "v" or mode == "V" or mode == "\22" then
        local _, ls, cs = unpack(vim.fn.getpos("'<"))
        local _, le, ce = unpack(vim.fn.getpos("'>"))
        local lines = vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
        pattern = table.concat(lines, "\n")
    else
        pattern = vim.fn.expand("<cword>")
    end
    if pattern and pattern ~= "" then
        MiniPick.builtin.grep({ pattern = pattern })
    end
end

local function pick_tags(only_current_file)
    local curfile = vim.fn.expand("%:p")
    local raw_tags = vim.fn.taglist(".*")
    if not raw_tags or #raw_tags == 0 then
        vim.notify("No tags found", vim.log.levels.WARN)
        return
    end
    local items = {}
    for _, tag in ipairs(raw_tags) do
        local f = vim.fn.fnamemodify(tag.filename, ":p")
        if not only_current_file or f == curfile then
            local desc = string.format("%s\t%s\t%s", tag.name, tag.filename, tag.cmd or "")
            table.insert(items, {
                text = desc,
                path = f,
                tag = tag,
            })
        end
    end
    if #items == 0 then
        vim.notify(only_current_file and "No tags found for current buffer" or "No tags found", vim.log.levels.WARN)
        return
    end
    local title = only_current_file and "Current Buffer Tags" or "Tags"
    MiniPick.start({
        source = {
            items = items,
            name = title,
            choose = function(item)
                if not item or not item.tag then return end
                vim.cmd.edit(item.tag.filename)
                local cmd = item.tag.cmd
                if cmd then
                    if cmd:match("^%d+$") then
                        vim.api.nvim_win_set_cursor(0, { tonumber(cmd), 0 })
                    else
                        local clean = cmd:gsub("^%^", ""):gsub("%$$", "")
                        clean = clean:gsub([[^/]], ""):gsub([[/$]], "")
                        vim.fn.search(clean)
                    end
                end
            end,
            preview = function(buf_id, item)
                if not item or not item.tag then return end
                MiniPick.default_preview(buf_id, item)
                local cmd = item.tag.cmd
                if cmd then
                    vim.api.nvim_buf_call(buf_id, function()
                        if cmd:match("^%d+$") then
                            vim.api.nvim_win_set_cursor(0, { tonumber(cmd), 0 })
                        else
                            local clean = cmd:gsub("^%^", ""):gsub("%$$", "")
                            clean = clean:gsub([[^/]], ""):gsub([[/$]], "")
                            vim.fn.search(clean)
                        end
                    end)
                end
            end,
        },
    })
end

MiniPick.registry.tags = function() pick_tags(false) end
MiniPick.registry.current_buffer_tags = function() pick_tags(true) end
MiniPick.registry.macrothis = function() require("macrothis").load() end

-- Keymaps
keymap_set("n", "<leader>fk", MiniExtra.pickers.keymaps,                        "[f]ind [k]eymaps")
keymap_set("n", "<leader>ff", MiniPick.builtin.files,                           "[f]ind [f]iles")
keymap_set("n", "<leader>fg", MiniPick.builtin.grep_live,                       "[f]ind [g]rep")
keymap_set("n", "<leader>ft", function() pick_tags(false) end,                  "[f]ind [t]ags")
keymap_set("n", "<leader>fc", function() pick_tags(true) end,                   "[f]ind [c]urrent tags")
keymap_set("n", "<leader>fo", MiniExtra.pickers.oldfiles,                       "[f]ind [o]ldfiles")
keymap_set("n", "<leader>fb", MiniPick.builtin.buffers,                          "[f]ind [b]uffers")
keymap_set("n", "<leader>fG", function()
    MiniPick.builtin.grep_live({}, { source = { cwd = vim.fn.expand("%:p:h") } })
end, "[f]ind [G]rep current file dir")
keymap_set("n", "<leader>fF", function()
    MiniPick.builtin.files({}, { source = { cwd = vim.fn.expand("%:p:h") } })
end, "[f]ind [F]iles current file dir")
keymap_set({"n", "x"}, "<leader>fw", grep_word,                                  "[f]ind [w]ord")
keymap_set("n", "<leader>/", function()
    MiniExtra.pickers.buf_lines({ scope = "current" })
end, "Fuzzily search in current buffer")
keymap_set("n", "<leader>f/", function()
    MiniExtra.pickers.buf_lines({ scope = "all" })
end, "[f]ind Open Files")

-- Git ========================================================================
-- Git Hunk
require("mini.diff").setup({
    mappings = {
        apply = "<leader>gs",
        reset = "<leader>gr",
        textobject = "",
        -- Go to hunk range in corresponding direction
        goto_first = "[H",
        goto_prev = "[h",
        goto_next = "]h",
        goto_last = "]H",
    },
})
keymap_set("n", "<leader>gi", MiniDiff.toggle_overlay, "[g]it [i]nline diff")
vim.api.nvim_create_user_command("DiffInline", MiniDiff.toggle_overlay, {})

-- Git Manager
require("diffview").setup({ use_icons = false, })
require("neogit").setup({
    graph_style = "unicode",
})

-- Time Tracker ===============================================================
if not is_termux() then
    if vim.fn.executable("aw-qt") == 1 then
        vim.opt.runtimepath:append(plugin_path .. "/Manual/aw-watcher-vim")
    end
end

-- AI
-- ============================================================================
vim.api.nvim_create_user_command("AiOpen",  function()
    local target_win = vim.api.nvim_get_current_win()
    local prev_buf = vim.api.nvim_win_get_buf(target_win)
    vim.cmd('startinsert')
    vim.cmd("terminal agy --continue")
    local term_buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_create_autocmd("TermClose", {
        buffer = term_buf,
        once = true,
        callback = function()
            if vim.api.nvim_buf_is_valid(prev_buf) and vim.api.nvim_win_is_valid(target_win) then
                vim.api.nvim_win_set_buf(target_win, prev_buf)
            end
        end,
    })
end, { desc = "Open AI Window" });
