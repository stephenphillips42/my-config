-- Basics
vim.opt.showmatch = true        -- show matching brackets.
vim.opt.mouse="v"               -- middle-click paste with mouse
vim.opt.autoindent = true       -- indent a new line the same amount as the line just typed
vim.opt.number = true           -- add line numbers
-- vim.opt.relativenumber = true   -- add line numbers
-- get bash-like tab completions
vim.cmd [[
    set wildmode=longest,list
]]

-- Color
vim.cmd [[
    syntax on
]]
-- colorscheme darkblue

-- Indentation
-- filetype plugin indent on -- enabled by default
vim.opt.tabstop = 4             -- number of columns occupied by a tab character
vim.opt.expandtab = true        -- convert tabs to white space
vim.opt.shiftwidth = 4          -- width for autoindents
vim.opt.softtabstop = 4         -- see multiple spaces as tabstops so <BS> does the right thing

-- Global properties
vim.keymap.set("n", "<F8>", ":syntax sync fromstart<CR>")
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Backups
vim.opt.backup = true
vim.o.undodir = vim.fn.expand("$HOME/.config/nvim/.undo/")
vim.o.backupdir = vim.fn.expand("$HOME/.config/nvim/.backup/")
vim.o.directory = vim.fn.expand("$HOME/.config/nvim/.swp/")

-- Providers
local function system(command)
  local file = assert(io.popen(command, "r"))
  local output = file:read("*all"):gsub("%s+", "")
  file:close()
  return output
end

if vim.fn.executable("python3") > 0 then
  vim.g.python3_host_prog = system("which python3")
end

-- Custom commands
--- Search
vim.keymap.set("n", "<F2>", ":set spell! spell?<CR>")
vim.keymap.set("n", "<F4>", "hlsearch! hlsearch?<CR>")
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.keymap.set("n", "<F9>", ":set relativenumber! relativenumber?<CR>")
--- Splits
vim.keymap.set("n", "<C-t>", ":tabe<CR>")
vim.cmd [[
    command -nargs=* -complete=file Sj set splitbelow <bar> split <args>
    command -nargs=* -complete=file Sk set nosplitbelow <bar> split <args>
    command -nargs=* -complete=file Sd set splitbelow <bar> split <args>
    command -nargs=* -complete=file Su set nosplitbelow <bar> split <args>
    command -nargs=* -complete=file Sh set nosplitright <bar> vertical split <args>
    command -nargs=* -complete=file Sl set splitright <bar> vertical split <args>
]]

-- Neovim leader
vim.g.mapleader = "<Space>"
-- Plugins
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    {
        "bluz71/vim-moonfly-colors",
        priority = 1000, -- make sure to load first
        config = function ()
            -- load the colorscheme here
            vim.cmd("colorscheme moonfly")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function () 
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = {
                    "c", "cpp", "lua", "ninja", "rst",
                    "vim", "vimdoc", "query",
                    "javascript", "html",
                },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },  
            })
        end
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-symbols.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("telescope").setup{
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    }
                }
            }
            require("telescope").load_extension("fzf")
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
            vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
            vim.keymap.set("n", "<leader>fs", builtin.symbols, { desc = "Telescope help tags" })
            vim.keymap.set(
                "n", "<leader>fa",
                function()
                    builtin.find_files({ no_ignore = true, hidden = true })
                end,
                { desc = "Telescope find files (including hidden and .gitignore)" }
            )
        end,
    },
    {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      lazy = false,
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("nvim-tree").setup {}
        vim.keymap.set("n", "<M-e>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
      end,
    },
})
