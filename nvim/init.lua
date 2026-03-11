-- Neovim configuration
-- Part of vimlink: https://github.com/augustodamasceno/vimlink
--
-- Copyright (c) 2015-2026, Augusto Damasceno.
-- All rights reserved.
-- SPDX-License-Identifier: BSD-2-Clause

-- ============================================================
-- OPTIONS
-- ============================================================
local opt = vim.opt

opt.number         = true
opt.syntax         = "on"
opt.tabstop        = 4
opt.shiftwidth     = 4
opt.expandtab      = false          -- keep actual tab characters
opt.background     = "dark"
opt.backspace      = { "indent", "eol", "start" }
opt.laststatus     = 2
opt.signcolumn     = "yes"
opt.termguicolors  = true

-- English dictionary (shared with Vim setup, used for <C-x><C-k> completion)
opt.dictionary:append(vim.fn.expand("~/.dic/en_US.dic"))

-- ============================================================
-- LEADER
-- ============================================================
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- Suppress nvim-lspconfig deprecation notice for Nvim < 0.11
do
  local _dep = vim.deprecate
  vim.deprecate = function(name, ...)
    if name == "nvim-lspconfig support for Nvim 0.10 or older" then return end
    return _dep(name, ...)
  end
end

-- ============================================================
-- LAZY.NVIM BOOTSTRAP
-- ============================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================
-- PLUGINS
-- ============================================================
require("lazy").setup({

  -- ─── Infrastructure ──────────────────────────────────────
  { "nvim-lua/plenary.nvim",        lazy = true },
  { "nvim-tree/nvim-web-devicons",  lazy = true },

  -- ─── Colorscheme ─────────────────────────────────────────
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        integrations = {
          treesitter  = true,
          native_lsp  = { enabled = true },
          indent_blankline = { enabled = true },
          gitsigns    = true,
          telescope   = { enabled = true },
          harpoon     = true,
          lualine     = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- ─── Syntax / Parsing ────────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    lazy  = false,
    build = ":TSUpdate",
    config = function()
      -- Ensure parsers for common languages are installed
      require("nvim-treesitter").install({
        "c", "cpp", "python", "lua", "bash", "cmake", "make",
        "markdown", "markdown_inline",
      })
      -- Keep regex highlighting for markdown so bold/italic/headings get color
      vim.api.nvim_create_autocmd("FileType", {
        pattern  = "markdown",
        callback = function(args)
          vim.bo[args.buf].syntax = "markdown"
        end,
      })
    end,
  },

  -- ─── LSP ─────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lsp = require("lspconfig")

      -- C / C++
      lsp.clangd.setup({})
      -- Python
      lsp.pyright.setup({})
      -- CMake
      lsp.cmake.setup({})

      -- Keymaps applied when any LSP attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = function(lhs, rhs)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf })
          end
          map("gd",         vim.lsp.buf.definition)
          map("gD",         vim.lsp.buf.declaration)
          map("gr",         vim.lsp.buf.references)
          map("gi",         vim.lsp.buf.implementation)
          map("K",          vim.lsp.buf.hover)
          map("<leader>rn", vim.lsp.buf.rename)
          map("<leader>ca", vim.lsp.buf.code_action)
          map("<leader>f",  function() vim.lsp.buf.format({ async = true }) end)
        end,
      })
    end,
  },

  -- ─── Completion ──────────────────────────────────────────
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<Tab>"]     = cmp.mapping.select_next_item(),
          ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- ─── Clangd Extensions (C / C++) ─────────────────────────
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp" },
    config = function()
      require("clangd_extensions").setup({})
    end,
  },

  -- ─── Debugger ────────────────────────────────────────────
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,          desc = "Continue" },
      { "<leader>ds", function() require("dap").step_over() end,         desc = "Step over" },
      { "<leader>di", function() require("dap").step_into() end,         desc = "Step into" },
      { "<leader>do", function() require("dap").step_out() end,          desc = "Step out" },
    },
    config = function()
      local dap = require("dap")

      -- GDB adapter (C / C++)
      dap.adapters.gdb = {
        type    = "executable",
        command = "gdb",
        args    = { "--interpreter=dap", "--eval-command", "set print pretty on" },
      }
      local c_config = {
        {
          name    = "Launch",
          type    = "gdb",
          request = "launch",
          program = function() return vim.fn.input("Path to executable: ") end,
          cwd     = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
      }
      dap.configurations.c   = c_config
      dap.configurations.cpp = c_config

      -- debugpy adapter (Python)
      dap.adapters.python = {
        type    = "executable",
        command = "python3",
        args    = { "-m", "debugpy.adapter" },
      }
      dap.configurations.python = {
        {
          type       = "python",
          request    = "launch",
          name       = "Launch file",
          program    = "${file}",
          pythonPath = function() return vim.fn.exepath("python3") end,
        },
      }

      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
      vim.keymap.set("n", "<leader>dc", dap.continue)
      vim.keymap.set("n", "<leader>ds", dap.step_over)
      vim.keymap.set("n", "<leader>di", dap.step_into)
      vim.keymap.set("n", "<leader>do", dap.step_out)
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = { "<leader>du" },
    config = function()
      local dapui = require("dapui")
      dapui.setup()
      local dap = require("dap")
      dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end
      vim.keymap.set("n", "<leader>du", dapui.toggle)
    end,
  },

  -- ─── File Manager ────────────────────────────────────────
  {
    "stevearc/oil.nvim",
    cmd  = "Oil",
    keys = { { "-", "<cmd>Oil<cr>", desc = "Open Oil file manager" } },
    config = function()
      require("oil").setup()
    end,
  },

  -- ─── Navigation ──────────────────────────────────────────
  {
    "ThePrimeagen/harpoon",
    branch       = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys         = { "<leader>h" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
      vim.keymap.set("n", "<leader>hh", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)
      for i = 1, 4 do
        vim.keymap.set("n", "<leader>h" .. i, function() harpoon:list():select(i) end)
      end
    end,
  },

  -- ─── Fuzzy Finder ────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    cmd          = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>",   desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",    desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",      desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",    desc = "Help tags" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>",  desc = "Diagnostics" },
    },
    config = function()
      require("telescope").setup({})
    end,
  },

  -- ─── Git ─────────────────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs  = package.loaded.gitsigns
          local map = function(lhs, rhs)
            vim.keymap.set("n", lhs, rhs, { buffer = bufnr })
          end
          map("]c",         gs.next_hunk)
          map("[c",         gs.prev_hunk)
          map("<leader>gs", gs.stage_hunk)
          map("<leader>gu", gs.undo_stage_hunk)
          map("<leader>gp", gs.preview_hunk)
          map("<leader>gb", function() gs.blame_line({ full = true }) end)
        end,
      })
    end,
  },

  -- ─── Diagnostics ─────────────────────────────────────────
  {
    "folke/trouble.nvim",
    cmd  = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer diagnostics (Trouble)" },
    },
    config = function()
      require("trouble").setup()
    end,
  },

  -- ─── CMake ───────────────────────────────────────────────
  {
    "Civitasv/cmake-tools.nvim",
    cmd          = { "CMakeBuild", "CMakeRun", "CMakeDebug", "CMakeClean", "CMakeGenerate" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("cmake-tools").setup({})
    end,
  },

  -- ─── Status Line ─────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    event        = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({ options = { theme = "auto" } })
    end,
  },

  -- ─── Auto Pairs ──────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  -- ─── Indent Guides ───────────────────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main  = "ibl",
    config = function()
      require("ibl").setup()
    end,
  },

  -- ─── Formatting ──────────────────────────────────────────
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          c      = { "clang_format" },
          cpp    = { "clang_format" },
          python = { "black" },
          lua    = { "stylua" },
        },
        format_on_save = { timeout_ms = 500, lsp_fallback = true },
      })
    end,
  },

  -- ─── GitHub Copilot ──────────────────────────────────────
  {
    "zbirenbaum/copilot.lua",
    cmd   = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled     = true,
          auto_trigger = true,
          keymap = {
            accept  = "<M-CR>",
            next    = "<M-]>",
            prev    = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = { enabled = false },
      })
    end,
  },

}, {
  ui = { border = "rounded" },
})

-- ============================================================
-- KEYMAPS (non-plugin)
-- ============================================================
local map = vim.keymap.set

-- Window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")

-- Buffer navigation  (<C-b> matches Vim setup)
map("n", "<C-b>", "<cmd>bnext<cr>")

-- Re-indent all lines  (<C-i> matches Vim setup)
map("n", "<C-i>", "gg=G<C-o>")

-- Next diagnostic  (<C-e> matches Vim setup)
map("n", "<C-e>", vim.diagnostic.goto_next)

-- Convert tabs to 4 spaces (ctabs — matches Vim setup)
vim.api.nvim_create_user_command("Ctabs", "%s/\t/    /g", {})
