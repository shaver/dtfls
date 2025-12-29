{
  lib,
  config,
  pkgs,
  ...
}:
let
  configRepo = "${config.home.homeDirectory}/nixconfig";
in
{
  home = {
    username = "shaver";
    homeDirectory = lib.mkDefault "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/shaver";
    stateVersion = "25.11";
  };

  programs = {
    direnv.nix-direnv.enable = true;

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };

    # Type `z <pat>` to cd to some directory
    zoxide.enable = true;

    # Better shell prompt!
    starship = {
      enable = true;
      settings = {
        username = {
          style_user = "blue bold";
          style_root = "red bold";
          format = "[$user]($style) ";
          disabled = false;
          show_always = true;
        };
        hostname = {
          ssh_only = false;
          ssh_symbol = "🌐 ";
          format = "on [$hostname](bold red) ";
          trim_at = ".local";
          disabled = false;
        };
      };
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = "Mike Shaver";
          email = "shaver@off.net";
        };
        alias = {
          ci = "commit";
        };
        init.defaultBranch = "main";
        push.autoSetupRemote = "true";
        branch.autoSetupRebase = "always";
        push.default = "current";
        pull.rebase = "true";
        url."git@github.com:fastly".insteadOf = "https://github.com/fastly";
        url."git@github.com:signalsciences".insteadOf = "https://github.com/signalsciences";
      };
      ignores = [
        "*~"
        "*.swp"
      ];
      includes = [
        {
          condition = "gitdir:~/src/**";
          contents = {
            user.email = "mike.shaver@fastly.com";
          };
        }
      ];
    };
    lazygit.enable = true;
    jujutsu.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;
      extraPackages = with pkgs; [
        go
        python3
        luarocks
        tree-sitter
        imagemagick
        tectonic
        ghostscript
        mermaid-cli
        statix
        cargo
        unzip
        gcc
      ];
    };
  };

  # use the "raw" nvim config from this repo
  xdg.configFile = {
    jj = {
      source = config.lib.file.mkOutOfStoreSymlink "${configRepo}/config/jj";
      recursive = true;
    };

    nvim = {
      source = config.lib.file.mkOutOfStoreSymlink "${configRepo}/config/nvim";
      recursive = true;
    };
  };

  home.packages = with pkgs; [
    # Unix tools
    ripgrep # Better `grep`
    fd
    sd
    tree
    gnumake

    clang

    # Nix dev
    cachix
    nil # Nix language server
    nix-info
    nixpkgs-fmt
    nixfmt-rfc-style
    nh

    jq
    curl
    coreutils
  ];

}
