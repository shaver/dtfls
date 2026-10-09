{
  flake.modules.hjem.shell =
    { lib, pkgs, ... }:
    {
      packages = [ pkgs.jj-starship ];

      rum.programs = {
        # compinit and NIX_PROFILES fpath handling come from the system zshrc
        zsh = {
          enable = true;
          initConfig = lib.mkMerge [
            (lib.mkBefore ''
              # Use emacs keymap as the default.
              bindkey -e

              source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
              ZSH_AUTOSUGGEST_STRATEGY=(history)

              HISTSIZE="10000"
              SAVEHIST="10000"
              HISTFILE="$HOME/.zsh_history"
              setopt HIST_FCNTL_LOCK HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY
              setopt NO_APPEND_HISTORY NO_EXTENDED_HISTORY NO_HIST_EXPIRE_DUPS_FIRST
              setopt NO_HIST_FIND_NO_DUPS NO_HIST_IGNORE_ALL_DUPS NO_HIST_SAVE_NO_DUPS
            '')
            # must come after everything else that touches zle, including the
            # rum integrations, which are themselves mkAfter
            (lib.mkOrder 2000 ''
              source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
              ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
            '')
          ];
        };

        direnv = {
          enable = true;
          integrations.nix-direnv.enable = true;
          integrations.zsh.enable = true;
          # https://github.com/NixOS/nixpkgs/issues/513019 -- direnv/zsh badness
          package = pkgs.direnv.overrideAttrs { doCheck = false; };
          # silent
          settings.global = {
            log_format = "-";
            log_filter = "^$";
          };
        };

        fzf = {
          enable = true;
          integrations.zsh.enable = true;
        };

        # Type `z <pat>` to cd to some directory
        zoxide = {
          enable = true;
          integrations.zsh.enable = true;
        };

        # Better shell prompt!
        starship = {
          enable = true;
          integrations.zsh.enable = true;
          settings = {
            custom.jj = {
              when = "jj-starship detect";
              shell = [ "jj-starship" ];
              format = "$output ";
            };
            format = "$all$jj$line_break$shell$character";
            right_format = "$time$nix_shell";
            username = {
              style_user = "blue bold";
              style_root = "red bold";
              format = "[$user]($style) ";
              disabled = false;
              show_always = false;
            };
            hostname = {
              ssh_only = true;
              ssh_symbol = "🌐 ";
              format = "on [$hostname](bold red) ";
              trim_at = ".local";
              disabled = false;
            };
            git_branch.disabled = true;
            git_commit.disabled = true;
            git_status.disabled = true;
            nix_shell = {
              symbol = "❄️";
              format = "[\\($symbol$name\\)]($style) ";
            };
          };
        };
      };
    };
}
