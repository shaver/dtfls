{
  flake.modules.darwin.work-laptop = { inputs, pkgs, ... }: {
    imports = [ inputs.determinate.darwinModules.default ]
      ++ (with inputs.self.modules.darwin; [ base-system shaver-work ])
      ++ (with inputs.self.commonModules; [ sudo ]);
  };
}
