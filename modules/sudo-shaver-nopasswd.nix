{
  # nopasswd for shaver
  flake.modules.generic.sudo-shaver-nopasswd = {

    security = {
      sudo.extraConfig = ''
        shaver ALL=(ALL) NOPASSWD: SETENV: ALL
      '';
    };
  };
}
