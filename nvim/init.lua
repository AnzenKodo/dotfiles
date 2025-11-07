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

-- Auto complete
vim.o.omnifunc = "syntaxcomplete#Compete"
vim.opt.completeopt:append { "menuone", "preview", "noselect" }

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
vim.keymap.set({'n', 'v'}, 'gf', function()
    vim.cmd [[
        let fileInfo = split(expand("<cWORD>"), ":")
        let column = 0
        normal! gF
        if len(fileInfo) > 2
            let column = fileInfo[2]
            execute 'normal! ' . column . '|'
        endif
    ]]
end, { desc = "[G]o to [F]ile", noremap = true })

vim.keymap.set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==",                   { desc = "Move Line Down" })
vim.keymap.set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==",             { desc = "Move Line Up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi",                                   { desc = "Move Line Down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi",                                   { desc = "Move Line Up" })
vim.keymap.set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",       { desc = "Move Line Down" })
vim.keymap.set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Line Up" })

-- Paste
vim.keymap.set('x', 'P', function() vim.cmd('normal! p') end, { silent = true })
vim.keymap.set('x', 'p', function() vim.cmd('normal! P') end, { silent = true })

-- Autocomplete
vim.keymap.set('i', '<A-o>', '<C-x><C-o>', { noremap = true }, { desc = 'Omni-completion (context-aware)' })
vim.keymap.set('i', '<A-n>', '<C-x><C-n>', { noremap = true }, { desc = 'Completion from current file.' })
vim.keymap.set('i', '<A-i>', '<C-x><C-i>', { noremap = true }, { desc = 'Completion from include file.' })
vim.keymap.set('i', '<A-d>', '<C-x><C-k>', { noremap = true }, { desc = 'Dictionary completion' })
vim.keymap.set('i', '<A-f>', '<C-x><C-f>', { noremap = true }, { desc = 'Filename completion' })
vim.keymap.set('i', '<A-l>', '<C-x><C-l>', { noremap = true }, { desc = 'Whole line completion' })
vim.keymap.set('i', '<A-e>', '<C-e>',      { noremap = true }, { desc = 'Cancel completion' })
vim.keymap.set('i', '<Tab>',   'pumvisible() ? "\\<C-n>" : "\\<Tab>"', { expr = true })
vim.keymap.set('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', { expr = true })

-- Split
vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = '[W]indow [V]ertical' })
vim.keymap.set('n', '<leader>wo', '<C-w>s', { desc = '[W]indow H[O]rizontal' })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = '[W]indow goto [L]eft' })
vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = '[W]indow goto [R]ight' })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { desc = '[W]indow goto [D]own' })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { desc = '[W]indow goto [U]p' })
vim.keymap.set('n', '<leader>w>', '<C-w>>', { desc = '[W]indow increase [>] width' })
vim.keymap.set('n', '<leader>w<', '<C-w>>', { desc = '[W]indow decrease [<] width' })
vim.keymap.set('n', '<leader>wx', '<C-w>x', { desc = '[W]indow [X]wap sides' })
vim.keymap.set('n', '<leader>ws', '<C-w>w', { desc = '[W]indow [S]witch' })
vim.keymap.set('n', '<leader>wn', '<C-w>n', { desc = '[W]indow [N]ew' })
vim.keymap.set('n', '<leader>w=', '<C-w>=', { desc = '[W]indow [=]Equal' })
vim.keymap.set('n', '<leader>ww', "<cmd>e #<cr>", { desc = 'Switch to previous [W]indow buffer' })

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
end, { desc = '[W]indow Toggle' })
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
end, {desc = '[W]indow [D]uplicate' })
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
end, { desc = "[W]indow goto [F]ile", noremap = true })

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

-- Buffers
-- ============================================================================

vim.keymap.set("n", "[b", "<cmd>bprevious<cr>",    { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>",        { desc = "Next Buffer" })
vim.api.nvim_create_user_command("Bda", function() vim.cmd("%bdelete|edit #|bdelete #") end, {})
vim.api.nvim_create_user_command("Bd",  function() vim.cmd("bn | bd#") end, {})

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

-- Config Reload
-- ============================================================================

local function config_reload()
    vim.cmd[[ source $MYVIMRC ]]
    vim.notify("Config reloaded!", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("Reload", config_reload, {})

local user_config_group = vim.api.nvim_create_augroup("user_config", { clear = true })
-- Clear existing autocommands to prevent duplicates
vim.api.nvim_clear_autocmds({ group = user_config_group, event = "BufWritePost" })
vim.api.nvim_create_autocmd("BufWritePost", {
    group = user_config_group,
    pattern = "init.lua",
    callback = config_reload,
})

vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
    callback = function()
        min_length_cursor_len = 3
        vim.api.nvim_set_hl(0, "CursorWord", { bg = "#2C242A" })
        local column = vim.api.nvim_win_get_cursor(0)[2]
        local line = vim.api.nvim_get_current_line()
        local cursorword = vim.fn.matchstr(line:sub(1, column + 1), [[\k*$]])
        .. vim.fn.matchstr(line:sub(column + 1), [[^\k*]]):sub(2)

        if cursorword == vim.w.cursorword then
            return
        end
        vim.w.cursorword = cursorword
        if vim.w.cursorword_id then
            vim.call("matchdelete", vim.w.cursorword_id)
            vim.w.cursorword_id = nil
        end
        if
            cursorword == ""
            or #cursorword > 100
            or #cursorword < min_length_cursor_len
            or string.find(cursorword, "[\192-\255]+") ~= nil
        then
            return
        end
        local pattern = [[\<]] .. cursorword .. [[\>]]
        vim.w.cursorword_id = vim.fn.matchadd("CursorWord", pattern, -1)
    end
})

-- Tags
-- ============================================================================

vim.o.tags = "tags,/home/ramen/.cache/ctags/system.tags"
vim.keymap.set('n', ']g', '<C-]>', { desc = 'Jump to definition' })
vim.keymap.set('n', '[g', '<C-t>', { desc = 'Return from jump' })
vim.keymap.set('n', '<leader>wg', '<cmd>lua open_buffer_in_other_split()<CR><C-]> ', { desc = "[W]indow [G]oto definition" })
vim.keymap.set('n', '<leader>wt', '<cmd>lua open_buffer_in_other_split()<CR>g]',     { desc = "[W]indow show [T]ag" })

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



-- Plugins
-- ============================================================================

-- Load Built-in Plugins ======================================================

vim.cmd('packadd justify')
-- vim.cmd('packadd nvim.undotree')

-- Load External Plugins ======================================================

local plugin_path = vim.fn.stdpath("config") .. "/plugins"
vim.opt.runtimepath:append(plugin_path .. "/*")

-- Theme ======================================================================

-- Colorscheme
vim.g.gruvbox_material_background = 'material'
vim.g.gruvbox_material_background = "soft"
vim.g.gruvbox_material_better_performance = true
vim.g.gruvbox_material_enable_italic = true
vim.g.gruvbox_material_dim_inactive_windows = true
vim.cmd.colorscheme('gruvbox-material')
vim.cmd.highlight('IndentLineCurrent guifg=#928374')
vim.cmd.highlight('IndentLine guifg=#504945')

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

-- Smart Auto Indent ==========================================================
require('guess-indent').setup()

-- Wildcard ===================================================================
require('wilder').setup({ modes = {':', '/', '?'} })

-- Wildcard ===================================================================
require('select-undo').setup()

-- Editing ====================================================================
-- Multicursor
require("multiple-cursors").setup()
vim.keymap.set({"n", "x"}, "<C-k>", "<Cmd>MultipleCursorsAddUp<CR>",            { desc = "Add cursor and move up" })
vim.keymap.set({"n", "i"}, "<C-h>", "<Cmd>MultipleCursorsMouseAddDelete<CR>",   { desc = "Add or remove cursor" })
vim.keymap.set({"n", "x"}, "<C-j>", "<Cmd>MultipleCursorsAddDown<CR>",          { desc = "Add cursor and move down" })
vim.keymap.set({"x"},      "<C-x>", "<Cmd>MultipleCursorsAddVisualArea<CR>",    { desc = "Add cursors to the lines of the visual area" })
vim.keymap.set({"n", "x"}, "<C-l>", "<Cmd>MultipleCursorsLock<CR>",             { desc = "Lock virtual cursors" })

-- Bracket Split and Join
require("treesj").setup({ })
vim.keymap.set('n', '<leader>es', require('treesj').toggle)

-- Better 'f', 't', 'F', 'T'
require("flash").setup({})
vim.keymap.set({ "n", "x", "o" }, "<leader>es",  function() require("flash").jump() end,              { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "<leader>eS",  function() require("flash").treesitter() end,        { desc = "Flash Treesitter" })
vim.keymap.set({ "o", "x" },      "<leader>er",  function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
vim.keymap.set("o",               "<leader>eR",  function() require("flash").remote() end,            { desc = "Remote Flash" })
-- vim.keymap.set({ "c" },           "<c-s>",  function() require("flash").toggle() end,            { desc = "Toggle Flash Search" })

-- Better 'w', 'e' and 'b'
vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>")
vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>")
vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>")

-- Keymap Helper ==============================================================
require('which-key').setup({
    delay = 0,
    icons = {
        keys = vim.g.have_nerd_font and {} or {
            Up = '<Up> ',
            Down = '<Down> ',
            Left = '<Left> ',
            Right = '<Right> ',
            C = '<C-…> ',
            M = '<M-…> ',
            D = '<D-…> ',
            S = '<S-…> ',
            CR = '<CR> ',
            Esc = '<Esc> ',
            ScrollWheelDown = '<ScrollWheelDown> ',
            ScrollWheelUp = '<ScrollWheelUp> ',
            NL = '<NL> ',
            BS = '<BS> ',
            Space = '<Space> ',
            Tab = '<Tab> ',
            F1 = '<F1>',
            F2 = '<F2>',
            F3 = '<F3>',
            F4 = '<F4>',
            F5 = '<F5>',
            F6 = '<F6>',
            F7 = '<F7>',
            F8 = '<F8>',
            F9 = '<F9>',
            F10 = '<F10>',
            F11 = '<F11>',
            F12 = '<F12>',
        },
    },
    -- Document existing key chains
    spec = {
        { '<leader>d', group = '[D]iagnostic' },
        { '<leader>f', group = '[F]ind' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>w', group = '[W]indow' },
        { '<leader>m', group = '[M]ark' },
        { '<leader>u', group = '[U]ndo' },
        { '<leader>g', group = '[G]it', mode = { 'n', 'v' } },
    },
})

-- Session Manager ============================================================
require("auto-session").setup()

-- Undo History ===============================================================
vim.api.nvim_create_user_command("UndoTree", require("undotree").toggle, {})

-- Better Quickfix ============================================================
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        require('bqf').setup()
    end,
})

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
        ["gf"]  = {
            function()
                require("telescope.builtin").find_files({
                    cwd = require("oil").get_current_dir()
                })
            end,
            mode = "n",
            nowait = true,
            desc = "Find files in the current directory"
        },
        -- ["<C-`>"] = {
        --     function()
        --         vim.cmd.new()
        --         vim.cmd.wincmd "J"
        --         vim.api.nvim_win_set_height(0, 12)
        --         vim.wo.winfixheight = true
        --         local current_dir = require("oil").get_current_dir()
        --         if (vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1) then
        --             current_dir = win_to_bash_path(current_dir)
        --         end
        --         -- current_dir = vim.fn.fnameescape(current_dir)
        --         vim.cmd.term("bash -c \"cd " .. current_dir .. " && bash\"")
        --     end,
        --     nowait = true,
        --     mode = "n",
        --     desc = "Open terminal current directory"
        -- },
        -- ["†"] = {
        --     function()
        --     end,
        --     nowait = true,
        --     mode = "n",
        --     desc = "Open terminal current directory"
        -- },
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
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>fk', builtin.keymaps,             { desc = '[F]ind [K]eymaps' })
vim.keymap.set('n', '<leader>ff', builtin.find_files,          { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fw', builtin.grep_string,         { desc = '[F]ind current [W]ord' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep,           { desc = '[F]ind by [G]rep' })
vim.keymap.set('n', '<leader>ft', builtin.tags,                { desc = '[F]ind  [T]ags' })
vim.keymap.set('n', '<leader>fc', builtin.current_buffer_tags, { desc = '[F]ind [C]urrent tags' })
vim.keymap.set('n', '<leader>fo', builtin.oldfiles,            { desc = '[F]ind Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader>fb', builtin.buffers,             { desc = 'Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>f/', function()
    builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
    }
end, { desc = '[F]ind [/] in Open Files' })

-- Git ========================================================================
-- Git Hunk
require('gitsigns').setup({
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
        -- Navigation
        vim.keymap.set('n', ']c', function()
            if vim.wo.diff then
                vim.cmd.normal({']c', bang = true})
            else
                require('gitsigns').nav_hunk('next')
            end
        end, { desc = "Next hunk or diff" })
        vim.keymap.set('n', '[c', function()
            if vim.wo.diff then
                vim.cmd.normal({'[c', bang = true})
            else
                require('gitsigns').nav_hunk('prev')
            end
        end, { desc = "Previous hunk or diff" })
        -- Actions
        vim.keymap.set('v', '<leader>gs', function() require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = "[G]it [S]tage" })
        vim.keymap.set('v', '<leader>gr', function() require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = "[G]it [R]eset" })
        vim.keymap.set('n', '<leader>gQ', function() require('gitsigns').setqflist('all') end,                                   { desc = "[G]it [Q]uickfix all" })
        vim.keymap.set('n', '<leader>gs', require('gitsigns').stage_hunk,          { desc = "[G]it [S]tage" })
        vim.keymap.set('n', '<leader>gr', require('gitsigns').reset_hunk,          { desc = "[G]it [R]eset" })
        vim.keymap.set('n', '<leader>gS', require('gitsigns').stage_buffer,        { desc = "[G]it entire buffer [S]tage" })
        vim.keymap.set('n', '<leader>gR', require('gitsigns').reset_buffer,        { desc = "[G]it entire buffer [R]eset" })
        vim.keymap.set('n', '<leader>gp', require('gitsigns').preview_hunk,        { desc = "[G]it Preview" })
        vim.keymap.set('n', '<leader>gi', require('gitsigns').preview_hunk_inline, { desc = "[G]it [I]nline preview" })
        vim.keymap.set('n', '<leader>gd', require('gitsigns').diffthis,            { desc = "[G]it [D]iff" })
        vim.keymap.set('n', '<leader>gq', require('gitsigns').setqflist,           { desc = "[G]it [Q]uickfix" })
    end
})

-- Git Manager
require("diffview").setup({ use_icons = false, })
require("neogit").setup({
    graph_style = "unicode",
})

-- Time Tracker ===============================================================
if not is_termux() then
    vim.opt.runtimepath:append(plugin_path .. "Manual/aw-watcher.vim")
end


