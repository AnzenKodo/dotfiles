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

vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
end)

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

-- Neovim Gui
-- ============================================================================

if vim.g.neovide then
    vim.o.guifont = "Consolas:h12"
    vim.keymap.set({ "n", "v" }, "<C-=>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
    vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
    vim.keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
end

-- Functions for Keymaps
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

-- Buffers
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>",    { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>",        { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>",  { desc = "Switch to Other Buffer" })
vim.keymap.set('n', '<leader>bd', ':bn | bd#<CR>', { desc = '[D]elete [S]plit' })
vim.keymap.set('n', '<leader>ba', function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_option(bufnr, 'buflisted') then
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
    end
end, { desc = 'Wipe all buffers', })

-- Autocomplete
vim.keymap.set('i', '<A-o>', '<C-x><C-o>', { noremap = true }, { desc = 'Omni-completion (context-aware)' })
vim.keymap.set('i', '<A-n>', '<C-x><C-n>', { noremap = true }, { desc = 'Completion from current file.' })
vim.keymap.set('i', '<A-i>', '<C-x><C-i>', { noremap = true }, { desc = 'Completion from include file.' })
vim.keymap.set('i', '<A-d>', '<C-x><C-k>', { noremap = true }, { desc = 'Dictionary completion' })
vim.keymap.set('i', '<A-f>', '<C-x><C-f>', { noremap = true }, { desc = 'Filename completion' })
vim.keymap.set('i', '<A-l>', '<C-x><C-l>', { noremap = true }, { desc = 'Whole line completion' })
vim.keymap.set('i', '<A-e>', '<C-e>',      { noremap = true }, { desc = 'Cancel completion' })
vim.keymap.set('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', { expr = true })
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
    local cur_win  = vim.api.nvim_get_current_win()          -- active window
    local cur_buf  = vim.api.nvim_get_current_buf()          -- active buffer
    local wins     = vim.api.nvim_tabpage_list_wins(0)       -- all wins in tab
    -- pick any window that isn’t the current one
    local target
    for _, w in ipairs(wins) do
        if w ~= cur_win then
            target = w
            break
        end
    end
    -- if there was no other window, just split once
    if not target then
        vim.cmd('vsplit')
        target = vim.api.nvim_get_current_win()
    end
    vim.api.nvim_win_set_buf(target, cur_buf) -- put the buffer in the target window
    vim.api.nvim_set_current_win(target)
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

-- Better indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })

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

-- Commands
-- ============================================================================

vim.api.nvim_create_user_command("Reload", function()
    dofile(vim.env.MYVIMRC)
    vim.cmd("Lazy reload gruvbox-material")
    vim.notify("Config reloaded!", vim.log.levels.INFO)
end, {})

-- Autocommands
-- ============================================================================

-- Trim Trailing Whitespace
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
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

-- Tags
-- ============================================================================

vim.o.tags = "tags,/home/ramen/.cache/ctags/system.tags"
vim.keymap.set('n', ']g', '<C-]>', { desc = 'Jump to definition' })
vim.keymap.set('n', '[g', '<C-t>', { desc = 'Return from jump' })
vim.keymap.set('n', '<leader>wd', '<cmd>lua open_buffer_in_other_split()<CR><C-]> ', { desc = "[W]indow goto definition" })
vim.keymap.set('n', '<leader>wg', '<cmd>lua open_buffer_in_other_split()<CR>g]',     { desc = "[W]indow [G]oto tag" })

-- Make
-- ============================================================================

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        -- Ant Build
        if vim.fn.filereadable("build.xml") == 1 then
            vim.opt.makeprg="ant compile"
            vim.opt.errorformat="%A\\ %#[javac]\\ %f:%l:\\ error:\\ %m,%-Z\\ %#[javac]\\ %p^,%-C%.%#,%-G%.%#BUILD\\ FAILED%.%#,%-GTotal\\ time:\\ %.%#"
        end
        if vim.fn.filereadable("build.c") == 1 then
            vim.opt.makeprg="gcc build.c && ./a.out build-run"
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

-- Plugin Manger
-- ============================================================================

local plugin_path = vim.fn.stdpath("config") .. "/plugins"
local lazypath = plugin_path .. "/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable",
        lazyrepo, lazypath
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    { -- Theme
        dir = plugin_path .. "/gruvbox-material",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_material_background = 'material'
            vim.g.gruvbox_material_background = "soft"
            vim.g.gruvbox_material_better_performance = true
            vim.g.gruvbox_material_enable_italic = true
            -- vim.g.gruvbox_material_enable_bold = true
            vim.g.gruvbox_material_dim_inactive_windows = true
            vim.cmd.colorscheme('gruvbox-material')
            vim.cmd.highlight('IndentLineCurrent guifg=#928374')
            vim.cmd.highlight('IndentLine guifg=#504945')
        end
    },

    { -- Wildcard
        dir = plugin_path .. "/wilder.nvim",
        config = function()
            require('wilder').setup({
                modes = {':', '/', '?'}
            })
        end,
    },

    { -- Status Line
        dir = plugin_path .. "/lualine.nvim",
        config = function()
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
                options = {
                    theme = 'gruvbox-material',
                },
            })
        end,
    },

    { -- File Manager
        dir = plugin_path .. "/oil-git-status.nvim",
        config = function()
            require("oil-git-status").setup()
        end,
        dependencies = {
            {
                dir = plugin_path .. "/oil.nvim",
                lazy = false,
                config = function()
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
                            ["<leader>sv"] = { "actions.select", opts = { vertical = true } },
                            ["<leader>ss"] = { "actions.select", opts = { horizontal = true } },
                            ["-"] = { "actions.parent", mode = "n" },
                            ["_"] = { "actions.open_cwd", mode = "n" },
                            ["g?"] = { "actions.show_help", mode = "n" },
                            ["gp"] = "actions.preview",
                            ["gr"] = "actions.refresh",
                            ["gs"] = { "actions.change_sort", mode = "n" },
                            ["gx"] = "actions.open_external",
                            ["g."] = { "actions.toggle_hidden", mode = "n" },
                            ["g\\"] = { "actions.toggle_trash", mode = "n" },
                            ["gf"] = {
                                function()
                                    require("telescope.builtin").find_files({
                                        cwd = require("oil").get_current_dir()
                                    })
                                end,
                                mode = "n",
                                nowait = true,
                                desc = "Find files in the current directory"
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
                    vim.keymap.set("n", "<leader>-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
                end,
            },
        },
    },

    { -- Time Tracker
        dir = plugin_path .. '/aw-watcher-vim',
    },

    { -- Session Manager
        dir = plugin_path .. '/auto-session',
        lazy = false,
        config = function()
            require("auto-session").setup()
        end,
    },

    { -- Tags Manager
        "JMarkin/gentags.lua",
        cond = vim.fn.executable("ctags") == 1,
        event = "VeryLazy",
        config = function()
            require('gentags').setup({ args = { '--c-kinds=+p', '-R' } })
        end,
    },

    {
        dir = plugin_path .. "/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        },
        config = function()
            require('gitsigns').setup({
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
                    vim.keymap.set('n', '<leader>gs', require('gitsigns').stage_hunk, { desc = "[G]it [S]tage" })
                    vim.keymap.set('n', '<leader>gr', require('gitsigns').reset_hunk, { desc = "[G]it [R]eset" })
                    vim.keymap.set('v', '<leader>gs', function()
                        require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                    end, { desc = "[G]it [S]tage" })
                    vim.keymap.set('v', '<leader>gr', function()
                        require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                    end, { desc = "[G]it [R]eset" })
                    vim.keymap.set('n', '<leader>gS', require('gitsigns').stage_buffer, { desc = "[G]it entire buffer [S]tage" })
                    vim.keymap.set('n', '<leader>gR', require('gitsigns').reset_buffer, { desc = "[G]it entire buffer [R]eset" })
                    vim.keymap.set('n', '<leader>gp', require('gitsigns').preview_hunk, { desc = "[G]it Preview" })
                    vim.keymap.set('n', '<leader>gi', require('gitsigns').preview_hunk_inline, { desc = "[G]it [I]nline preview" })
                    vim.keymap.set('n', '<leader>gd', require('gitsigns').diffthis, { desc = "[G]it [D]iff" })
                    vim.keymap.set('n', '<leader>gq', require('gitsigns').setqflist, { desc = "[G]it [Q]uickfix" })
                    vim.keymap.set('n', '<leader>gQ', function() require('gitsigns').setqflist('all') end, { desc = "[G]it [Q]uickfix all" })
                end
            })
        end,
    },

    {
        dir = plugin_path .. "/neogit",
        dependencies = {
            { dir = plugin_path .. "telescope/plenary.nvim" },
            {
                dir = plugin_path .. "/diffview.nvim",
                config = function()
                    require("diffview").setup({ use_icons = false, })
                end
            },
            { dir = plugin_path .. "/telescope/telescope.nvim" }
        },
        config = function()
            require("neogit").setup({
                  kind = "replace",
                  graph_style = "unicode",
            })
        end,
    },

    {
        dir = plugin_path .. "/which-key.nvim",
        event = 'VimEnter', -- Sets the loading event to 'VimEnter'
        opts = {
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
                { '<leader>b', group = '[B]uffer' },
                { '<leader>t', group = '[T]oggle' },
                { '<leader>w', group = '[W]indow' },
                { '<leader>m', group = '[M]ark' },
                { '<leader>u', group = '[U]ndo' },
                { '<leader>g', group = '[G]it', mode = { 'n', 'v' } },
            },
        },
    },

    { -- Fuzzy Finder
        dir = plugin_path .. "/telescope/telescope.nvim",
        event = 'VimEnter',
        dependencies = {
            {
                dir = plugin_path .. "/telescope/plenary.nvim"
            },
            {
                dir = plugin_path .. "/telescope/telescope-fzf-native.nvim",
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            {
                dir = plugin_path .. "/telescope/telescope-ui-select.nvim"
            },
        },
        config = function()
            require('telescope').setup {
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
            vim.keymap.set('n', '<leader>fh', builtin.help_tags,            { desc = '[F]ind [H]elp' })
            vim.keymap.set('n', '<leader>fk', builtin.keymaps,              { desc = '[F]ind [K]eymaps' })
            vim.keymap.set('n', '<leader>ff', builtin.find_files,           { desc = '[F]ind [F]iles' })
            vim.keymap.set('n', '<leader>fs', builtin.builtin,              { desc = '[F]ind builtin [S]earch' })
            vim.keymap.set('n', '<leader>fw', builtin.grep_string,          { desc = '[F]ind current [W]ord' })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep,            { desc = '[F]ind by [G]rep' })
            vim.keymap.set('n', '<leader>ft', builtin.tags,                 { desc = '[F]ind  [T]ags' })
            vim.keymap.set('n', '<leader>fc', builtin.current_buffer_tags,  { desc = '[F]ind [C]urrent tags' })
            vim.keymap.set('n', '<leader>fo', builtin.oldfiles,             { desc = '[F]ind Recent Files ("." for repeat)' })
            vim.keymap.set('n', '<leader>fb', builtin.buffers,              { desc = 'Find existing buffers' })
            vim.keymap.set('n', '<leader>f:', builtin.command_history,      { desc = 'Command History' })
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
        end,
    },

    { -- Undo History
        dir = plugin_path .. "/undotree",
        dependencies = "nvim-lua/plenary.nvim",
        config = true,
        keys = { -- load the plugin only when using it's keybinding:
            { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
        },
    },

    { -- Shows Indent
       dir = plugin_path .. "/indentmini.nvim",
       config = function()
            require("indentmini").setup()
       end,
    },

    { -- Smart Auto Indent
        dir = plugin_path .. "/guess-indent.nvim",
        config = function()
            require('guess-indent').setup {}
        end,
    },

    -- Marks
    {
        dir = plugin_path .. "/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { dir = plugin_path .. "/telescope/telescope.nvim" }
        },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()
            vim.keymap.set("n", "<leader>ma", function() harpoon:list():add() end,                         { desc = "[M]ark [A]dd"})
            vim.keymap.set("n", "<leader>mm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "[M]ark [M]enu" })
            vim.keymap.set("n", "<leader>m1", function() harpoon:list():select(1) end,                     { desc = "[M]ark [1]"})
            vim.keymap.set("n", "<leader>m2", function() harpoon:list():select(2) end,                     { desc = "[M]ark [2]"})
            vim.keymap.set("n", "<leader>m3", function() harpoon:list():select(3) end,                     { desc = "[M]ark [3]"})
            vim.keymap.set("n", "<leader>m4", function() harpoon:list():select(4) end,                     { desc = "[M]ark [4]"})
            vim.keymap.set("n", "<leader>mp", function() harpoon:list():prev() end,                        { desc = "[M]ark [P]revious"})
            vim.keymap.set("n", "<leader>mn", function() harpoon:list():next() end,                        { desc = "[M]ark [N]ext"})
        end,
    },

    {
        "jake-stewart/multicursor.nvim",
        branch = "1.0",
        config = function()
            local mc = require("multicursor-nvim")
            mc.setup()

            -- Add or skip cursor above/below the main cursor.
            vim.keymap.set({"n", "x"}, "<C-M-Down>", function() mc.lineAddCursor(1) end)
            vim.keymap.set({"n", "x"}, "<C-M-Up>", function() mc.lineAddCursor(-1) end)
            vim.keymap.set({"n", "x"}, "<C-M-Left>", function() mc.lineSkipCursor(-1) end)
            vim.keymap.set({"n", "x"}, "<C-M-Right>", function() mc.lineSkipCursor(1) end)

            -- Add or skip adding a new cursor by matching word/selection
            vim.keymap.set({"n", "x"}, "<C-d>", function() mc.matchAddCursor(1) end)
            -- vim.keymap.set({"n", "x"}, "<leader>ms", function() mc.matchSkipCursor(1) end)
            vim.keymap.set({"n", "x"}, "<C-D>", function() mc.matchAddCursor(-1) end)
            -- vim.keymap.set({"n", "x"}, "<leader>mS", function() mc.matchSkipCursor(-1) end)

            mc.addKeymapLayer(function(layerSet)
                -- Select a different cursor as the main one.
                -- layerSet({"n", "x"}, "<leader>md", mc.prevCursor)
                -- layerSet({"n", "x"}, "<leader>mD", mc.nextCursor)

                -- Delete the main cursor.
                -- layerSet({"n", "x"}, "<leader>mq", mc.deleteCursor)

                -- Enable and clear cursors using escape.
                layerSet("n", "<esc>", function()
                    if not mc.cursorsEnabled() then
                        mc.enableCursors()
                    else
                        mc.clearCursors()
                    end
                end)
            end)
        end
    },
}, {
    root = plugin_path .. "/Online",
})
