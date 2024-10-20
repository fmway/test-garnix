{ self, lib, inputs, ... }:
{
  flake = {
    nixosConfigurations.server = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.garnix-lib.nixosModules.garnix
        {
          _module.args.inputs.self = self;
        }
        {
          garnix.server.enable = true;
          nixpkgs.hostPlatform = "x86_64-linux";
          # services.nginx = {
          #   enable = true;
          #   recommendedProxySettings = true;
          #   recommendedOptimisation = true;
          #   recommendedGzipSettings = true;
          #   virtualHosts = {
          #     "default" = {
          #       locations."/".root = ./public;
          #     };
          #   };
          # };
          security.sudo.wheelNeedsPassword = false;
          services.openssh.enable = true;
          networking.firewall.allowedTCPPorts = [ 80 ];
        }
        {
          services.caddy.enable = true;
          services.caddy.virtualHosts.":80" = {
            extraConfig = ''
              root * ${./public}
              file_server
            '';
          };
        }
      ];
    };
  };
}
