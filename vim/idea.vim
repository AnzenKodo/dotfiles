source ~/Dotfiles/vim/vimrc

set noexpandtab
set ideajoin              " J uses IDE's smarter join
set clipboard+=unnamed,unnamedplus
set listchars=tab:»\ ,trail:.,nbsp:␣

" Plugins (bundled IdeaVim emulations)
" ============================================================================
set surround                " mini.surround -> ys / ds / cs (see remaps below)
set commentary              " gc / gcc comment toggling (bonus, wasn't in nvim config)
set easymotion               " flash.nvim -> <leader>ef style jump-to-char
set NERDTree                " optional project drawer, closest thing to oil.nvim
set argtextobj
set highlightedyank
set matchit
set vim-paragraph-motion
set ReplaceWithRegister
set which-key
set notimeout
set timeoutlen=5000

" Keymaps
" ============================================================================

" Better search-next (keeps result centered, respects search direction)
nnoremap n nzzzv
nnoremap N Nzzzv
vnoremap * "sy/<C-R>s<CR>
vnoremap # "sy?<C-R>s<CR>

" Surround
nmap <leader>sa ys
nmap <leader>sd ds
nmap <leader>sr cs

" Actions =====================================================================

" Show diagnostic under cursor (vim.diagnostic.open_float)
nmap L <Action>(ShowErrorDescription)

" Move line up/down
nmap <A-j> <Action>(MoveLineDown)
nmap <A-k> <Action>(MoveLineUp)
imap <A-j> <Esc><Action>(MoveLineDown)i
imap <A-k> <Esc><Action>(MoveLineUp)i
vmap <A-j> <Action>(MoveLineDown)
vmap <A-k> <Action>(MoveLineUp)

" Maximize / restore split
nmap <leader>w/ <Action>(MaximizeEditorInSplit)

" Buffers / Tabs
nmap [b <Action>(PreviousTab)
nmap ]b <Action>(NextTab)
nmap <leader>bd <Action>(CloseContent)
nmap <leader>ba <Action>(CloseAllEditorsButActive)

" Find / navigate
nmap <leader>ff <Action>(GotoFile)
nmap <leader>fg <Action>(FindInPath)
nmap <leader>fb <Action>(Switcher)
nmap <leader>fo <Action>(RecentFiles)
nmap <leader>fk <Action>(GotoAction)
nmap <leader>fc <Action>(FileStructurePopup)
nmap <leader>/ <Action>(Find)

" Marks / bookmarks
nmap <leader>ma <Action>(ToggleBookmark)
nmap <leader>mf <Action>(ShowBookmarks)
nmap <leader>m1 <Action>(GotoBookmark1)
nmap <leader>m2 <Action>(GotoBookmark2)
nmap <leader>m3 <Action>(GotoBookmark3)
nmap <leader>m4 <Action>(GotoBookmark4)

" File manager
nmap <leader>- <Action>(SelectInProjectView)
nmap - <Action>(SelectInProjectView)

" Git
nmap <leader>gs <Action>(Vcs.Show.Local.Changes)
nmap <leader>gi <Action>(Annotate)
nmap [h <Action>(VcsShowPrevChangeMarker)
nmap ]h <Action>(VcsShowNextChangeMarker)
nmap <leader>gr <Action>(Vcs.RollbackChangedLines)

" Debugger
nmap <leader>dr <Action>(Debug)
nmap <leader>dc <Action>(Resume)
nmap <leader>de <Action>(Stop)
nmap <leader>db <Action>(ToggleLineBreakpoint)
nmap <F1> <Action>(StepOver)
nmap <F2> <Action>(StepInto)
nmap = <Action>(Up)

" Terminal
nmap <C-`> <Action>(ActivateTerminalToolWindow)
imap <C-`> <Esc><Action>(ActivateTerminalToolWindow)

" Multiple cursors
map <C-j> <Action>(EditorCloneCaretBelow)
map <C-k> <Action>(EditorCloneCaretAbove)
nmap <C-e> <Action>(EditorEscape)
imap <C-e> <Action>(EditorEscape)
vmap <C-e> <Action>(EditorEscape)
nmap <A-d> <Action>(SelectNextOccurrence)
xmap <A-d> <Action>(SelectNextOccurrence)
nmap <C-S-d> <Action>(UnselectPreviousOccurrence)
nmap <A-n> <Action>(SelectNextOccurrence)
"nmap <C-d> <Plug>NextWholeOccurrence
"xmap <C-d> <Plug>NextWholeOccurrence

autocmd BufWritePost * action CompileDirty
map <F1> :action CompileDirty<CR>
