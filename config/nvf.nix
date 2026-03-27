# nvf configuration module — mirrors the LazyVim setup from ~/.config/nvim
{ pkgs, lib, ... }:
{
  vim = {
    # ── Aliases ─────────────────────────────────────────────────────────────
    viAlias = false;
    vimAlias = false;

    # ── Core options (from init.lua) ─────────────────────────────────────────
    options = {
      expandtab = true;
      tabstop = 4;
      shiftwidth = 4;
      autoindent = true;
      smartindent = true;
      # shada required by yanky.nvim's default "shada" storage backend
      shada = "!,'100,<50,s10,h";
    };

    # ── Theme: tokyonight (LazyVim default) ──────────────────────────────────
    theme = {
      enable = true;
      name = "tokyonight";
      style = "night"; # "storm" | "night" | "moon" | "day"
      transparent = false;
    };

    # ── LSP ──────────────────────────────────────────────────────────────────
    lsp = {
      enable = true;
      formatOnSave = true;

      # nixd settings — improves pkgs.* attribute completions by giving nixd
      # a nixpkgs expression to evaluate. Adjust the expr if you want to point
      # at a local flake's locked nixpkgs instead.
      servers.nixd.settings.nixd = {
        nixpkgs.expr = "import <nixpkgs> {}";
        # Uncomment to get NixOS option completions:
        # options.nixos.expr = "(builtins.getFlake \"nixpkgs\").legacyPackages.x86_64-linux.nixosModules.nixos";
      };
    };

    # ── Languages ─────────────────────────────────────────────────────────────
    # Each corresponds to a lazyvim.plugins.extras.lang.* entry.
    languages = {
      enableTreesitter = true;
      enableFormat = true;
      enableExtraDiagnostics = true;
      enableDAP = true; # enables DAP for all supporting languages

      # lang.clangd
      clang.enable = true;

      # lang.go
      go.enable = true;

      # lang.haskell
      haskell.enable = true;

      # lang.json
      json.enable = true;

      # lang.markdown
      markdown = {
        enable = true;
        extensions.render-markdown-nvim.enable = true;
      };

      # lang.nix
      nix = {
        enable = true;
        lsp.servers = [ "nixd" ];
        format = {
          enable = true;
          type = [ "nixfmt" ];
        };
      };

      # lang.python
      python.enable = true;

      # lang.rust
      rust = {
        enable = true;
        extensions.crates-nvim.enable = true; # crates.nvim — Cargo.toml UI
      };

      # lang.sql (vim-dadbod + sqls)
      sql = {
        enable = true;
        dialect = "postgresql";
      };

      # lang.toml
      toml.enable = true;

      # lang.typescript
      ts.enable = true;

      # lang.yaml
      yaml.enable = true;

      # lang.zig
      zig.enable = true;

      # Lua (for lazydev.nvim — Neovim plugin API completion/types)
      lua = {
        enable = true;
        lsp.lazydev.enable = true;
      };
    };

    # ── Treesitter ────────────────────────────────────────────────────────────
    treesitter = {
      enable = true;
      addDefaultGrammars = true;
      # Extras beyond what vim.languages.* adds
      grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        query
        regex
        vim
        vimdoc
      ];

      # nvim-ts-autotag (lang.typescript / lang.html — auto-close HTML tags)
      autotagHtml = true;

      # ── Treesitter text objects (nvim-treesitter-textobjects) ───────────────
      # Mirrors the LazyVim defaults
      textobjects = {
        enable = true;
        setupOpts = {
          select = {
            enable = true;
            lookahead = true; # jump to next match if not inside one
            keymaps = {
              af = { query = "@function.outer";    desc = "around function"; };
              "if" = { query = "@function.inner";  desc = "inside function"; };
              ac = { query = "@class.outer";       desc = "around class"; };
              ic = { query = "@class.inner";       desc = "inside class"; };
              ai = { query = "@conditional.outer"; desc = "around conditional"; };
              ii = { query = "@conditional.inner"; desc = "inside conditional"; };
              al = { query = "@loop.outer";        desc = "around loop"; };
              il = { query = "@loop.inner";        desc = "inside loop"; };
              aa = { query = "@parameter.outer";   desc = "around argument"; };
              ia = { query = "@parameter.inner";   desc = "inside argument"; };
              as = { query = "@scope"; query_group = "locals"; desc = "around scope"; };
            };
          };
          move = {
            enable = true;
            set_jumps = true; # add moves to jumplist
            goto_next_start = {
              "]f" = { query = "@function.outer";    desc = "Next function start"; };
              "]c" = { query = "@class.outer";       desc = "Next class start"; };
              "]a" = { query = "@parameter.inner";   desc = "Next argument start"; };
              "]i" = { query = "@conditional.outer"; desc = "Next conditional start"; };
              "]l" = { query = "@loop.outer";        desc = "Next loop start"; };
            };
            goto_next_end = {
              "]F" = { query = "@function.outer"; desc = "Next function end"; };
              "]C" = { query = "@class.outer";    desc = "Next class end"; };
            };
            goto_previous_start = {
              "[f" = { query = "@function.outer";    desc = "Prev function start"; };
              "[c" = { query = "@class.outer";       desc = "Prev class start"; };
              "[a" = { query = "@parameter.inner";   desc = "Prev argument start"; };
              "[i" = { query = "@conditional.outer"; desc = "Prev conditional start"; };
              "[l" = { query = "@loop.outer";        desc = "Prev loop start"; };
            };
            goto_previous_end = {
              "[F" = { query = "@function.outer"; desc = "Prev function end"; };
              "[C" = { query = "@class.outer";    desc = "Prev class end"; };
            };
          };
          swap = {
            enable = true;
            swap_next     = { "<leader>a" = { query = "@parameter.inner"; desc = "Swap with next argument"; }; };
            swap_previous = { "<leader>A" = { query = "@parameter.inner"; desc = "Swap with prev argument"; }; };
          };
        };
      };
    };

    # ── Completion: blink.cmp ─────────────────────────────────────────────────
    autocomplete.blink-cmp.enable = true;

    # ── Telescope ─────────────────────────────────────────────────────────────
    telescope.enable = true;

    # ── Status line (lualine) ──────────────────────────────────────────────────
    statusline.lualine.enable = true;

    # ── Tab line (bufferline) ──────────────────────────────────────────────────
    tabline.nvimBufferline.enable = true;

    # ── Git ───────────────────────────────────────────────────────────────────
    # lang.git extra: gitsigns + diffview
    git.gitsigns = {
      enable = true;
      codeActions.enable = false;
    };
    utility.diffview-nvim.enable = true;

    # ── UI ────────────────────────────────────────────────────────────────────
    ui = {
      borders.enable = true;
      noice.enable = true; # nicer cmdline/message UI
    };

    # ── Visuals ───────────────────────────────────────────────────────────────
    visuals = {
      # ui.indent-blankline
      indent-blankline.enable = true;
      # web-devicons for file icons
      nvim-web-devicons.enable = true;
    };

    # ── Mini.nvim ──────────────────────────────────────────────────────────────
    mini = {
      ai.enable = true;
      pairs.enable = true;
      hipatterns.enable = true; # util.mini-hipatterns
      indentscope.enable = true; # ui.mini-indentscope
      files.enable = true; # editor.mini-files (keymaps set in luaConfigRC)
      icons.enable = true; # mini.icons (LazyVim default)
    };

    # ── Utility ───────────────────────────────────────────────────────────────
    utility = {
      # coding.yanky
      yanky-nvim.enable = true;
      # snacks.nvim (LazyVim uses it for many built-in features)
      snacks-nvim.enable = true;
      # editor.grug-far — find and replace UI
      grug-far-nvim.enable = true;
      # flash.nvim — enhanced search/navigation (LazyVim default)
      motion.flash-nvim.enable = true;
    };

    # ── Which-key ─────────────────────────────────────────────────────────────
    binds.whichKey.enable = true;

    # ── AI / Claude ────────────────────────────────────────────────────────────
    # avante.nvim — in-editor AI chat and code editing via the Claude API.
    # Requires ANTHROPIC_API_KEY to be set in the environment.
    assistant.avante-nvim = {
      enable = false;
      setupOpts = {
        provider = "claude";
        providers.claude = {
          model = "claude-sonnet-4-5";
          max_tokens = 8096;
        };
        behaviour = {
          auto_suggestions = false; # turn on for inline ghost-text suggestions
          auto_set_keymaps = true;
        };
      };
    };

    # ── DAP (debugger) ────────────────────────────────────────────────────────
    # nvim-dap core + UI; adapters are wired by each vim.languages.*.dap.enable
    debugger.nvim-dap = {
      enable = true;
      ui.enable = true;
    };

    # ── Trouble (diagnostics panel, LazyVim default) ──────────────────────────
    lsp.trouble.enable = true;

    # ── Todo-comments + Obsidian ──────────────────────────────────────────────
    notes = {
      todo-comments.enable = true;
      obsidian = {
        enable = true;
        setupOpts.workspaces = [
          {
            name = "personal";
            path = "~/obsidian"; # adjust to your vault path
          }
        ];
      };
    };

    # ── Extra plugins not natively supported by nvf ───────────────────────────
    extraPlugins = {
      # editor.dial
      dial-nvim = {
        package = pkgs.vimPlugins.dial-nvim;
        # dial.nvim has no setup(); augends are configured separately if needed
      };

      # editor.inc-rename
      inc-rename-nvim = {
        package = pkgs.vimPlugins.inc-rename-nvim;
        setup = "require('inc_rename').setup({})";
      };

      # ai.claudecode
      claudecode-nvim = {
        package = pkgs.vimPlugins.claudecode-nvim;
        setup = "require('claudecode').setup({})";
      };

      # test.core — neotest + adapters
      neotest = {
        package = pkgs.vimPlugins.neotest;
        after = [
          "neotest-python"
          "neotest-golang"
          "neotest-haskell"
          "neotest-zig"
        ];
        setup = ''
          require('neotest').setup({
            adapters = {
              require('neotest-python'),
              require('neotest-golang'),
              require('neotest-haskell'),
              require('neotest-zig'),
            },
          })
        '';
      };
      neotest-python = {
        package = pkgs.vimPlugins.neotest-python;
      };
      neotest-golang = {
        package = pkgs.vimPlugins.neotest-golang;
      };
      neotest-haskell = {
        package = pkgs.vimPlugins.neotest-haskell;
      };
      neotest-zig = {
        package = pkgs.vimPlugins.neotest-zig;
      };

      # ts-comments.nvim — better comment strings in TS/TSX/JSX (LazyVim default)
      ts-comments-nvim = {
        package = pkgs.vimPlugins.ts-comments-nvim;
        setup = "require('ts-comments').setup()";
      };

      # persistence.nvim — session management (LazyVim default)
      persistence-nvim = {
        package = pkgs.vimPlugins.persistence-nvim;
        setup = "require('persistence').setup()";
      };

      # markdown-preview.nvim — :MarkdownPreview (lang.markdown extra)
      markdown-preview-nvim = {
        package = pkgs.vimPlugins.markdown-preview-nvim;
      };

      # haskell-snippets.nvim — Haskell snippets (lang.haskell extra)
      haskell-snippets-nvim = {
        package = pkgs.vimPlugins.haskell-snippets-nvim;
        setup = ''
          local ls = require('luasnip')
          local haskell_snippets = require('haskell-snippets').all
          ls.add_snippets('haskell', haskell_snippets, { key = 'haskell' })
        '';
      };

      # venv-selector.nvim — explicit Python venv selection (lang.python extra)
      venv-selector-nvim = {
        package = pkgs.vimPlugins.venv-selector-nvim;
        setup = "require('venv-selector').setup({})";
      };

      # TypeScript/JavaScript DAP via nvim-dap-vscode-js + vscode-js-debug
      nvim-dap-vscode-js = {
        package = pkgs.vimPlugins.nvim-dap-vscode-js;
        after = [ "nvim-dap" ];
        setup = ''
          require("dap-vscode-js").setup({
            debugger_path = "${pkgs.vscode-extensions.ms-vscode.js-debug}",
            adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
          })
          for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
            require("dap").configurations[language] = {
              {
                type = "pwa-node",
                request = "launch",
                name = "Launch file",
                program = "''${file}",
                cwd = "''${workspaceFolder}",
              },
              {
                type = "pwa-node",
                request = "attach",
                name = "Attach",
                processId = require("dap.utils").pick_process,
                cwd = "''${workspaceFolder}",
              },
            }
          end
        '';
      };

      # christoomey/vim-tmux-navigator (keymaps in luaConfigRC)
      vim-tmux-navigator = {
        package = pkgs.vimPlugins.vim-tmux-navigator;
      };

      # guess-indent.nvim
      guess-indent-nvim = {
        package = pkgs.vimPlugins.guess-indent-nvim;
        setup = ''
          require('guess-indent').setup({
            auto_cmd = true,
            override_editorconfig = true,
          })
        '';
      };

      # jjsigns.nvim — package injected from modules/neovim.nix
      jjsigns-nvim = {
        setup = "require('jjsigns').setup()";
      };

      # jiaoshijie/undotree — package injected from modules/neovim.nix
      # (different from mbbill/undotree; uses require('undotree').toggle())
      jiaoshijie-undotree = { };

      # tmux-status.nvim — package injected from modules/neovim.nix
      tmux-status-nvim = {
        setup = "require('tmux-status').setup({})";
      };
    };

    # ── Extra Lua configuration ───────────────────────────────────────────────
    luaConfigRC = {
      # LazyVim core keymaps (https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua)
      lazyvim-keymaps = lib.nvim.dag.entryAnywhere ''
        local map = vim.keymap.set

        -- better up/down (respects word wrap)
        map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
        map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
        map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
        map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

        -- resize windows with <C-arrow>
        map("n", "<C-Up>",    "<cmd>resize +2<cr>",             { desc = "Increase Window Height" })
        map("n", "<C-Down>",  "<cmd>resize -2<cr>",             { desc = "Decrease Window Height" })
        map("n", "<C-Left>",  "<cmd>horizontal resize -2<cr>",  { desc = "Decrease Window Width" })
        map("n", "<C-Right>", "<cmd>horizontal resize +2<cr>",  { desc = "Increase Window Width" })

        -- move lines
        map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==",                           { desc = "Move Down" })
        map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==",                     { desc = "Move Up" })
        map("i", "<A-j>", "<esc><cmd>execute 'move .+' . v:count1<cr>==gi",                    { desc = "Move Down" })
        map("i", "<A-k>", "<esc><cmd>execute 'move .-' . (v:count1 + 1)<cr>==gi",              { desc = "Move Up" })
        map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",               { desc = "Move Down" })
        map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv",        { desc = "Move Up" })

        -- buffers
        map("n", "<S-h>",      "<cmd>bprevious<cr>",  { desc = "Prev Buffer" })
        map("n", "<S-l>",      "<cmd>bnext<cr>",      { desc = "Next Buffer" })
        map("n", "[b",         "<cmd>bprevious<cr>",  { desc = "Prev Buffer" })
        map("n", "]b",         "<cmd>bnext<cr>",      { desc = "Next Buffer" })
        map("n", "<leader>bb", "<cmd>e #<cr>",        { desc = "Switch to Other Buffer" })
        map("n", "<leader>`",  "<cmd>e #<cr>",        { desc = "Switch to Other Buffer" })
        map("n", "<leader>bD", "<cmd>:bd<cr>",        { desc = "Delete Buffer and Window" })
        map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })

        -- clear search, diff update and redraw
        map("n", "<leader>ur", "<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-L><cr>",
          { desc = "Redraw / Clear hlsearch / Diff Update" })

        -- better n/N (keep search result centred)
        map({ "n", "x" }, "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
        map({ "n", "x" }, "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
        map("o", "n", "'Nn'[v:searchforward]",                { expr = true, desc = "Next Search Result" })
        map("o", "N", "'nN'[v:searchforward]",                { expr = true, desc = "Prev Search Result" })

        -- undo break-points in insert mode
        map("i", ",", ",<c-g>u")
        map("i", ".", ".<c-g>u")
        map("i", ";", ";<c-g>u")

        -- save file
        map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

        -- keywordprg
        map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

        -- better indenting in visual mode
        map("v", "<", "<gv")
        map("v", ">", ">gv")

        -- new file
        map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

        -- quickfix / location list
        map("n", "<leader>xl", "<cmd>lopen<cr>",  { desc = "Location List" })
        map("n", "<leader>xq", "<cmd>copen<cr>",  { desc = "Quickfix List" })
        map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
        map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

        -- format (on-demand)
        map({ "n", "v" }, "<leader>cf", function() vim.lsp.buf.format({ async = true }) end,
          { desc = "Format" })

        -- diagnostics
        map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
        map("n", "]d", function() vim.diagnostic.goto_next() end,                               { desc = "Next Diagnostic" })
        map("n", "[d", function() vim.diagnostic.goto_prev() end,                               { desc = "Prev Diagnostic" })
        map("n", "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Next Error" })
        map("n", "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Prev Error" })
        map("n", "]w", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end,  { desc = "Next Warning" })
        map("n", "[w", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end,  { desc = "Prev Warning" })

        -- inspect highlight / treesitter
        map("n", "<leader>ui", vim.show_pos,  { desc = "Inspect Pos" })
        map("n", "<leader>uI", vim.show_tree, { desc = "Inspect Tree" })

        -- windows
        map("n", "<leader>w",  "<C-w>",       { desc = "Windows", remap = true })
        map("n", "<leader>-",  "<C-W>s",      { desc = "Split Window Below", remap = true })
        map("n", "<leader>|",  "<C-W>v",      { desc = "Split Window Right", remap = true })
        map("n", "<leader>wd", "<C-W>c",      { desc = "Delete Window", remap = true })

        -- tabs
        map("n", "<leader><tab>l",   "<cmd>tablast<cr>",   { desc = "Last Tab" })
        map("n", "<leader><tab>o",   "<cmd>tabonly<cr>",   { desc = "Close Other Tabs" })
        map("n", "<leader><tab>f",   "<cmd>tabfirst<cr>",  { desc = "First Tab" })
        map("n", "<leader><tab><tab>","<cmd>tabnew<cr>",   { desc = "New Tab" })
        map("n", "<leader><tab>]",   "<cmd>tabnext<cr>",   { desc = "Next Tab" })
        map("n", "<leader><tab>d",   "<cmd>tabclose<cr>",  { desc = "Close Tab" })
        map("n", "<leader><tab>[",   "<cmd>tabprevious<cr>",{ desc = "Previous Tab" })

        -- quit all
        map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

        -- terminal (via snacks)
        map("n", "<leader>fT", function() Snacks.terminal() end,        { desc = "Terminal (cwd)" })
        map("n", "<leader>ft", function() Snacks.terminal(nil, { cwd = vim.fn.getcwd() }) end, { desc = "Terminal (root dir)" })
        map({ "n", "t" }, "<C-/>", function() Snacks.terminal() end,   { desc = "Toggle Terminal" })
        map({ "n", "t" }, "<C-_>", function() Snacks.terminal() end,   { desc = "Toggle Terminal" })

        -- git (via snacks lazygit)
        map("n", "<leader>gg", function() Snacks.lazygit() end,         { desc = "Lazygit (Root Dir)" })
        map("n", "<leader>gG", function() Snacks.lazygit({ cwd = vim.fn.getcwd() }) end, { desc = "Lazygit (cwd)" })
      '';

      # vim-tmux-navigator keymaps (from vim-tmux-navigator.lua)
      tmux-navigator-keymaps = lib.nvim.dag.entryAnywhere ''
        vim.keymap.set("n", "<C-h>",  "<cmd>TmuxNavigateLeft<cr>",     { silent = true })
        vim.keymap.set("n", "<C-j>",  "<cmd>TmuxNavigateDown<cr>",     { silent = true })
        vim.keymap.set("n", "<C-k>",  "<cmd>TmuxNavigateUp<cr>",       { silent = true })
        vim.keymap.set("n", "<C-l>",  "<cmd>TmuxNavigateRight<cr>",    { silent = true })
        vim.keymap.set("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", { silent = true })
      '';

      # mini.files keymaps (from extend-mini-files.lua)
      mini-files-keymaps = lib.nvim.dag.entryAnywhere ''
        vim.keymap.set("n", "<leader>e", function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end, { desc = "Open mini.files (directory of current file)" })

        vim.keymap.set("n", "<leader>E", function()
          require("mini.files").open(vim.uv.cwd(), true)
        end, { desc = "Open mini.files (cwd)" })

        vim.keymap.set("n", "<leader>fm", function()
          require("mini.files").open(vim.fn.getcwd(), true)
        end, { desc = "Open mini.files (root)" })
      '';

      # undotree keymap (from undotree.lua)
      undotree-keymap = lib.nvim.dag.entryAnywhere ''
        vim.keymap.set("n", "<leader>u", function()
          require("undotree").toggle()
        end, { desc = "Toggle undotree" })
      '';

      # Disable rtp plugins that LazyVim also disables
      disabled-rtp-plugins = lib.nvim.dag.entryBefore [ "pluginConfigs" ] ''
        vim.g.loaded_gzip              = 1
        vim.g.loaded_tar               = 1
        vim.g.loaded_tarPlugin         = 1
        vim.g.loaded_zip               = 1
        vim.g.loaded_zipPlugin         = 1
        vim.g.loaded_2html_plugin      = 1
        vim.g.loaded_tutor_mode_plugin = 1
      '';
    };

    # ── Extra system packages needed by LSPs / formatters ────────────────────
    extraPackages = with pkgs; [
      # Nix
      nixd
      nixfmt

      # Go
      gopls
      golangci-lint

      # Haskell
      haskell-language-server

      # Rust
      rust-analyzer
      cargo
      rustfmt

      # Python
      pyright
      ruff

      # TypeScript / JS
      nodePackages.typescript-language-server
      nodePackages.prettier

      # C / C++
      clang-tools # includes clangd

      # Markdown / misc
      marksman
      yaml-language-server
      taplo # toml
      zls # zig
      sqls # sql

      # Formatters
      stylua
      shfmt
      shellcheck
    ];
  };
}
