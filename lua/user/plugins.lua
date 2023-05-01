local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  print("Installing packer close and reopen Neovim...")
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end
    }
  }
)

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use 'wbthomason/packer.nvim' -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
--themes 
--
  use 'altercation/vim-colors-solarized' --   "(:h solarized)
  use 'ayu-theme/ayu-vim'
  use 'rakr/vim-one'
-- something with git
--
  use 'tpope/vim-fugitive'                 -- (:h fugitive)
-- undos 
--
  use 'sjl/gundo.vim'                      -- (:h Gundo-contents)
-- file explorer
--
--  use 'preservim/nerdtree'                 -- (:h NERDTree-contents)
  use 'nvim-tree/nvim-tree.lua'                 -- (:h NERDTree-contents)
  use 'nvim-tree/nvim-web-devicons'                 -- (:h NERDTree-contents)
--  use 'Xuyuanp/nerdtree-git-plugin'
--  use 'SirVer/ultisnips'                 -- (:h UltiSnips, UltiSnips-basic-syntax)
--
  use 'adelarsq/vim-matchit'
  use 'tpope/vim-surround'
  use 'XadillaX/json-formatter.vim'

-- julia packages
  use 'JuliaEditorSupport/julia-vim'
  use 'jpalardy/vim-slime'

-- c++ stuff
  use 'm-pilia/vim-ccls'

-- lsp autocompletion stuff
  use "rafamadriz/friendly-snippets"
  use 'neovim/nvim-lspconfig'
--  use {"windwp/nvim-autopairs",
--       config = function() require("nvim-autopairs").setup {} end
--      }
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'ray-x/lsp_signature.nvim'
-- Add latex symbol support for nvim-cmp.
  use 'kdheepak/cmp-latex-symbols'
-- vsnip 
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'
-- intendation 
  use "lukas-reineke/indent-blankline.nvim"

-- latex plugin
  use 'lervag/vimtex'

-- gui
  use 'equalsraf/neovim-qt'
-- bottom status bar 
 use 'itchyny/lightline.vim'


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end)
