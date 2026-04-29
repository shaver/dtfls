{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {

      programs = {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
          silent = true;
        };

        zsh = {
          enable = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          defaultKeymap = "emacs";
          enableCompletion = true;
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
          enableZshIntegration = true;
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
            git_branch.disabled = true;
            git_commit.disabled = true;
            nix_shell = {
              symbol = "❄️";
              format = "[\\($symbol$name\\)]($style) ";
            };
          };
        };
      };
    };
}
