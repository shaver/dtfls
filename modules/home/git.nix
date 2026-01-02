{ config, ... }:
{
  flake.modules.homeManager.git = {
    programs = {
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
    };
  };
}
