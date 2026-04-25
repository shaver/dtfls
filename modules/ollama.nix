{
  flake.modules.nixos.ollama = {
    services.ollama = {
      enable = true;
      loadModels = [
        "qwen3.5"
        "gemma4"
      ];
      syncModels = true;
    };
  };
}
