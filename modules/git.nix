{
  flake.modules.hjem.git =
    { config, pkgs, ... }:
    let
      configRepo = "${config.directory}/dtfls";
    in
    {
      # other modules contribute to `value` (e.g. credential helpers)
      xdg.config.files."git/config" = {
        generator = (pkgs.formats.gitIni { listsAsDuplicateKeys = true; }).generate "config";
        value = {
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
      };

      xdg.config.files."git/ignore".text = ''
        *~
        *.swp
      '';

      files.".zshrc".text = ''
        function lg() {
            export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir
            command lazygit "$@"
            if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
              cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
              rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
            fi
        }
      '';

      xdg.config.files.jj.source = "${configRepo}/config/jj";

      packages = with pkgs; [
        git
        lazygit
        jujutsu
        meld # for diff-munging
      ];
    };
}
