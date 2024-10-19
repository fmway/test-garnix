{ self, lib, inputs, ... }:
{
  perSystem = { config, self', inputs', pkgs, system, ... }: {
    nixosConfiguration.server = pkgs.lib.nixosSystem {
      modules = [
        inputs.garnix-lib.nixosModules.garnix
        {
          _module.args = { inherit self inputs; };
        }
      ];
    };
  };
}
