{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) attrs enum;
in
{
  options.flake = {
    dtfls = {
      opts = {
        role = {
          type = enum [
            "personal"
            "work"
          ];
          default = "personal";
          description = "Do I get paid to use this computer?";
        };
        form = {
          type = enum [
            "laptop"
            "desktop"
            "server"
          ];
          default = "desktop";
          description = "Can I carry this computer? Should I?";
        };
      };
      lib = mkOption {
        type = attrs;
        default = { };
        description = "Library functions for this flake.";
      };
    };
  };
}
