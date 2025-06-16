-- Settings
-- ============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.nu = true
vim.o.relativenumber = true
vim.o.wrap = true
vim.o.colorcolumn = "80"
vim.o.cursorline = true
vim.o.confirm = true
vim.o.updatetime = 50
vim.o.confirm = true
vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.o.exrc = true
vim.o.laststatus = 3

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

vim.keymap.set("n", "<leader>r", ":checktime<CR>",  { desc = "[R]eload" })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = "Clear Search Highlight" })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>',    { desc = 'Exit terminal mode' })
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
vim.keymap.set('n', 'L', vim.diagnostic.open_float, { desc = 'Diagnostic' })
vim.keymap.set({'n', 'v'}, 'gf', function()
    local mode = vim.api.nvim_get_mode().mode
    local file_spec
    -- Check if in visual mode (v, V, or blockwise <C-v>)
    if mode == 'v' or mode == 'V' or mode == '\22' then
        file_spec = get_visual_selection()
    else
        file_spec = vim.fn.expand("<cWORD>")
    end
    -- Split the file specification into file, line, and column
    local fileInfo = vim.fn.split(file_spec, ":")
    local file = fileInfo[1]
    local line = fileInfo[2] or 1    -- Default to line 1 if not specified
    local column = fileInfo[3] or 1  -- Default to column 1 if not specified
    -- Exit visual mode if necessary
    if mode == 'v' or mode == 'V' or mode == '\22' then
        vim.cmd('normal! \27')  -- Escape key to exit visual mode
    end
    -- Open the file and set the cursor position
    vim.cmd('edit ' .. file)
    vim.api.nvim_win_set_cursor(0, {tonumber(line), tonumber(column) - 1})
end, { desc = "[G]o to [F]ile", noremap = true })

vim.keymap.set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==",                   { desc = "Move Down" })
vim.keymap.set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==",             { desc = "Move Up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi",                                   { desc = "Move Down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi",                                   { desc = "Move Up" })
vim.keymap.set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",       { desc = "Move Down" })
vim.keymap.set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

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

-- Auto complete
vim.keymap.set('i', '<A-o>', '<C-x><C-o>', { noremap = true }, { desc = 'Omni-completion (context-aware)' })
vim.keymap.set('i', '<A-n>', '<C-x><C-n>', { noremap = true }, { desc = 'Completion from current file.' })
vim.keymap.set('i', '<A-i>', '<C-x><C-i>', { noremap = true }, { desc = 'Completion from include file.' })
vim.keymap.set('i', '<A-d>', '<C-x><C-k>', { noremap = true }, { desc = 'Dictionary completion' })
vim.keymap.set('i', '<A-f>', '<C-x><C-f>', { noremap = true }, { desc = 'Filename completion' })
vim.keymap.set('i', '<A-l>', '<C-x><C-l>', { noremap = true }, { desc = 'Whole line completion' })
vim.keymap.set('i', '<A-e>', '<C-e>',      { noremap = true }, { desc = 'Cancel completion' })

-- Split
vim.keymap.set('n', '<leader>so', '<cmd>lua open_buffer_in_other_split()<CR>', { desc = 'Duplicate [S]plit on [O]ther split' })
vim.keymap.set('n', '<leader>sv', '<C-w>v', { desc = '[S]plit Vertical' })
vim.keymap.set('n', '<leader>ss', '<C-w>s', { desc = '[S]plit Horizontal' })
vim.keymap.set('n', '<leader>sl', '<C-w>l', { desc = '[S]plit go [L]eft' })
vim.keymap.set('n', '<leader>sh', '<C-w>h', { desc = '[S]plit go [R]ight' })
vim.keymap.set('n', '<leader>sj', '<C-w>j', { desc = '[S]plit go [D]own' })
vim.keymap.set('n', '<leader>sk', '<C-w>k', { desc = '[S]plit go [U]p' })
vim.keymap.set({'n', 'v'}, '<leader>sf', function()
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
end, { desc = "[S]plit go to [F]ile", noremap = true })

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

-- Commands
-- ============================================================================

vim.api.nvim_create_user_command("Reload", function()
    dofile(vim.env.MYVIMRC)
    vim.cmd("Lazy reload vim-moonfly-colors")
  vim.notify("Config reloaded!", vim.log.levels.INFO)
end, {})

-- Functions
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

vim.keymap.set('n', '<leader>s]', '<cmd>lua open_buffer_in_other_split()<CR><C-]> ', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>sg', '<cmd>lua open_buffer_in_other_split()<CR>g]', { noremap = true, silent = true })

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
            vim.g.gruvbox_material_background = 'mix'
            vim.g.gruvbox_material_background = "hard"
            vim.g.gruvbox_material_colors_override = {
                bg0 = {'#323232', '234'},
            }
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
                options = {
                    theme = 'gruvbox-material'
                }
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
                    require("oil").setup({
                        default_file_explorer = false,
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
                            signcolumn = "yes:2",
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
                end,
            },
        },
    },

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
                c = {'gcc'},
                cpp = {'gcc'},
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
                require("lint").try_lint()
                require("lint").try_lint("typos")
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
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",         -- required
            {
                "sindrets/diffview.nvim",
                config = function()
                    require("diffview").setup({
                        use_icons = true,         -- Requires nvim-web-devicons
                    })
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
                    end)
                    vim.keymap.set('n', '[c', function()
                      if vim.wo.diff then
                        vim.cmd.normal({'[c', bang = true})
                      else
                        require('gitsigns').nav_hunk('prev')
                      end
                    end)
                    -- Actions
                    vim.keymap.set('n', '<leader>hs', require('gitsigns').stage_hunk)
                    vim.keymap.set('n', '<leader>hr', require('gitsigns').reset_hunk)
                    vim.keymap.set('v', '<leader>hs', function()
                      require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                    end)
                    vim.keymap.set('v', '<leader>hr', function()
                      require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                    end)
                    vim.keymap.set('n', '<leader>hS', require('gitsigns').stage_buffer)
                    vim.keymap.set('n', '<leader>hR', require('gitsigns').reset_buffer)
                    vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk)
                    vim.keymap.set('n', '<leader>hi', require('gitsigns').preview_hunk_inline)
                    vim.keymap.set('n', '<leader>hd', require('gitsigns').diffthis)
                    vim.keymap.set('n', '<leader>hQ', function() require('gitsigns').setqflist('all') end)
                    vim.keymap.set('n', '<leader>hq', require('gitsigns').setqflist)
                end
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
       dir = plugin_path .. "/indentmini.nvim",
       config = function()
            require("indentmini").setup()
       end,
    },

    {
        dir = plugin_path .. "/guess-indent.nvim",
        config = function()
            require('guess-indent').setup {}
        end,
    },

    { -- File Mark Manager
        dir = plugin_path .. "/arrow.nvim",
        opts = {
            show_icons = false,
            leader_key = '<leader>m', -- Recommended to be a single key
            buffer_leader_key = 'm', -- Per Buffer Mappings
            mappings = {
                edit = "e",
                delete_mode = "d",
                clear_all_items = "D",
                toggle = "w", -- used as save if separate_save_and_remove is true
                open_vertical = "v",
                open_horizontal = "s",
                quit = "q",
                next_item = ".",
                prev_item = ","
            },
        }
    },
}, {
    root = plugin_path .. "/Online",
})
-- vim.api.nvim_set_hl(0, 'WinSeparator', { bg = 'none' })
