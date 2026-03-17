local color_table = {
    bg          = "#32302F",
    bg_unfocus  = "#282828",
    bg_light    = "#504945",
    bg_lighter  = "#3C3836",
    bg_lighter2 = "#45403D",
    fg          = "#D4BE98",
    fg_dark     = "#A89984",
    green_light = "#A9B665",
    green_dark  = "#89B482",
    red         = "#EA6962",
    yellow      = "#D8A657",
    orange      = "#d08c3d",
    blue        = "#7DAEA3",
    pink        = "#D3869B"
}

-- Settings
-- ============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.nu = true
vim.o.relativenumber = false
vim.o.wrap = true
vim.o.colorcolumn = "80"
vim.o.cursorline = true
vim.o.confirm = true
vim.o.updatetime = 50
vim.o.confirm = true
vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"
vim.o.exrc = true
vim.o.backspace = "indent,eol,start"
vim.o.mouse = "a"
vim.o.fileformats = "unix,dos,mac"

-- Split
vim.o.splitright = true
vim.o.splitbelow = true

-- Scroll
vim.o.scrolloff = 10        -- Number of screen lines keep above and below the cursor.
vim.o.scrolloff = 999       -- Keep cursor centered vertically
vim.o.sidescrolloff = 50    -- Keep cursor centered horizontally
vim.o.undofile = true       -- Undo

-- Tabs
vim.o.tabstop = 4      -- Number of spaces a tab counts for
vim.o.shiftwidth = 4   -- Spaces for each (auto)indent step
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.softtabstop = 4

-- Search and Replace
vim.o.ignorecase = true    -- Not case sensitive
vim.o.smartcase = true     -- Case sensitive if uppercase
vim.o.inccommand = "split"

vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", eol = " ", trail="." }

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
-- ============================================================================

local function is_termux()
    return vim.env.TERMUX_VERSION ~= nil
end

vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
end)

-- Keybindings
-- ============================================================================

local function keymap_set(mode, map, func, desc, opt_override)
    local opt = { desc = desc, noremap = true, silent = true }
    for k, v in pairs(opt_override or {}) do
        opt[k] = v
    end
    vim.keymap.set(mode, map, func, opt)
end

keymap_set("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear Search Highlight")
keymap_set("t", "<Esc>", "<C-\\><C-n>",    "Exit terminal mode")
keymap_set("n", "L", vim.diagnostic.open_float, "Show Diagnostic")
keymap_set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", "Save File")

keymap_set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==",                   "Move Line Down")
keymap_set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==",             "Move Line Up")
keymap_set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi",                                   "Move Line Down")
keymap_set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi",                                   "Move Line Up")
keymap_set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",       "Move Line Down")
keymap_set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", "Move Line Up")

-- Paste
keymap_set("n", "<leader>ep", ":iput<CR>", "[e]dit [p]aste");
keymap_set("x", "P", function() vim.cmd("normal! p") end, "[P]uts before cursor")
keymap_set("x", "p", function() vim.cmd("normal! P") end, "[p]uts after cursor")

-- Split
keymap_set("n", "<leader>wv", "<C-w>v", "[w]indow [v]ertical")
keymap_set("n", "<leader>wo", "<C-w>s", "[w]indow H[o]rizontal")
keymap_set("n", "<leader>wl", "<C-w>l", "[w]indow goto [l]eft")
keymap_set("n", "<leader>wh", "<C-w>h", "[w]indow goto [l]ight")
keymap_set("n", "<leader>wj", "<C-w>j", "[w]indow goto [d]own")
keymap_set("n", "<leader>wk", "<C-w>k", "[w]indow goto [u]p")
keymap_set("n", "<leader>w>", "<C-w>>", "[w]indow increase [>] width")
keymap_set("n", "<leader>w<", "<C-w>>", "[w]indow decrease [<] width")
keymap_set("n", "<leader>wx", "<C-w>x", "[w]indow [x]wap sides")
keymap_set("n", "<leader>ws", "<C-w>w", "[w]indow [s]witch")
keymap_set("n", "<leader>wn", "<C-w>n", "[w]indow [n]ew")
keymap_set("n", "<leader>w=", "<C-w>=", "[w]indow [=]Equal")
keymap_set("n", "<leader>wr", "<cmd>e #<cr>", "[w]indow [r]otate")

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
-- ============================================================================

-- Better whitespace handling
keymap_set("i", "<CR>", "<Space><BS><CR>",   "Enter new line (keep cursor at start of line)")
keymap_set("i", "<Esc>", "<Space><BS><Esc>", "Exit insert mode (keep cursor position unchanged)")
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    callback = function()
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
-- ============================================================================

keymap_set("n", "[b", "<cmd>bprevious<cr>",    "Prev Buffer")
keymap_set("n", "]b", "<cmd>bnext<cr>",        "Next Buffer")
vim.api.nvim_create_user_command("Bda", function() vim.cmd("%bdelete | edit # | bdelete #") end, { desc = "Close all other buffers, keep only current" })
vim.api.nvim_create_user_command("Bd",  function() vim.cmd("bn | bd#") end,                      { desc = "Close previous buffer and move to next" })

-- Autocomplete
-- ============================================================================

vim.o.omnifunc = "syntaxcomplete#Compete"
vim.opt.completeopt:append { "menuone", "preview", "noselect" }
vim.o.complete = ".,w,b,u,U"
keymap_set("i", "<A-n>", "<C-x><C-p>", "Completion from all sources.")
keymap_set("i", "<A-o>", "<C-x><C-o>", "[o]mni-completion")
keymap_set("i", "<A-b>", "<C-x><C-n>", "[b]uffer completion")
keymap_set("i", "<A-i>", "<C-x><C-i>", "[i]nclude file completion")
keymap_set("i", "<A-d>", "<C-x><C-k>", "[d]ictionary completion")
keymap_set("i", "<A-f>", "<C-x><C-f>", "[f]ilename completion")
keymap_set("i", "<A-l>", "<C-x><C-l>", "[l]ine completion")
keymap_set("i", "<A-e>", "<C-e>",      "[e]nd completion")
keymap_set("i", "<Tab>",   'pumvisible() ? "\\<C-n>" : "\\<Tab>"',   "Next completion item (or normal Tab if no menu)",           { expr = true })
keymap_set("i", "<S-Tab>", 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', "Previous completion item (or normal Shift+Tab if no menu)", { expr = true })

-- Terminal
-- ============================================================================

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

if (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1) and not vim.g.neovide then
    keymap_set({"i", "n"}, "†", open_split_terminal, "Open Split Termainl")
else
    keymap_set({"i", "n"}, "<C-`>", open_split_terminal, "Open Split Termainl")
end
keymap_set({"i", "n"}, "<M-`>", function()
    local dir = vim.fn.expand("%:p:h")
    open_split_terminal(dir)
end, "Open in current file directory")

-- Make
-- ============================================================================

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        -- Ant Build
        if vim.fn.filereadable("build.xml") == 1 then
            vim.opt.makeprg="ant compile"
            vim.opt.errorformat="%A\\ %#[javac]\\ %f:%l:\\ error:\\ %m,%-Z\\ %#[javac]\\ %p^,%-C%.%#,%-G%.%#BUILD\\ FAILED%.%#,%-GTotal\\ time:\\ %.%#"
        end
    end,
})

vim.api.nvim_create_autocmd("QuickfixCmdPost", {
    pattern = "make",
    callback = function()
        local qf_list = vim.fn.getqflist()
        local diagnostics = {}
        local current_buf = vim.api.nvim_get_current_buf()
        for _, item in ipairs(qf_list) do
            if item.valid == 1 and item.bufnr == current_buf and item.bufnr > 0 then
                table.insert(diagnostics, {
                    bufnr = item.bufnr,
                    lnum = item.lnum - 1,  -- 0-indexed for diagnostics
                    col = item.col - 1,
                    severity = vim.diagnostic.severity.ERROR,  -- Adjust based on type
                    message = item.text,
                    source = "make",
                })
            end
        end
        vim.diagnostic.set(vim.api.nvim_create_namespace("make_diagnostics"), 0, diagnostics, {})
    end,
})

-- Open quickfix in full width
vim.api.nvim_create_augroup("QuickFix", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = "QuickFix",
    pattern = "qf",
    callback = function()
        vim.cmd("wincmd J")
    end,
})

-- Theme
-- ============================================================================
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.treesitter.stop()
        local links = { "Constant", "Identifier", "Operator", "Special" }
        for _, group in ipairs(links) do
            vim.api.nvim_set_hl(0, group, { fg = color_table.fg })
        end
        -- Code
        vim.api.nvim_set_hl(0, "Statement",         { fg = color_table.pink })
        vim.api.nvim_set_hl(0, "String",            { fg = color_table.green_light })
        vim.api.nvim_set_hl(0, "Comment",           { fg = color_table.green_dark })
        vim.api.nvim_set_hl(0, "Type",              { fg = color_table.blue })
        vim.api.nvim_set_hl(0, "Function",          { fg = color_table.pink })
        vim.api.nvim_set_hl(0, "PreProc",           { fg = color_table.orange })
        -- Markdown
        vim.api.nvim_set_hl(0, "Title",             { fg = color_table.pink })
        vim.api.nvim_set_hl(0, "Delimiter",         { fg = color_table.pink })
        -- Editor
        vim.api.nvim_set_hl(0, "Normal",            { bg = color_table.bg, fg = color_table.fg})
        vim.api.nvim_set_hl(0, "NormalNC",          { bg = color_table.bg_unfocus })
        vim.api.nvim_set_hl(0, "LineNr",            { fg = color_table.fg_dark })
        vim.api.nvim_set_hl(0, "Todo",              { fg = color_table.red, bold = true })
        vim.api.nvim_set_hl(0, "CursorLine",        { bg = color_table.bg_lighter })
        vim.api.nvim_set_hl(0, "Visual",            { bg = color_table.bg_light })
        vim.api.nvim_set_hl(0, "WinSeparator",      { fg = color_table.bg_unfocus, bg = color_table.bg_unfocus })
        vim.api.nvim_set_hl(0, "ColorColumn",       { bg = color_table.bg_lighter })
        vim.api.nvim_set_hl(0, "IndentLineCurrent", { fg = color_table.fg_dark })
        vim.api.nvim_set_hl(0, "IndentLine",        { fg = color_table.bg_light })
        vim.api.nvim_set_hl(0, "commentNote",       { fg = color_table.yellow, bold = true })
        vim.cmd([[syntax keyword commentNote NOTE containedin=.*Comment.*]])
    end,
})

-- Neovim Gui
-- ============================================================================

if vim.g.neovide then
    vim.o.guifont = "Consolas:h12"
    keymap_set({ "n", "v" }, "<C-=>",   ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>", "Neovide: Increase font size")
    keymap_set({ "n", "v" }, "<C-->",   ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>", "Neovide: Decrease font size")
    keymap_set({ "n", "v" }, "<C-0>",   ":lua vim.g.neovide_scale_factor = 1<CR>",                                "Neovide: Reset font size to default")
    keymap_set("n",          "<C-S-v>", '"+P',         "Paste from system clipboard (after cursor)")
    keymap_set("v",          "<C-S-v>", '"+P',         "Paste from system clipboard (replace selection)")
    keymap_set("i",          "<C-S-v>", '<ESC>l"+Pli', "Paste from system clipboard in insert mode")
    keymap_set("c",          "<C-S-v>", "<C-R>+",      "Paste from system clipboard in command-line mode")
    local neovide_fullscreen = true
    keymap_set({"n", "i", "t", "x"}, "<F11>", function()
        neovide_fullscreen = not neovide_fullscreen
        vim.g.neovide_fullscreen = neovide_fullscreen
        vim.notify("Full Screen")
    end, "Full Screen")
end

-- Plugins
-- ============================================================================

-- Load Built-in Plugins ======================================================

vim.cmd("packadd justify")
vim.cmd("packadd nvim.difftool")

-- Load External Plugins ======================================================

local plugin_path = vim.fn.stdpath("config") .. "/plugins"
vim.opt.runtimepath:append(plugin_path .. "/*")

-- Theme ======================================================================

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
    options = { theme = "gruvbox-material" },
})

-- Indent
require("indentmini").setup()

-- Wildcard
require("wilder").setup({ modes = {":", "/", "?"} })

-- Editing ====================================================================

-- Undo
require("select-undo").setup()

-- Smart Auto Indent
require("guess-indent").setup()

-- Multicursor
require("multicursor-nvim").setup()
keymap_set({"n", "x"}, "<C-k>", function() require("multicursor-nvim").lineAddCursor(-1) end,    "Add cursor ↑")
keymap_set({"n", "x"}, "<C-j>", function() require("multicursor-nvim").lineAddCursor(1) end,     "Add cursor ↓")
keymap_set({"n", "x"}, "<C-d>", function() require("multicursor-nvim").matchAddCursor(1) end,    "Add cursor to next match")
keymap_set({"n", "x"}, "<C-S-d>", function() require("multicursor-nvim").matchAddCursor(-1) end, "Add cursor to prev match")
keymap_set("n", "<c-leftmouse>",   require("multicursor-nvim").handleMouse,        "Multi-cursor click")
keymap_set("n", "<c-leftdrag>",    require("multicursor-nvim").handleMouseDrag,    "Multi-cursor drag")
keymap_set("n", "<c-leftrelease>", require("multicursor-nvim").handleMouseRelease, "Multi-cursor release")
require("multicursor-nvim").addKeymapLayer(function(layer_set)
    layer_set({"n", "x"}, "<C-s>",  function() require("multicursor-nvim").matchSkipCursor(1) end)
    layer_set({"n", "x"}, "<C-S-s>", function() require("multicursor-nvim").matchSkipCursor(-1) end)
    -- Select a different cursor as the main one.
    layer_set({"n", "x"}, "<up>",   require("multicursor-nvim").prevCursor)
    layer_set({"n", "x"}, "<down>", require("multicursor-nvim").nextCursor)
    -- Delete the main cursor.
    layer_set({"n", "x"}, "<leader>x", require("multicursor-nvim").deleteCursor)
    -- Enable and clear cursors using escape.
    layer_set("n", "<esc>", function()
        if not require("multicursor-nvim").cursorsEnabled() then
            require("multicursor-nvim").enableCursors()
        else
            require("multicursor-nvim").clearCursors()
        end
    end)
end)
vim.api.nvim_set_hl(0, "MultiCursorCursor", { fg = color_table.bg_lighter, bg = color_table.fg_dark })

-- Bracket Split and Join
require("mini.splitjoin").setup({
    mappings = {
        toggle = "<leader>et",
    },
})

-- Better "f", "t", "F", "T"
require("flash").setup({
  modes = {
    char = {
      -- jump_labels = true
    }
  }
})
keymap_set({ "n", "x", "o" }, "<leader>ef", function() require("flash").jump() end,              "[e]dit [f]lash")
keymap_set({ "n", "x", "o" }, "<leader>eF", function() require("flash").treesitter() end,        "[e]dit [F]lashback")
keymap_set({ "o", "x" },      "<leader>er", function() require("flash").treesitter_search() end, "Treesitter Search")
keymap_set("o",               "<leader>eR", function() require("flash").remote() end,            "Remote Flash")
-- keymap_set({ "c" },           "<c-s>",  function() require("flash").toggle() end,            "Toggle Flash Search")

-- Better "w", "e" and "b"
keymap_set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", "Next sub[w]ord")
keymap_set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", "[e]nd of next subword")
keymap_set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", "[b]ack subword")

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
        { mode = "n", keys = "<Leader>f",  desc = "[f]ind" },
        { mode = "n", keys = "<Leader>e",  desc = "[e]dit" },
        { mode = "n", keys = "<Leader>m",  desc = "[m]ark" },
        { mode = "n", keys = "<Leader>s",  desc = "[s]urround" },
        { mode = "n", keys = "<Leader>w",  desc = "[w]indow" },
        { mode = "n", keys = "<Leader>g",  desc = "[g]it" },
        { mode = "n", keys = "<Leader>d",  desc = "[d]ebugger" },
        { mode = "n", keys = "<Leader>dg", desc = "[d]ebugger [g]oto" },
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

-- Session Manager ============================================================
require("auto-session").setup()

-- Undo History ===============================================================
require("atone").setup()
vim.api.nvim_create_user_command("UndoTree", ":Atone toggle", {})

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

-- Code Mark
require("fusen").setup({
    keymaps = {},
    telescope = {
        keymaps = {
            delete_mark_insert = "<C-x>",  -- Custom key for insert mode
            delete_mark_normal = "dd",     -- Custom key for normal mode
        },
    },
})
keymap_set("n", "<leader>me", ":FusenAddMark<CR>",          "[m]ark add and [e]dit code")
keymap_set("n", "<leader>md", ":FusenClearMark<CR>",        "[m]ark delete code")
keymap_set("n", "<leader>mn", ":FusenNext<CR>",             "[m]ark goto [n]ext code")
keymap_set("n", "<leader>mN", ":FusenPrev<CR>",             "[m]ark goto [p]rev code")
keymap_set("n", "<leader>mc", ":Telescope fusen marks<CR>", "[m]ark [c]ode menu")

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
                require("telescope.builtin").find_files({ cwd = require("oil").get_current_dir() })
            end,
            mode = "n",
            nowait = true,
            desc = "[f]ind [F]iles in the current dir"
        },
        ["<leader>fG"]  = {
            function()
                require("telescope.builtin").live_grep({ cwd = require("oil").get_current_dir() })
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
-- vim.opt.runtimepath:append(plugin_path .. "/telescope-fzf-native.nvim")
-- build = "make",
-- cond = function()
--     return vim.fn.executable "make" == 1
-- end,
require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ["<C-S-v>"] = { "<C-r>+", type = "command" },
            },
        },
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
        },
    },
}
-- Enable Telescope extensions if they are installed
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")
-- Keymaps
keymap_set("n", "<leader>fk", require("telescope.builtin").keymaps,             "[f]ind [k]eymaps")
keymap_set("n", "<leader>ff", require("telescope.builtin").find_files,          "[f]ind [f]iles")
keymap_set("n", "<leader>fg", require("telescope.builtin").live_grep,           "[f]ind [g]rep")
keymap_set("n", "<leader>ft", require("telescope.builtin").tags,                "[f]ind [t]ags")
keymap_set("n", "<leader>fc", require("telescope.builtin").current_buffer_tags, "[f]ind [c]urrent tags")
keymap_set("n", "<leader>fo", require("telescope.builtin").oldfiles,            "[f]ind [o]ldfiles")
keymap_set("n", "<leader>fb", require("telescope.builtin").buffers,             "[f]ind [b]uffers")
keymap_set("n", "<leader>fG", function()
    require("telescope.builtin").live_grep({ cwd = "%:p:h" })
end, "[f]ind [G]rep current file dir")
keymap_set("n", "<leader>fF", function()
    require("telescope.builtin").find_files({ cwd = "%:p:h" })
end, "[f]ind [F]iles current file dir")
keymap_set({"n", "x"}, "<leader>fw", require("telescope.builtin").grep_string,         "[f]ind [w]ord")
keymap_set("n", "<leader>/", function()
    require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, "Fuzzily search in current buffer")
keymap_set("n", "<leader>f/", function()
    require("telescope.builtin").live_grep {
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
    }
end, "[f]ind Open Files")

-- Debugger ===================================================================

vim.api.nvim_create_autocmd("CmdlineEnter", {
  callback = function()
    local cmd = vim.fn.getcmdline()
    if vim.fn.exists(":Termdebug") == 0 then
        vim.cmd("packadd termdebug")
    end
end,
})

vim.g.termdebug_config = {
    disasm_window = true,
    variables_window = true,
    wide = 10,
    disasm_window = 15,
    variables_window = 15,
    command = {
        "gdb", "-nx",
        "-ex", "set breakpoint pending on",
        "-ex", "set disassembly-flavor intel",
        "-ex", "set confirm off",
        "-ex", "set print pretty on",
    }
}
local termdebug_keys = {
    { "n", "<leader>dr",  ":call TermDebugSendCommand('run')<CR>",      "[d]ebugger [r]un" },
    { "n", "<leader>dc",  ":call TermDebugSendCommand('continue')<CR>", "[d]ebugger [c]ontinue" },
    { "n", "<leader>de",  ":call TermDebugSendCommand('exit')<CR>",     "[d]ebugger [e]xit" },
    { "n", "<leader>dk",  ":call TermDebugSendCommand('kill')<CR>",     "[d]ebugger [k]ill" },
    { "n", "<leader>db",  ":Break<CR>",                                 "[d]ebugger [b]reakpoint" },
    { "n", "<leader>du",  ":Clear<CR>",                                 "[d]ebugger [u]nbreakpoint" },
    { "n", "<leader>dt",  ":Tbreak<CR>",                                "[d]ebugger [t]reak" },
    { "n", "<leader>dc",  ":Continue<CR>",                              "[d]ebugger [c]ontinue" },
    { "n", "<leader>dgg", ":Gdb<CR>",                                   "[d]ebugger [g]oto [g]db" },
    { "n", "<leader>dgp", ":Program<CR>",                               "[d]ebugger [g]oto [p]rogram" },
    { "n", "<leader>dgs", ":Source<CR>",                                "[d]ebugger [g]oto [s]ource" },
    { "n", "<leader>dga", ":Asm<CR>",                                   "[d]ebugger [g]oto [a]ssembly" },
    { "n", "<leader>dgl", ":Var<CR>",                                   "[d]ebugger [g]oto [l]ocal watchlist" },
    { "n", "<F1>",        ":Over<CR>",                                  "Debugger Next" },
    { "n", "<F2>",        ":Step<CR>",                                  "Debugger Step" },
    { "n", "=",           ":Up<CR>",                                    "Debugger go Up frame" },
}
local current_debug_edit_file=""
vim.api.nvim_create_autocmd("User", {
    pattern = "TermdebugStartPre",
    callback = function()
        for _, k in ipairs(termdebug_keys) do
            keymap_set(k[1], k[2], k[3], k[4])
        end
        current_debug_edit_file=vim.api.nvim_buf_get_name(0)
        vim.cmd.tabnew()
    end,
})
vim.api.nvim_create_autocmd("User", {
    pattern = "TermdebugStartPost",
    callback = function()
        vim.cmd("Gdb")
        vim.cmd("wincmd K")
        vim.cmd("Source")
        vim.cmd.edit(current_debug_edit_file)
        vim.cmd("wincmd K")
        vim.cmd.resize(30)
        vim.cmd("Program")
        vim.cmd.resize(15)
        vim.cmd("Asm")
        vim.cmd.resize(6)
        vim.cmd("Source")
    end,
})
vim.api.nvim_create_autocmd("User", {
    pattern = "TermdebugStopPre",
    callback = function()
        vim.cmd("Source")
        current_debug_edit_file=vim.api.nvim_buf_get_name(0)
        vim.cmd("Gdb")
        vim.cmd("Bd")
    end,
})
vim.api.nvim_create_autocmd("User", {
    pattern = "TermdebugStopPost",
    callback = function()
        for _, k in ipairs(termdebug_keys) do
            pcall(vim.keymap.del, k[1], k[2])
        end
        vim.cmd.tabclose()
        vim.cmd.edit(current_debug_edit_file)
    end,
})

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
vim.api.nvim_create_user_command("DiffInline", MiniDiff.toggle_overlay, {})

-- Git Manager
require("diffview").setup({ use_icons = false, })
require("neogit").setup({
    graph_style = "unicode",
})

-- Time Tracker ===============================================================
if not is_termux() then
    vim.opt.runtimepath:append(plugin_path .. "/Manual/aw-watcher-vim")
end
require("visimatch").setup({
    chars_lower_limit = 2,
})
