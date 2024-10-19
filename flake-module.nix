{ self, lib, inputs, ... }:
{
  flake = {
    nixosConfigurations.server = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.garnix-lib.nixosModules.garnix
      ];
    };
  };
}
