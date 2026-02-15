{ inputs, ... }: {
  flake.modules.darwin.work-laptop = { pkgs, ... }: {
    imports = with inputs.self.modules.darwin;
      [ base-system shaver-work ] ++ (with inputs.self.commonModules; [ sudo ]);
  };
}
