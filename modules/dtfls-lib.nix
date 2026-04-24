{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) enum;
in
{
  flake.modules.generic.dtfls = {
    options.flake.dtfls.opts = {
      role = mkOption {
        type = enum [
          "personal"
          "work"
        ];
        default = "personal";
        description = "Do I get paid to use this computer?";
      };
      form = mkOption {
        type = enum [
          "desktop"
          "server"
        ];
        default = "desktop";
        description = "Can I carry this computer? Should I?";
      };
    };
  };
}
