return {
    {
        "bluz71/vim-moonfly-colors",
        priority = 1000, -- make sure to load first
        config = function ()
            -- load the colorscheme here
            vim.cmd("colorscheme moonfly")
        end,
    },
    { "tpope/vim-sleuth", },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", },
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
            vim.keymap.set("n", "<leader>e",  builtin.diagnostics, { desc = "Diagnostics" })
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
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-vsnip",
            "hrsh7th/vim-vsnip",
            "rafamadriz/friendly-snippets",
        }
    },
    { "mfussenegger/nvim-lint", },
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "jay-babu/mason-nvim-dap.nvim",
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio"
        }
    },
}
