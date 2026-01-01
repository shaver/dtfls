# nopasswd for shaver
{ ... }:
{
  flake.commonModules.sudo =
    { ... }:
    {

      security = {
        sudo.extraConfig = ''
          shaver ALL=(ALL) NOPASSWD: SETENV: ALL
        '';
      };
    };
}
