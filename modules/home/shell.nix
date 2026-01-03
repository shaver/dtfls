{ inputs, ... }:
{
  flake.modules.homeManager.shell = {

    programs = {
      direnv.nix-direnv.enable = true;

      zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
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
    };
  };
}
