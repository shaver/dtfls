{
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    let
      # Pi extensions are npm packages; pi loads local packages (with their
      # node_modules) from a resolved path without copying. Build the published
      # npm tarball plus a prod-only dependency tree so the store path can be
      # installed with: pi install <flake package output>
      buildPiExtension =
        {
          name,
          version,
          tarballHash,
          npmDepsHash,
          description,
          homepage,
        }:
        pkgs.buildNpmPackage {
          pname = name;
          inherit version;

          src = pkgs.fetchurl {
            url = "https://registry.npmjs.org/${name}/-/${name}-${version}.tgz";
            hash = tarballHash;
          };
          # npm tarballs unpack into ./package
          sourceRoot = "package";

          postPatch = ''
            cp ${./pi-agent-extensions/${name}-package.json} package.json
            cp ${./pi-agent-extensions/${name}-lock.json} package-lock.json
          '';
          npmFlags = [ "--legacy-peer-deps" ];
          npmPackFlags = [ "--ignore-scripts" ];
          # published tarballs ship prebuilt ./dist and raw .ts entry points
          dontNpmBuild = true;

          inherit npmDepsHash;

          meta = {
            inherit description homepage;
            license = lib.licenses.mit;
            platforms = lib.platforms.unix ++ lib.platforms.windows;
          };
        };

      pi-mcp-adapter = buildPiExtension {
        name = "pi-mcp-adapter";
        version = "7.0.0";
        tarballHash = "sha256-HNHqtFfAMDpFdOBHMcVmFi7yHZhhTRNBdR4K0nZI7XM=";
        npmDepsHash = "sha256-IgHgUep9zdlMIrKbjmZBxAL0mnRMdBuefVQV5HuJzwo=";
        description = "MCP (Model Context Protocol) adapter extension for Pi coding agent";
        homepage = "https://github.com/nicobailon/pi-mcp-adapter";
      };

      pi-claude-bridge = buildPiExtension {
        name = "pi-claude-bridge";
        version = "0.9.3";
        tarballHash = "sha256-jVgrL+4WFbZKWYkOOsCvA8HhG9BroZl6zNt2eWlVbWc=";
        npmDepsHash = "sha256-PM9gUoHm2Je3uE6BON0q8YY4G0ckB7pNgknwHQLJn/U=";
        description = "Pi extension that uses Claude Code (via Agent SDK) as a model provider and adds an AskClaude tool";
        homepage = "https://github.com/elidickinson/pi-claude-bridge";
      };
    in
    {
      packages = {
        inherit pi-mcp-adapter pi-claude-bridge;
      };
    };
}
