{
  flake.modules.homeManager.ssh =
    { lib, ... }:
    {

      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;

        settings = {
          "github.com" = {
            IdentityFile = "~/.ssh/id_github";
          };

          "*" = {
            AddKeysToAgent = "yes";
            IdentityFile = "~/.ssh/id_ed25519";
          };
        };
      };

      services.ssh-agent.enable = true;
    };
}
