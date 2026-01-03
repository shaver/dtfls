{ inputs, ... }:
{
  flake.modules.homeManager.ssh = {

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
          identityFile = "~/.ssh/id_ed25519";
        };

        "github.com" = {
          identityFile = "~/.ssh/id_github";
        };
      };
    };

    services.ssh-agent = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
