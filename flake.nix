{
  description = "dtfls comprehensive and brilliant flake";

  # inputs are pinned by tack: see .tack/pins.toml, update with `tack update`
  outputs =
    { self, ... }@args:
    let
      inputs = (import ./.tack) { overrides = args.tackOverrides or { }; } // {
        inherit self;
      };
      inherit (inputs) nixpkgs flake-parts;

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
        "aarch64-linux"
      ];
      inherit (nixpkgs.lib.fileset) toList fileFilter;
      inherit (nixpkgs.lib) lists hasPrefix;
      importsFromDirectoryTree =
        path: toList (fileFilter (file: file.hasExt "nix" && !(hasPrefix "_" file.name)) path);
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      inherit systems;

      imports = lists.flatten [
        flake-parts.flakeModules.modules
        (importsFromDirectoryTree ./modules)
        (importsFromDirectoryTree ./packages)
      ];

      # flake-parts looks for nixpkgs in self.inputs, which tack leaves empty
      perSystem =
        { system, ... }:
        {
          _module.args.pkgs = nixpkgs.legacyPackages.${system};
        };

      # build formatters for each system
      flake.formatter = builtins.listToAttrs (
        map (system: {
          name = system;
          value = inputs.nixpkgs.legacyPackages.${system}.nixfmt;
        }) systems
      );
    };
}
