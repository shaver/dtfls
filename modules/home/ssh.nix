{
  flake.modules.homeManager.ssh =
    { lib, ... }:
    {

      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;

        matchBlocks = {
          "*" = {
            host = "*";
            addKeysToAgent = "yes";
            identityFile = "~/.ssh/id_ed25519";
          };

          "github.com" = {
            host = "github.com";
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
