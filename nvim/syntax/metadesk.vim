" Vim syntax file for Metadesk (.mdesk)
" Language:   Metadesk (by Dion Systems / Ryan Fleury)
" Maintainer: metadesk.nvim
" URL:        https://github.com/ryanfleury/metadesk

if exists("b:current_syntax")
  finish
endif

" ------------------------------------------------------------
" Comments
" ------------------------------------------------------------
syn keyword metadeskTodo contained TODO FIXME XXX NOTE HACK

syn region metadeskLineComment
      \ start="//"
      \ end="$"
      \ keepend
      \ contains=metadeskTodo

syn region metadeskBlockComment
      \ start="/\*"
      \ end="\*/"
      \ fold
      \ contains=metadeskTodo,metadeskBlockComment

" ------------------------------------------------------------
" Strings
" ------------------------------------------------------------
" Regular double-quoted string with escape sequences
syn region metadeskString
      \ start=+"+
      \ skip=+\\"+
      \ end=+"+
      \ contains=metadeskEscape

" Backtick raw strings (no escape processing)
syn region metadeskRawString
      \ start=+`+
      \ end=+`+

syn match metadeskEscape contained /\\[\\nrt"0abfv]/
syn match metadeskEscape contained /\\x[0-9a-fA-F]\{2}/
syn match metadeskEscape contained /\\u[0-9a-fA-F]\{4}/
syn match metadeskEscape contained /\\U[0-9a-fA-F]\{8}/

" ------------------------------------------------------------
" Numbers
" ------------------------------------------------------------
syn match metadeskNumber /\v<[+-]?\d+(\.\d*)?([eE][+-]?\d+)?>/
syn match metadeskNumber /\v<0x[0-9a-fA-F]+>/
syn match metadeskNumber /\v<0b[01]+>/
syn match metadeskNumber /\v<0o[0-7]+>/

" ------------------------------------------------------------
" Tags / Metatags  (@tag_name)
" ------------------------------------------------------------
" Tag name after @
syn match metadeskTagName /\w\+/ contained
" The @ sigil itself
syn match metadeskTag /@\w\+/ contains=metadeskTagName

" Tag parameter list  @tag(...)
syn region metadeskTagParams
      \ matchgroup=metadeskBracket
      \ start=/@\w\+\zs(/
      \ end=/)/
      \ transparent
      \ contains=TOP

" ------------------------------------------------------------
" Labels / node names followed by colon
" ------------------------------------------------------------
syn match metadeskLabel /\w\+\ze\s*:/

" Separator colon
syn match metadeskColon /:/

" Separator comma/semicolon
syn match metadeskSeparator /[,;]/

" ------------------------------------------------------------
" Brackets / set delimiters  { } ( ) [ ]
" ------------------------------------------------------------
syn match metadeskBracket /[{}\[\]()]/

" ------------------------------------------------------------
" Identifiers (bare words that are not labels/tags)
" ------------------------------------------------------------
syn match metadeskIdent /\<[A-Za-z_][A-Za-z0-9_]*\>/

" ------------------------------------------------------------
" Link priorities (last match wins in same region)
" ------------------------------------------------------------
" Keep these after general ident so they override:
syn keyword metadeskNull    null
syn keyword metadeskBool    true false

" ------------------------------------------------------------
" Highlight links
" ------------------------------------------------------------
hi def link metadeskLineComment   Comment
hi def link metadeskBlockComment  Comment
hi def link metadeskTodo          Todo

hi def link metadeskString        String
hi def link metadeskRawString     String
hi def link metadeskEscape        SpecialChar

hi def link metadeskNumber        Number
hi def link metadeskNull          Constant
hi def link metadeskBool          Boolean

hi def link metadeskTag           PreProc
hi def link metadeskTagName       PreProc

hi def link metadeskLabel         Identifier
hi def link metadeskColon         Operator
hi def link metadeskSeparator     Delimiter
hi def link metadeskBracket       Delimiter

hi def link metadeskIdent         Normal

let b:current_syntax = "metadesk"
