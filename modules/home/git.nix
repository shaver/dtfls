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
        };
        ignores = [
          "*~"
          "*.swp"
        ];
      };
      lazygit.enable = true;
      jujutsu.enable = true;
    };
  };

  flake.modules.homeManager.git-fastly = {
    programs.git = {
      settings = {
        url."git@github.com:fastly".insteadOf = "https://github.com/fastly";
        url."git@github.com:signalsciences".insteadOf = "https://github.com/signalsciences";

      };
      includes = [
        {
          condition = "gitdir:~/src/**";
          contents = {
            user.email = "mike.shaver@fastly.com";
          };
        }
      ];

    };
  };
}
