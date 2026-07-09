{
  flake.modules.homeManager.git =
    { config, pkgs, ... }:
    let
      configRepo = "${config.home.homeDirectory}/dtfls";
    in
    {
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

      xdg.configFile.jj = {
        source = config.lib.file.mkOutOfStoreSymlink "${configRepo}/config/jj";
        recursive = true;
      };

      home.packages = [ pkgs.meld ]; # for diff-munging
    };
}
