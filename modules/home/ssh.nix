{ inputs, ... }:
{
  flake.modules.homeManager.ssh =
    { lib, ... }:
    {

      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;

        matchBlocks = {
          "*" = lib.hm.dag.entryBefore [ "github.com" ] {
            addKeysToAgent = "yes";
            identityFile = "~/.ssh/id_ed25519";
          };

          "github.com" = lib.hm.dag.entryAfter [ "*" ] {
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
