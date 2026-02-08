{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) attrs;
in {
  options.flake = {
    dtflsLib = mkOption {
      type = attrs;
      default = { };
      description = "Library functions for this flake.";
    };
  };
}
