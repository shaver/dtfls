{
  # nopasswd for shaver
  flake.modules.generic.sudo = {

    security = {
      sudo.extraConfig = ''
        shaver ALL=(ALL) NOPASSWD: SETENV: ALL
      '';
    };
  };
}
