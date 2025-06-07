-- Settings
-- ============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.cmd 'colorscheme habamax'
vim.o.nu = true
vim.o.relativenumber = true
vim.o.wrap = true
vim.o.colorcolumn = "80"
vim.o.cursorline = true
vim.o.confirm = true
vim.o.tags = "tags"
vim.o.endofline = true
vim.o.fixendofline = true
vim.o.updatetime = 50
vim.o.confirm = true
vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Split
vim.o.splitright = true
vim.o.splitbelow = true

-- Scroll
vim.o.scrolloff = 10        -- Number of screen lines keep above and below the cursor.
vim.o.scrolloff = 999       -- Keep cursor centered vertically
vim.o.sidescrolloff = 50    -- Keep cursor centered horizontally
vim.opt.undofile = true     -- Undo

-- Auto complete
vim.o.omnifunc = "syntaxcomplete#Compete"
vim.opt.completeopt:append { "menuone", "preview" }

-- Spell Check
-- vim.o.spell = true
-- vim.o.spelllang = "en_us"

-- Tabs
vim.o.tabstop = 4      -- Number of spaces a tab counts for
vim.o.shiftwidth = 4   -- Spaces for each (auto)indent step
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.softtabstop = 4

-- Search and Replace
-- vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = 'split'

vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
end)

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Useless Settings
vim.o.swapfile = false
vim.o.backup = false


-- Keybindings
-- ============================================================================

vim.keymap.set("n", "<leader>r", ":checktime<CR>",  { desc = "[R]eload" })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = "Clear Search Highlight" })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>',    { desc = 'Exit terminal mode' })
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Move Lines
vim.keymap.set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==",                   { desc = "Move Down" })
vim.keymap.set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==",             { desc = "Move Up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi",                                   { desc = "Move Down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi",                                   { desc = "Move Up" })
vim.keymap.set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",       { desc = "Move Down" })
vim.keymap.set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Buffers
vim.keymap.set("n", "b[", "<cmd>bprevious<cr>",    { desc = "Prev Buffer" })
vim.keymap.set("n", "b]", "<cmd>bnext<cr>",        { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>",  { desc = "Switch to Other Buffer" })
vim.keymap.set('n', '<leader>wd', ':bn | bd#<CR>', { desc = 'Delete Split' })

-- Tag Jumps
vim.keymap.set('n', 'g]', '<C-]>', { desc = 'Jump to definition' })
vim.keymap.set('n', '<C-]>', 'g]', { desc = 'List all tags' })
vim.keymap.set('n', 'g[', '<C-t>', { desc = 'Return from jump' })

-- Auto complete 
vim.keymap.set('i', '<A-o>', '<C-x><C-o>', { noremap = true }, { desc = 'Omni-completion (context-aware)' })
vim.keymap.set('i', '<A-n>', '<C-x><C-n>', { noremap = true }, { desc = 'Completion from current file.' })
vim.keymap.set('i', '<A-i>', '<C-x><C-i>', { noremap = true }, { desc = 'Completion from include file.' })
vim.keymap.set('i', '<A-d>', '<C-x><C-k>', { noremap = true }, { desc = 'Dictionary completion' })
vim.keymap.set('i', '<A-f>', '<C-x><C-f>', { noremap = true }, { desc = 'Filename completion' })
vim.keymap.set('i', '<A-l>', '<C-x><C-l>', { noremap = true }, { desc = 'Whole line completion' })
vim.keymap.set('i', '<A-e>', '<C-e>',      { noremap = true }, { desc = 'Cancel completion' })

-- Diagnostics
vim.keymap.set('n', '<leader>ds', vim.diagnostic.open_float, { desc = '[D]iagnostic [S]how' })
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next,  { desc = '[D]iagnostic [N]ext' })
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev,  { desc = '[D]iagnostic [P]revious' })

-- Split
vim.keymap.set('n', '<leader>sv', '<C-w>v', { desc = '[S]plit Vertical' })
vim.keymap.set('n', '<leader>ss', '<C-w>s', { desc = '[S]plit Horizontal' })
vim.keymap.set('n', '<leader>sl', '<C-w>l', { desc = '[S]plit go [L]eft' })
vim.keymap.set('n', '<leader>sh', '<C-w>h', { desc = '[S]plit go [R]ight' })

-- Better Search Next 
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'",  { expr = true, desc = "Next Search Result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]",       { expr = true, desc = "Next Search Result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]",       { expr = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'",  { expr = true, desc = "Prev Search Result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]",       { expr = true, desc = "Prev Search Result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]",       { expr = true, desc = "Prev Search Result" })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "c",
  callback = function()
    vim.keymap.set('n', '<F5>', ":!cc build.c && ./a.out build-run<CR>", { desc = "Run build command" })
  end,
})

-- Functions
-- ============================================================================

-- Trim Trailing Whitespace
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.rb',
  callback = function()
    vim.cmd('%s/\\s\\+$//e')
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

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt.wrap = true
    vim.opt.spell = true
  end,
})

-- Plugin Manger
-- ============================================================================

local plugin_path = vim.fn.stdpath("config") .. "/plugins"
local lazypath = plugin_path .. "/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
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
    { -- Smooth Scrolling
        dir = plugin_path .. "/neoscroll.nvim",
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

    { -- Linter
        dir = plugin_path .. "/nvim-lint",
        event = "VeryLazy",
        config = function()
            require('lint').linters_by_ft = {
                c = {'gcc'}
            }

            local pattern = [[^([^:]+):(%d+):(%d+):%s+([^:]+):%s+(.*)$]]
            local groups = { 'file', 'lnum', 'col', 'severity', 'message' }
            local severity_map = {
                ['error'] = vim.diagnostic.severity.ERROR,
                ['warning'] = vim.diagnostic.severity.WARN,
                ['performance'] = vim.diagnostic.severity.WARN,
                ['style'] = vim.diagnostic.severity.INFO,
                ['information'] = vim.diagnostic.severity.INFO,
            }

            require('lint').linters.gcc = {
                cmd = 'gcc',
                stdin = false,
                append_fname = true,
                args = {'-Wall', '-Wextra', "-fsyntax-only", 
                    "-Wno-incompatible-pointer-types", "-Wno-override-init",
                    "-Wno-unused-variable", "-Wno-unused-parameter", 
                    "-Wno-unused-function", "-Wno-unused-but-set-variable", 
                    "-Wno-missing-braces"
                }, 
                stream = 'stderr',
                ignore_exitcode = true,
                env = nil,
                parser = require('lint.parser').from_pattern(pattern, groups, severity_map, { ['source'] = 'gcc' }),
            }
            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
              callback = function()
                  pattern = { '*.c', '*.h' },
                  require("lint").try_lint()
              end,
            })

        end,
    },

    { -- Tags Manager 
        dir = plugin_path .. "/vim-gutentags",
        config = function()
            vim.g.gutentags_ctags_extra_args = { '--c-kinds=+p' }
            vim.g.gutentags_project_root = { 'tags' }
        end
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
                { '<leader>s', group = '[S]earch' },
                { '<leader>b', group = '[B]uffer' },
                { '<leader>t', group = '[T]oggle' },
                { '<leader>s', group = '[S]plit' },
                { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
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
            vim.keymap.set('n', '<leader>sh', builtin.help_tags,            { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>sk', builtin.keymaps,              { desc = '[S]earch [K]eymaps' })
            vim.keymap.set('n', '<leader>sf', builtin.find_files,           { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>ss', builtin.builtin,              { desc = '[S]earch [S]elect Telescope' })
            vim.keymap.set('n', '<leader>sw', builtin.grep_string,          { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<leader>sg', builtin.live_grep,            { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>sT', builtin.tags,                 { desc = '[S]earch [T]ags' })
            vim.keymap.set('n', '<leader>st', builtin.current_buffer_tags,  { desc = '[S]earch [T]ags' })
            vim.keymap.set('n', '<leader>so', builtin.oldfiles,             { desc = '[S]earch Recent Files ("." for repeat)' })
            vim.keymap.set('n', '<leader><leader>', builtin.buffers,        { desc = 'Find existing buffers' })
            vim.keymap.set('n', '<leader>s:', builtin.command_history,      { desc = 'Command History' })
            vim.keymap.set('n', '<leader>/', function()
                builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end, { desc = '[/] Fuzzily search in current buffer' })
            vim.keymap.set('n', '<leader>s/', function()
                builtin.live_grep {
                    grep_open_files = true,
                    prompt_title = 'Live Grep in Open Files',
                }
            end, { desc = '[S]earch [/] in Open Files' })
        end,
    },

    { -- Highlight, edit, and navigate code
        dir = plugin_path .. "/nvim-treesitter",
        build = ':TSUpdate',
        main = 'nvim-treesitter.configs', -- Sets main module to use for opts
        opts = {
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = { 'ruby' },
            },
            indent = { enable = true, disable = { 'ruby' } },
        },
    },

    { -- Undo History
       dir = plugin_path .. "/undotree",
       config = function()
            vim.keymap.set('n', '<leader><F5>', vim.cmd.UndotreeToggle)
       end,
    },

    {
       dir = plugin_path .. "/indent-blankline.nvim",
       main = "ibl",
       opts = {},
       config = function()
           require("ibl").setup() 
       end,
    },

    { -- Theme
        dir = plugin_path .. "/neon",
        config = function()
            vim.g.neon_style = "dark"
            vim.cmd[[colorscheme neon]]
        end,
    }
}, {
    root = plugin_path .. "/online",
})

