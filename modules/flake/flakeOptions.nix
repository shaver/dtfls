{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) attrs attrsOf deferredModule;
in
{
  options.flake = {
    commonModules = mkOption {
      type = attrsOf deferredModule;
      default = { };
      description = "Modules shared across multiple classes (e.g., darwin and nixos)";
    };

    dtflsLib = mkOption {
      type = attrs;
      default = { };
      description = "Library functions for this flake.";
    };
  };
}
