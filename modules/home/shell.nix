{
  flake.modules.homeManager.shell = { pkgs, ... }: {

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        plugins = [{
          name = "vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }];
      };

      fzf = {
        enable = true;
        enableZshIntegration = true;
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
            show_always = false;
          };
          hostname = {
            ssh_only = true;
            ssh_symbol = "🌐 ";
            format = "on [$hostname](bold red) ";
            trim_at = ".local";
            disabled = false;
          };
        };
      };
    };

    home.sessionVariables = { ZVM_SYSTEM_CLIPBOARD_ENABLED = "true"; };

    home.packages = [ pkgs.wl-clipboard ];
  };
}
