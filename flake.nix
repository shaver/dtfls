{
  description = "dtfls comprehensive and brilliant flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    proton-cachyos = {
      url = "github:powerofthe69/proton-cachyos-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      # inputs.nixpkgs.follows = "nixpkgs"; # omit for binary cache
    };

    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xivlauncher-rb = {
      url = "github:shaver/nixos-xivlauncher-rb";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim plugins not in nixpkgs
    jjsigns-nvim = {
      url = "github:shaver/jjsigns.nvim";
      flake = false;
    };
    jiaoshijie-undotree = {
      url = "github:jiaoshijie/undotree";
      flake = false;
    };
    tmux-status-nvim = {
      url = "github:christopher-francisco/tmux-status.nvim";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      ...
    }@inputs:
    let
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

      # build formatters for each system
      flake.formatter = builtins.listToAttrs (
        map (system: {
          name = system;
          value = inputs.nixpkgs.legacyPackages.${system}.nixfmt;
        }) systems
      );
    };
}
