" Built-In Functionality
"" General
let mapleader = ','

set hidden " Allow background buffers without saving
set spell spelllang=en_us
set splitright " Split to right by default
set nowrap

"" Search and Substitute
set gdefault " use global flag by default in s: commands
set nohls
set ignorecase 
set smartcase " don't ignore capitals in searches

"" Backup, Swap and Undo
set undofile " Persistent Undo
set backupdir-='.'

""" NetRW
let g:netrw_liststyle=3 " Detail View
let g:netrw_sort_by="exten"
let g:netrw_sizestyle = "H" " Human-readable file sizes
"let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+' " hide dotfiles
"let g:netrw_hide = 1 " hide dotfiles by default
let g:netrw_banner = 0 " Turn off banner

""" Explore in vertical buffer
nnoremap <Leader>e :Explore! <enter>

"" Mappings
nnoremap ; :
nnoremap <C-H> :bp <enter>
nnoremap <C-L> :bn <enter>
nnoremap <Leader>w :w <enter>
nnoremap <Leader>q :bd <enter>


noremap <Leader>x "+

" Python

"let g:python3_host_prog = "/usr/bin/python3"

let g:venvpath = finddir(".venv", ";")
if g:venvpath != ''
	let $PATH = g:venvpath."/bin:".$PATH
endif

" Plugins

call plug#begin()

""" Basics
Plug 'tpope/vim-sensible'
Plug 'sheerun/vim-polyglot'
Plug 'Konfekt/vim-compilers'
Plug 'neovim/nvim-lspconfig'

""" General Functionality
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'stevearc/conform.nvim'

""" Particular Functionality
Plug 'github/copilot.vim'
Plug 'nvim-lua/plenary.nvim' " Required for Copilot Chat
Plug 'CopilotC-Nvim/CopilotChat.nvim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'godlygeek/tabular'
Plug 'vimoutliner/vimoutliner'

call plug#end()


""" LSP Config

lua << EOF
	local lspconfig = require 'lspconfig'
	lspconfig.ruff.setup{}
	local venv = vim.api.nvim_get_var('venvpath')
	local pythonPath = venv and venv..'/bin/python' or nil
	lspconfig.pyright.setup{
			capabilities = (function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
            return capabilities
      end)(),
			settings = {
					pyright = {
							disableOrganizeImports = true,
					},
					python = {
							pythonPath = pythonPath,
							analysis = {
									diagnosticSeverityOverrides = {
										reportTypedDictNotRequiredAccess = 'none',
									}
							}
					},
			}
	}
	vim.keymap.set('n', 'grn', vim.lsp.buf.rename)
	vim.keymap.set('n', 'gra', vim.lsp.buf.code_action)
	vim.keymap.set('n', 'grr', vim.lsp.buf.references)
	vim.keymap.set('n', 'grf', vim.diagnostic.open_float)
	vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help)
EOF

""" Autofix

lua << EOF
require 'conform'.setup{
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
  formatters_by_ft={
		python = {"ruff_fix", "ruff_format"},
		yaml = {"prettier"},
		html = {"prettier"},
		css = {"prettier"},
		sass = {"prettier"},
		javascript = {"prettier"},
	},
}
EOF

""" Copilot Chat
lua << EOF
require'CopilotChat'.setup()
EOF
