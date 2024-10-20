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
          networking.firewall.allowedTCPPorts = [ 80 22 ];
          nix.settings = {
            experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
          };
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
        {
          users.users.fmway = {
          # This lets NixOS know this is a "real" user rather than a system user,
          # giving you for example a home directory.
          isNormalUser = true;
          description = "fmway";
          extraGroups = [ "wheel" "systemd-journal" ];
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKI9FTK016k949uoOby8U4BDa92wocG50DWXZD40OxGI fm18lv@gmail.com"
          ];
        };
        }
      ];
    };
  };
}
