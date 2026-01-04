{ inputs, ... }:
{
  flake.modules.homeManager.ssh =
    { lib, ... }:
    {

      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;

        matchBlocks = {
          # these are sorted lexicographically by key when emtted into
          # .ssh/config. lib.hm.dag.* did not work to override that
          "all" = {
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
