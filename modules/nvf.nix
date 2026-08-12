# nvf neovim configuration — flake-parts home-manager modules
#
# flake.modules.homeManager.nvf        — installs as "nvim" (default editor)
# flake.modules.homeManager.nvf-separate — installs as "nvf" only; lets a
#                                          different neovim own "nvim"
{ inputs, ... }:
let
  # ── Shared nvf module ──────────────────────────────────────────────────────
  # Called by both homeManager modules. Receives the nvf-extended lib and pkgs
  # from the module system, so lib.nvim.dag.* is available.
  nvfModule =
    { lib, pkgs, ... }:
    let
      jjsigns-nvim = pkgs.vimUtils.buildVimPlugin {
        name = "jjsigns-nvim";
        src = inputs.jjsigns-nvim;
      };
      jiaoshijie-undotree = pkgs.vimUtils.buildVimPlugin {
        name = "undotree";
        src = inputs.jiaoshijie-undotree;
      };
    in
    {
      vim = {
        # ── Core options (from init.lua) ──────────────────────────────────────
        options = {
          expandtab = true;
          tabstop = 4;
          shiftwidth = 4;
          autoindent = true;
          smartindent = true;
          # shada required by yanky.nvim's default "shada" storage backend
          shada = "!,'100,<50,s10,h";
        };

        clipboard = {
          enable = true;
          providers.wl-copy.enable = pkgs.stdenv.isLinux; # TODO not for servers!
          registers = "unnamedplus";
        };

        # ── Theme: tokyonight ─────────────────────────────────────────────────
        theme = {
          enable = true;
          name = "tokyonight";
          style = "night";
          transparent = false;
        };

        # ── LSP ───────────────────────────────────────────────────────────────
        lsp = {
          enable = true;
          formatOnSave = true;
          servers.nixd.settings.nixd = {
            nixpkgs.expr = "import <nixpkgs> {}";
            nixos.expr = "(builtins.getFlake \"/home/shaver/dtfls\").nixosConfigurations.splashdown.options";
            home-manager.expr = "(builtins.getFlake \"/home/shaver/dtfls\").homeConfigurations.shaver.options";
          };
          trouble.enable = true;
        };

        # ── Languages ─────────────────────────────────────────────────────────
        languages = {
          enableTreesitter = true;
          enableFormat = true;
          enableExtraDiagnostics = true;
          enableDAP = true;

          go.enable = true;
          json.enable = true;
          markdown = {
            enable = true;
            extensions.render-markdown-nvim.enable = true;
          };
          nix = {
            enable = true;
            lsp.servers = [ "nixd" ];
            format = {
              enable = true;
              type = [ "nixfmt" ];
            };
          };
          python.enable = true;
          rust = {
            enable = true;
            extensions.crates-nvim.enable = true;
          };
          toml.enable = true;
          typescript.enable = true;
          yaml.enable = true;
          lua = {
            enable = true;
            extensions.lazydev.enable = true;
          };
        };

        # ── Treesitter ────────────────────────────────────────────────────────
        treesitter = {
          enable = true;
          addDefaultGrammars = true;
          grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            bash
            query
            regex
            vim
            vimdoc
          ];
          autotagHtml = true;
          textobjects = {
            enable = true;
            setupOpts = {
              select = {
                enable = true;
                lookahead = true;
                keymaps = {
                  af = {
                    query = "@function.outer";
                    desc = "around function";
                  };
                  "if" = {
                    query = "@function.inner";
                    desc = "inside function";
                  };
                  ac = {
                    query = "@class.outer";
                    desc = "around class";
                  };
                  ic = {
                    query = "@class.inner";
                    desc = "inside class";
                  };
                  ai = {
                    query = "@conditional.outer";
                    desc = "around conditional";
                  };
                  ii = {
                    query = "@conditional.inner";
                    desc = "inside conditional";
                  };
                  al = {
                    query = "@loop.outer";
                    desc = "around loop";
                  };
                  il = {
                    query = "@loop.inner";
                    desc = "inside loop";
                  };
                  aa = {
                    query = "@parameter.outer";
                    desc = "around argument";
                  };
                  ia = {
                    query = "@parameter.inner";
                    desc = "inside argument";
                  };
                  as = {
                    query = "@scope";
                    query_group = "locals";
                    desc = "around scope";
                  };
                };
              };
              move = {
                enable = true;
                set_jumps = true;
                goto_next_start = {
                  "]f" = {
                    query = "@function.outer";
                    desc = "Next function start";
                  };
                  "]c" = {
                    query = "@class.outer";
                    desc = "Next class start";
                  };
                  "]a" = {
                    query = "@parameter.inner";
                    desc = "Next argument start";
                  };
                  "]i" = {
                    query = "@conditional.outer";
                    desc = "Next conditional start";
                  };
                  "]l" = {
                    query = "@loop.outer";
                    desc = "Next loop start";
                  };
                };
                goto_next_end = {
                  "]F" = {
                    query = "@function.outer";
                    desc = "Next function end";
                  };
                  "]C" = {
                    query = "@class.outer";
                    desc = "Next class end";
                  };
                };
                goto_previous_start = {
                  "[f" = {
                    query = "@function.outer";
                    desc = "Prev function start";
                  };
                  "[c" = {
                    query = "@class.outer";
                    desc = "Prev class start";
                  };
                  "[a" = {
                    query = "@parameter.inner";
                    desc = "Prev argument start";
                  };
                  "[i" = {
                    query = "@conditional.outer";
                    desc = "Prev conditional start";
                  };
                  "[l" = {
                    query = "@loop.outer";
                    desc = "Prev loop start";
                  };
                };
                goto_previous_end = {
                  "[F" = {
                    query = "@function.outer";
                    desc = "Prev function end";
                  };
                  "[C" = {
                    query = "@class.outer";
                    desc = "Prev class end";
                  };
                };
              };
              swap = {
                enable = true;
                swap_next = {
                  "<leader>a" = {
                    query = "@parameter.inner";
                    desc = "Swap with next argument";
                  };
                };
                swap_previous = {
                  "<leader>A" = {
                    query = "@parameter.inner";
                    desc = "Swap with prev argument";
                  };
                };
              };
            };
          };
        };

        # ── Completion ────────────────────────────────────────────────────────
        autocomplete.blink-cmp.enable = true;

        # ── Telescope ─────────────────────────────────────────────────────────
        telescope.enable = true;

        # ── Status / tab line ─────────────────────────────────────────────────
        statusline.lualine.enable = true;
        tabline.nvimBufferline.enable = true;

        # ── Git ───────────────────────────────────────────────────────────────
        git.gitsigns = {
          enable = true;
          codeActions.enable = false;
        };
        utility.diffview-nvim.enable = true;

        # ── UI ────────────────────────────────────────────────────────────────
        ui = {
          borders.enable = true;
          noice.enable = true;
        };

        # ── Visuals ───────────────────────────────────────────────────────────
        visuals = {
          indent-blankline.enable = true;
          nvim-web-devicons.enable = true;
        };

        # ── Mini.nvim ─────────────────────────────────────────────────────────
        mini = {
          ai.enable = true;
          pairs.enable = false;
          hipatterns.enable = true;
          indentscope.enable = true;
          files.enable = true;
          icons.enable = true;
          starter.enable = true;
        };

        # ── Utility ───────────────────────────────────────────────────────────
        utility = {
          yanky-nvim.enable = true;
          snacks-nvim = {
            enable = true;
            setupOpts = {
              terminal.enabled = true;
              lazygit.enabled = true;
              notifier.enabled = true;
              bigfile.enabled = true;
              quickfile.enabled = true;
              bufdelete.enabled = true;
            };
          };
          grug-far-nvim.enable = true;
          motion.flash-nvim.enable = true;
        };

        # ── Which-key ─────────────────────────────────────────────────────────
        binds.whichKey.enable = true;

        # ── AI / Claude ───────────────────────────────────────────────────────
        assistant.avante-nvim = {
          enable = false;
          setupOpts = {
            provider = "claude";
            providers.claude = {
              model = "claude-sonnet-4-5";
              max_tokens = 8096;
            };
            behaviour = {
              auto_suggestions = false;
              auto_set_keymaps = true;
            };
          };
        };

        # ── DAP ───────────────────────────────────────────────────────────────
        debugger.nvim-dap = {
          enable = true;
          ui.enable = true;
        };

        # ── Notes ─────────────────────────────────────────────────────────────
        notes = {
          todo-comments.enable = true;
        };

        # ── Extra plugins ─────────────────────────────────────────────────────
        extraPlugins = {
          dial-nvim = {
            package = pkgs.vimPlugins.dial-nvim;
          };
          inc-rename-nvim = {
            package = pkgs.vimPlugins.inc-rename-nvim;
            setup = "require('inc_rename').setup({})";
          };
          neotest = {
            package = pkgs.vimPlugins.neotest;
            after = [
              "neotest-python"
              "neotest-golang"
              "neotest-haskell"
            ];
            setup = ''
              require('neotest').setup({
                adapters = {
                  require('neotest-python'),
                  require('neotest-golang'),
                  require('neotest-haskell'),
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
          ts-comments-nvim = {
            package = pkgs.vimPlugins.ts-comments-nvim;
            setup = "require('ts-comments').setup()";
          };
          persistence-nvim = {
            package = pkgs.vimPlugins.persistence-nvim;
            setup = "require('persistence').setup()";
          };
          markdown-preview-nvim = {
            package = pkgs.vimPlugins.markdown-preview-nvim;
          };
          haskell-snippets-nvim = {
            package = pkgs.vimPlugins.haskell-snippets-nvim;
            setup = ''
              local ls = require('luasnip')
              local haskell_snippets = require('haskell-snippets').all
              ls.add_snippets('haskell', haskell_snippets, { key = 'haskell' })
            '';
          };
          venv-selector-nvim = {
            package = pkgs.vimPlugins.venv-selector-nvim;
            setup = "require('venv-selector').setup({})";
          };
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
          vim-tmux-navigator = {
            package = pkgs.vimPlugins.vim-tmux-navigator;
          };
          vim-sleuth.package = pkgs.vimPlugins.vim-sleuth;
          vim-obsession.package = pkgs.vimPlugins.vim-obsession;
          guess-indent-nvim = {
            package = pkgs.vimPlugins.guess-indent-nvim;
            setup = ''
              require('guess-indent').setup({
                auto_cmd = true,
                override_editorconfig = false,
              })
            '';
          };
          jjsigns-nvim = {
            package = jjsigns-nvim;
            setup = "require('jjsigns').setup()";
          };
          jiaoshijie-undotree = {
            package = jiaoshijie-undotree;
          };
        };

        # ── Extra Lua ─────────────────────────────────────────────────────────
        luaConfigRC = {
          tmux-navigator-keymaps = lib.nvim.dag.entryAnywhere ''
            vim.keymap.set("n", "<C-h>",  "<cmd>TmuxNavigateLeft<cr>",     { silent = true })
            vim.keymap.set("n", "<C-j>",  "<cmd>TmuxNavigateDown<cr>",     { silent = true })
            vim.keymap.set("n", "<C-k>",  "<cmd>TmuxNavigateUp<cr>",       { silent = true })
            vim.keymap.set("n", "<C-l>",  "<cmd>TmuxNavigateRight<cr>",    { silent = true })
            vim.keymap.set("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", { silent = true })
          '';
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
          undotree-keymap = lib.nvim.dag.entryAnywhere ''
            vim.keymap.set("n", "<leader>u", function()
              require("undotree").toggle()
            end, { desc = "Toggle undotree" })
          '';
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

        # ── Extra system packages ─────────────────────────────────────────────
        extraPackages = with pkgs; [
          nixd
          nixfmt
          gopls
          golangci-lint
          haskell-language-server
          rust-analyzer
          cargo
          rustfmt
          pyright
          ruff
          typescript-language-server
          prettier
          clang-tools
          marksman
          yaml-language-server
          taplo
          zls
          sqls
          stylua
          shfmt
          shellcheck
        ];
      };
    };
in
{
  # ── nvf: installs as "nvim" (replaces default neovim) ──────────────────────
  flake.modules.homeManager.nvf =
    { ... }:
    {
      imports = [ inputs.nvf.homeManagerModules.nvf ];
      programs.nvf = {
        enable = true;
        defaultEditor = true;
        settings = {
          imports = [ nvfModule ];
          vim = {
            viAlias = true;
            vimAlias = true;
          };
        };
      };
    };

  # ── nvf-separate: installs as "nvf" only; leaves "nvim" alone ──────────────
  flake.modules.homeManager.nvf-separate =
    { pkgs, ... }:
    let
      nvfPackage =
        (inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [ nvfModule ];
        }).neovim;
    in
    {
      home.packages = [
        (pkgs.runCommandLocal "nvf" { } ''
          mkdir -p $out/bin
          ln -s ${nvfPackage}/bin/nvim $out/bin/nvf
        '')
      ];
    };
}
