{ inputs, ... }: {
  perSystem = { pkgs, system, ... }: {
    devShells.default = pkgs.mkShell {
      name = "dtfls";

      packages = with pkgs; [
        # Nix development
        nil # Nix LSP
        nixfmt # Nix formatter
        nix-tree # Visualize nix derivations
        nix-diff # Compare derivations
        nvd # Nix version diff (compare system generations)

        # System management
        nh # Nix helper for rebuilds

        # General utilities
        jq # JSON processing
        git

        mermaid-cli
      ];

      shellHook = ''
        echo "dtfls development environment"
      '';
    };
  };
}
