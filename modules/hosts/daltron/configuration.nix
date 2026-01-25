{
  flake.modules.darwin.daltron = { inputs, pkgs, ... }: {
    imports = [ inputs.determinate.darwinModules.default ]
      ++ (with inputs.self.modules.darwin; [ base-system shaver-personal ])
      ++ (with inputs.self.commonModules; [ sudo ]);
  };
}
