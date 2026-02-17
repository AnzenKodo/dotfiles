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
-- vim.o.laststatus = 3

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
vim.o.inccommand = 'split'

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', eol = ' ', trail="." }

-- Useless Settings
vim.o.swapfile = false
vim.o.backup = false

-- Auto Reload file
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    pattern = { "*" },
    callback = function()
        if vim.fn.getcmdwintype() == '' and vim.fn.mode() ~= 'c' then
            vim.cmd('checktime')
        end
    end,
})

-- Clipboard
-- ============================================================================

local function is_termux()
    return vim.env.TERMUX_VERSION ~= nil
end

vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
end)

-- Neovim Gui
-- ============================================================================

if vim.g.neovide then
    vim.o.guifont = "Consolas:h12"
    vim.keymap.set({ "n", "v" }, "<C-=>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
    vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
    vim.keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")

    vim.keymap.set('n', '<C-S-v>', '"+P')
    vim.keymap.set('v', '<C-S-v>', '"+P')
    vim.keymap.set('i', '<C-S-v>', '<ESC>l"+Pli')
    vim.keymap.set('c', '<C-S-v>', '<C-R>+')

    local neovide_fullscreen = true
    vim.keymap.set({'n', 'i', 't', 'x'}, '<F11>', function()
        neovide_fullscreen = not neovide_fullscreen
        vim.g.neovide_fullscreen = neovide_fullscreen
        vim.notify("Full Screen")
    end, { desc = "Full Screen" })
end

-- Utils Functions
-- ============================================================================

local function get_visual_selection()
    local s_start = vim.fn.getpos("'<")
    local s_end = vim.fn.getpos("'>")
    local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
    if #lines == 0 then return '' end
    lines[1] = lines[1]:sub(s_start[3], -1)
    lines[#lines] = lines[#lines]:sub(1, s_end[3])
    return table.concat(lines, '\n')
end


local function win_to_bash_path(win_path)
    if not win_path or win_path == "" then
        return win_path
    end
    win_path = win_path:gsub("\\", "/")
    if win_path:match("^[A-Za-z]:/") then
        local drive = win_path:sub(1, 1):lower()
        win_path = "/" .. drive .. win_path:sub(3)
    end
    return win_path
end

function open_buffer_in_other_split()
    local filename = vim.api.nvim_buf_get_name(0)
    local win_count = #vim.api.nvim_list_wins()
    local pos = vim.api.nvim_win_get_cursor(0)
    local line = pos[1]
    local col = pos[2] + 1  -- Neovim uses 0-based columns
    if win_count == 1 then
        vim.cmd('vsplit')
    else
        vim.cmd('wincmd w')
    end
    vim.cmd('edit ' .. filename)
    vim.api.nvim_win_set_cursor(0, {line, col})
end

-- Keybindings
-- ============================================================================

vim.keymap.set("n", '<Esc>', '<cmd>nohlsearch<CR>', { desc = "Clear Search Highlight" })
vim.keymap.set("t", '<Esc>', '<C-\\><C-n>',    { desc = 'Exit terminal mode' })
vim.keymap.set('n', 'L', vim.diagnostic.open_float, { desc = 'Show Diagnostic' })
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

vim.keymap.set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==",                   { desc = "Move Line Down" })
vim.keymap.set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==",             { desc = "Move Line Up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi",                                   { desc = "Move Line Down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi",                                   { desc = "Move Line Up" })
vim.keymap.set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",       { desc = "Move Line Down" })
vim.keymap.set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Line Up" })

-- Paste
vim.keymap.set('n', 'p', ':iput<CR>', { silent = true });
vim.keymap.set('x', 'P', function() vim.cmd('normal! p') end, { silent = true })
vim.keymap.set('x', 'p', function() vim.cmd('normal! P') end, { silent = true })

-- Split
vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = '[w]indow [v]ertical' })
vim.keymap.set('n', '<leader>wo', '<C-w>s', { desc = '[w]indow H[o]rizontal' })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = '[w]indow goto [l]eft' })
vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = '[w]indow goto [l]ight' })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { desc = '[w]indow goto [d]own' })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { desc = '[w]indow goto [u]p' })
vim.keymap.set('n', '<leader>w>', '<C-w>>', { desc = '[w]indow increase [>] width' })
vim.keymap.set('n', '<leader>w<', '<C-w>>', { desc = '[w]indow decrease [<] width' })
vim.keymap.set('n', '<leader>wx', '<C-w>x', { desc = '[w]indow [x]wap sides' })
vim.keymap.set('n', '<leader>ws', '<C-w>w', { desc = '[w]indow [s]witch' })
vim.keymap.set('n', '<leader>wn', '<C-w>n', { desc = '[w]indow [n]ew' })
vim.keymap.set('n', '<leader>w=', '<C-w>=', { desc = '[w]indow [=]Equal' })
vim.keymap.set('n', '<leader>wr', "<cmd>e #<cr>", { desc = '[w]indow [r]otate' })

local toggle_state = false
vim.keymap.set('n', '<leader>w/', function()
    toggle_state = not toggle_state
    if toggle_state then
        -- Maximize current window vertically and horizontally
        vim.cmd('wincmd |')
        vim.cmd('wincmd _')
    else
        -- Equalize all windows
        vim.cmd('wincmd =')
    end
end, { desc = '[w]indow Toggle' })
vim.keymap.set('n', '<leader>wd', function()
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
        vim.cmd('vsplit')
        vim.api.nvim_set_current_buf(current_buf)
    end
    if vim.api.nvim_win_get_buf(target_win) ~= current_buf then
        vim.api.nvim_set_current_buf(current_buf)
    end
    vim.api.nvim_win_set_cursor(0, current_line)
end, {desc = '[w]indow [d]uplicate' })
vim.keymap.set({'n', 'v'}, '<leader>wf', function()
    local original_win = vim.api.nvim_get_current_win()
    local mode = vim.api.nvim_get_mode().mode
    local file_spec
    if mode == 'v' or mode == 'V' or mode == '\22' then
        file_spec = get_visual_selection():match("^[^\n]+")  -- Get first line of selection
    else
        file_spec = vim.fn.expand("<cWORD>")
    end
    local fileInfo = vim.fn.split(file_spec, ":")
    local file = fileInfo[1]
    local line = fileInfo[2] or '1'
    local column = fileInfo[3] or '1'
    if mode == 'v' or mode == 'V' or mode == '\22' then
        vim.cmd('normal! \27')  -- Exit visual mode
    end
    local wins = vim.api.nvim_list_wins()
    local target_win
    if #wins == 1 then
        vim.cmd('vsplit')
        target_win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_call(target_win, function()
            vim.cmd('edit ' .. vim.fn.fnameescape(file))
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
            vim.cmd('edit ' .. vim.fn.fnameescape(file))
        end)
        vim.api.nvim_win_set_cursor(target_win, {tonumber(line), tonumber(column) - 1})
    end
end, { desc = "[w]indow goto [f]ile", noremap = true })

-- Better Search Next
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'",  { expr = true, desc = "Next Search Result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]",       { expr = true, desc = "Next Search Result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]",       { expr = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'",  { expr = true, desc = "Prev Search Result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]",       { expr = true, desc = "Prev Search Result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]",       { expr = true, desc = "Prev Search Result" })

-- Autocommands
-- ============================================================================

-- Remove Trim Trailing Whitespace
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function()
      local path = vim.api.nvim_buf_get_name(0)
      if not path:find("neo", 1, true) then
          vim.cmd([[%s/\s\+$//e]])
      end
  end,
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
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

-- Highlight current matching words
-- vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI", "ModeChanged"}, {
--     callback = function()
--         min_length_cursor_len = 3
--         vim.api.nvim_set_hl(0, "CursorWord", { bg = color_table.bg_lighter2 })
--         local column = vim.api.nvim_win_get_cursor(0)[2]
--         local line = vim.api.nvim_get_current_line()
--         local cursorword = vim.fn.matchstr(line:sub(1, column + 1), [[\k*$]])
--         .. vim.fn.matchstr(line:sub(column + 1), [[^\k*]]):sub(2)
--
--         local mode = vim.fn.mode()
--         if mode ~= "n" and mode ~= "N" then
--             vim.api.nvim_set_hl(0, "CursorWord", {})
--             return
--         end
--         if cursorword == vim.w.cursorword then
--             return
--         end
--         vim.w.cursorword = cursorword
--         if vim.w.cursorword_id then
--             vim.call("matchdelete", vim.w.cursorword_id)
--             vim.w.cursorword_id = nil
--         end
--         if
--             cursorword == ""
--             or #cursorword > 100
--             or #cursorword < min_length_cursor_len
--             or string.find(cursorword, "[\192-\255]+") ~= nil
--         then
--             return
--         end
--         local pattern = [[\<]] .. cursorword .. [[\>]]
--         vim.w.cursorword_id = vim.fn.matchadd("CursorWord", pattern, -1)
--     end
-- })

-- Buffers
-- ============================================================================

vim.keymap.set("n", "[b", "<cmd>bprevious<cr>",    { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>",        { desc = "Next Buffer" })
vim.api.nvim_create_user_command("Bda", function() vim.cmd("%bdelete|edit #|bdelete #") end, {})
vim.api.nvim_create_user_command("Bd",  function() vim.cmd("bn | bd#") end, {})

-- Autocomplete
-- ============================================================================

vim.o.omnifunc = "syntaxcomplete#Compete"
vim.opt.completeopt:append { "menuone", "preview", "noselect" }
vim.o.complete = ".,w,b,u,U"
vim.keymap.set('i', '<A-n>', '<C-x><C-p>', { noremap = true }, { desc = 'Completion from all sources.' })
vim.keymap.set('i', '<A-o>', '<C-x><C-o>', { noremap = true }, { desc = '[O]mni-completion' })
vim.keymap.set('i', '<A-b>', '<C-x><C-n>', { noremap = true }, { desc = '[B]uffer completion' })
vim.keymap.set('i', '<A-i>', '<C-x><C-i>', { noremap = true }, { desc = '[I]nclude file completion' })
vim.keymap.set('i', '<A-d>', '<C-x><C-k>', { noremap = true }, { desc = '[D]ictionary completion' })
vim.keymap.set('i', '<A-f>', '<C-x><C-f>', { noremap = true }, { desc = '[F]ilename completion' })
vim.keymap.set('i', '<A-l>', '<C-x><C-l>', { noremap = true }, { desc = '[L]ine completion' })
vim.keymap.set('i', '<A-e>', '<C-e>',      { noremap = true }, { desc = '[E]nd completion' })
vim.keymap.set('i', '<Tab>',   'pumvisible() ? "\\<C-n>" : "\\<Tab>"', { expr = true })
vim.keymap.set('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', { expr = true })

-- function fill_cmp()
--     local ext = vim.bo.filetype
--     if ext == '' then return end
--     local cmd
--     if vim.fn.executable('fd') == 1 then
--         cmd = { 'fd', '--type', 'f', '--hidden', '--no-ignore', '--extension', ext, '.' }
--     elseif vim.fn.executable('rg') == 1 then
--         cmd = { 'rg', '--files', '--hidden', '--no-ignore', '--glob', '*.' .. ext }
--     else
--         cmd = { 'find', '.', '-type', 'f', '-name', '*.' .. ext }
--     end
--     local job = vim.fn.jobstart(cmd, {
--         stdout_buffered = true,
--         on_exit = function(_, code)
--             if code ~= 0 then return end
--             local files = vim.fn.systemlist(cmd)
--             -- Filter out directories (unlikely with --type f) and hidden if desired
--             files = vim.tbl_filter(function(f) return f ~= '' and not f:match('/%..*') end, files)
--             if #files == 0 then return end
--             vim.schedule(function()
--                 vim.o.dictionary = table.concat(files, ',')
--             end)
--         end,
--     })
--
--     if job <= 0 then
--         print('Failed to start job for dictionary setup')
--     end
-- end
--
-- vim.api.nvim_create_autocmd("BufEnter", {
--     callback = fill_cmp
-- })

-- Terminal
-- ============================================================================

function open_split_terminal()
    vim.cmd.new()
    vim.cmd.wincmd "J"
    vim.api.nvim_win_set_height(0, 12)
    vim.wo.winfixheight = true
    vim.cmd.term("bash")
end

if (vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1) and not vim.g.neovide then
    vim.keymap.set({"i", "n"}, "†", open_split_terminal, { desc = "Open Split Termainl" })
else
    vim.keymap.set({"i", "n"}, "<C-`>", open_split_terminal, { desc = "Open Split Termainl" })
end

-- Tags
-- ============================================================================

vim.o.tags = "tags"
vim.keymap.set('n', ']g', '<C-]>', { desc = 'Jump to definition' })
vim.keymap.set('n', '[g', '<C-t>', { desc = 'Return from jump' })
vim.keymap.set('n', '<leader>wg', '<cmd>lua open_buffer_in_other_split()<CR><C-]> ', { desc = "[w]indow [g]oto definition" })
vim.keymap.set('n', '<leader>wt', '<cmd>lua open_buffer_in_other_split()<CR>g]',     { desc = "[w]indow show [t]ag" })

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
        vim.api.nvim_set_hl(0, 'Function',          { fg = color_table.pink })
        vim.api.nvim_set_hl(0, 'PreProc',           { fg = color_table.orange })
        -- Markdown
        vim.api.nvim_set_hl(0, 'Title',             { fg = color_table.pink })
        vim.api.nvim_set_hl(0, 'Delimiter',         { fg = color_table.pink })
        -- Editor
        vim.api.nvim_set_hl(0, "Normal",            { bg = color_table.bg, fg = color_table.fg})
        vim.api.nvim_set_hl(0, "NormalNC",          { bg = color_table.bg_unfocus })
        vim.api.nvim_set_hl(0, "LineNr",            { fg = color_table.fg_dark })
        vim.api.nvim_set_hl(0, "Todo",              { fg = color_table.red, bold = true })
        vim.api.nvim_set_hl(0, "CursorLine",        { bg = color_table.bg_lighter })
        vim.api.nvim_set_hl(0, "Visual",            { bg = color_table.bg_light })
        vim.api.nvim_set_hl(0, "WinSeparator",      { fg = color_table.bg_unfocus, bg = color_table.bg_unfocus })
        vim.api.nvim_set_hl(0, 'ColorColumn',       { bg = color_table.bg_lighter })
        vim.api.nvim_set_hl(0, "IndentLineCurrent", { fg = color_table.fg_dark })
        vim.api.nvim_set_hl(0, "IndentLine",        { fg = color_table.bg_light })
        vim.api.nvim_set_hl(0, "commentNote",       { fg = color_table.yellow, bold = true })
        vim.cmd([[syntax keyword commentNote NOTE containedin=.*Comment.*]])
    end,
})

-- Plugins
-- ============================================================================

-- Load Built-in Plugins ======================================================

vim.cmd('packadd justify')
vim.cmd('packadd nvim.difftool')

-- Load External Plugins ======================================================

local plugin_path = vim.fn.stdpath("config") .. "/plugins"
vim.opt.runtimepath:append(plugin_path .. "/*")

-- Theme ======================================================================

-- Status Line
require('lualine').setup({
    sections = {
        lualine_c = {
            {
                'filename',
                path = 1, -- Show absolute path
                file_status = true, -- Show file status
            }
        }
    },
    options = { theme = 'gruvbox-material' },
})

-- Indent
require("indentmini").setup()

-- Wildcard
require('wilder').setup({ modes = {':', '/', '?'} })

-- Editing ====================================================================

-- Undo
require('select-undo').setup()

-- Smart Auto Indent
require('guess-indent').setup()

-- Multicursor
require("multiple-cursors").setup()
vim.keymap.set({"n", "x"}, "<C-k>", "<Cmd>MultipleCursorsAddUp<CR>",            { desc = "Add cursor and move up" })
vim.keymap.set({"n", "i"}, "<C-h>", "<Cmd>MultipleCursorsMouseAddDelete<CR>",   { desc = "Add or remove cursor" })
vim.keymap.set({"n", "x"}, "<C-j>", "<Cmd>MultipleCursorsAddDown<CR>",          { desc = "Add cursor and move down" })
vim.keymap.set({"x"},      "<C-x>", "<Cmd>MultipleCursorsAddVisualArea<CR>",    { desc = "Add cursors to the lines of the visual area" })
vim.keymap.set({"n", "x"}, "<C-l>", "<Cmd>MultipleCursorsLock<CR>",             { desc = "Lock virtual cursors" })

-- Bracket Split and Join
require('mini.splitjoin').setup({
    mappings = {
        toggle = '<leader>et',
    },
})

-- Better 'f', 't', 'F', 'T'
require("flash").setup({
  modes = {
    char = {
      -- jump_labels = true
    }
  }
})
vim.keymap.set({ "n", "x", "o" }, "<leader>ef", function() require("flash").jump() end,              { desc = "[e]dit [f]lash" })
vim.keymap.set({ "n", "x", "o" }, "<leader>eF", function() require("flash").treesitter() end,        { desc = "[e]dit [F]lashback" })
vim.keymap.set({ "o", "x" },      "<leader>er", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
vim.keymap.set("o",               "<leader>eR", function() require("flash").remote() end,            { desc = "Remote Flash" })
-- vim.keymap.set({ "c" },           "<c-s>",  function() require("flash").toggle() end,            { desc = "Toggle Flash Search" })

-- Better 'w', 'e' and 'b'
vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>")
vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>")
vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>")

-- Surround
require('mini.surround').setup({
    mappings = {
        add = '<leader>sa', -- Add surrounding in Normal and Visual modes
        delete = '<leader>sd', -- Delete surrounding
        find = '<leader>sf', -- Find surrounding (to the right)
        find_left = '<leader>sF', -- Find surrounding (to the left)
        highlight = '<leader>sh', -- Highlight surrounding
        replace = '<leader>sr', -- Replace surrounding
        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
    },
    highlight_duration = 1000,
})
require('mini.ai').setup()

-- Keymap Helper ==============================================================
local miniclue = require('mini.clue')
miniclue.setup({
    triggers = {
        { mode = { 'n', 'x' }, keys = '<Leader>' },
        { mode = 'n', keys = '[' },
        { mode = 'n', keys = ']' },
        { mode = 'i', keys = '<C-x>' },
        { mode = { 'n', 'x' }, keys = 'g' },
        { mode = { 'n', 'x' }, keys = "'" },
        { mode = { 'n', 'x' }, keys = '`' },
        { mode = { 'n', 'x' }, keys = '"' },
        { mode = { 'i', 'c' }, keys = '<C-r>' },
        { mode = 'n', keys = '<C-w>' },
        { mode = { 'n', 'x' }, keys = 'z' },
    },
    clues = {
        miniclue.gen_clues.square_brackets(),
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
        { mode = 'n', keys = '<Leader>f',  desc = '[f]ind' },
        { mode = 'n', keys = '<Leader>e',  desc = '[e]dit' },
        { mode = 'n', keys = '<Leader>m',  desc = '[m]ark' },
        { mode = 'n', keys = '<Leader>s',  desc = '[s]urround' },
        { mode = 'n', keys = '<Leader>w',  desc = '[w]indow' },
        { mode = 'n', keys = '<Leader>g',  desc = '[g]it' },
        { mode = 'n', keys = '<Leader>d',  desc = '[d]ebugger' },
        { mode = 'n', keys = '<Leader>dg', desc = '[d]ebugger [g]oto' },
    },
    window = {
        -- Floating window config
        config = {
            width = 'auto'
        },
        -- Delay before showing clue window
        delay = 10,
        -- Keys to scroll inside the clue window
        scroll_down = '<C-d>',
        scroll_up = '<C-u>',
    },
})

-- Session Manager ============================================================
require("auto-session").setup()

-- Undo History ===============================================================
vim.api.nvim_create_user_command("UndoTree", require("undotree").toggle, {})

-- Better Quickfix ============================================================
require("quicker").setup()
vim.keymap.set("n", "<leader>l", function() require("quicker").toggle({ loclist = true }) end, { desc = "Toggle loclist" })
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
require('marko').setup({
  default_keymap = false,
})
vim.keymap.set('n', '<leader>mm', function() require('marko').show_marks() end, { desc = 'Show marks popup' })

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
            desc = "[f]ind by [g]rep files in the current dir"
        },
        ["<M-`>"] = {
            function()
                local dir = require("oil").get_current_dir()
                vim.cmd.new()
                vim.api.nvim_win_set_height(0, 12)
                vim.wo.winfixheight = true
                vim.fn.termopen("bash", { cwd = dir })
                vim.cmd.startinsert()
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
vim.keymap.set("n", "<leader>-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Fuzzy Finder ===============================================================
-- vim.opt.runtimepath:append(plugin_path .. "/telescope-fzf-native.nvim")
-- build = 'make',
-- cond = function()
--     return vim.fn.executable 'make' == 1
-- end,
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ["<C-S-v>"] = { "<C-r>+", type = "command" },
            },
        },
    },
    extensions = {
        ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
        },
    },
}
-- Enable Telescope extensions if they are installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')
-- Keymaps
vim.keymap.set('n', '<leader>fk', require('telescope.builtin').keymaps,             { desc = '[f]ind [k]eymaps' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files,          { desc = '[f]ind [f]iles' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep,           { desc = '[f]ind [g]rep' })
vim.keymap.set('n', '<leader>ft', require('telescope.builtin').tags,                { desc = '[f]ind [t]ags' })
vim.keymap.set('n', '<leader>fc', require('telescope.builtin').current_buffer_tags, { desc = '[f]ind [c]urrent tags' })
vim.keymap.set('n', '<leader>fo', require('telescope.builtin').oldfiles,            { desc = '[f]ind [o]ldfiles' })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers,             { desc = '[f]ind [b]uffers' })
vim.keymap.set('n', '<leader>fG', function()
    require('telescope.builtin').live_grep({ cwd = "%:p:h" })
end, { desc = '[f]ind [G]rep current file dir' })
vim.keymap.set('n', '<leader>fF', function()
    require("telescope.builtin").find_files({ cwd = "%:p:h" })
end, { desc = '[F]ind [F]iles current file dir' })
vim.keymap.set({'n', 'x'}, '<leader>fw', require('telescope.builtin').grep_string,         { desc = '[f]ind [w]ord' })
vim.keymap.set('n', '<leader>/', function()
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = 'Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>f/', function()
    require('telescope.builtin').live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
    }
end, { desc = '[F]ind Open Files' })

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
    }
}
local termdebug_keys = {
    { "n", "<leader>ds",  ":call TermDebugSendCommand('run')<CR>",      "[d]ebugger [s]tart" },
    { "n", "<leader>dc",  ":call TermDebugSendCommand('continue')<CR>", "[d]ebugger [c]ontinue" },
    { "n", "<leader>dr",  ":call TermDebugSendCommand('restart')<CR>",  "[d]ebugger [r]estart" },
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
}
local current_debug_edit_file=""
vim.api.nvim_create_autocmd("User", {
    pattern = "TermdebugStartPre",
    callback = function()
        for _, k in ipairs(termdebug_keys) do
            vim.keymap.set(k[1], k[2], k[3], { desc = k[4] })
        end
        current_debug_edit_file=vim.api.nvim_buf_get_name(0)
        vim.cmd.tabnew()
    end,
})
vim.api.nvim_create_autocmd("User", {
    pattern = "TermdebugStartPost",
    callback = function()
        vim.cmd('Source')
        vim.cmd('wincmd K')
        vim.cmd.resize(30)
        vim.cmd.edit(current_debug_edit_file)
        vim.cmd('Gdb')
        vim.cmd.resize(10)
        vim.cmd('Asm')
        vim.cmd.resize(10)
        vim.cmd('Source')
    end,
})
vim.api.nvim_create_autocmd("User", {
    pattern = "TermdebugStopPre",
    callback = function()
        vim.cmd('Source')
        current_debug_edit_file=vim.api.nvim_buf_get_name(0)
        vim.cmd('Gdb')
        vim.cmd('Bd')
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
require('mini.diff').setup({
    mappings = {
        apply = '<leader>gs',
        reset = '<leader>gr',
        textobject = '',
        -- Go to hunk range in corresponding direction
        goto_first = '[H',
        goto_prev = '[h',
        goto_next = ']h',
        goto_last = ']H',
    },
})
vim.keymap.set('n', '<leader>gd', MiniDiff.toggle_overlay, { desc = "[g]it [d]iff" })

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
