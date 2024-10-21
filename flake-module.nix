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
        ({ config, ... }: {
          services.caddy.enable = true;
          services.caddy.virtualHosts.":80" = {
            extraConfig = ''
              log {
                format console
                output stdout
              }
              reverse_proxy localhost:${toString config.services.gitea.settings.server.HTTP_PORT}
            '';
          };
          services.gitea = {
            enable = true;
            appName = "Garnix x Gitea";
            lfs.enable = true;
            settings.server.ROOT_URL = "https://server.main.test-garnix.fmway.garnix.me/";
          };
        })
        {
          users.users.fmway = {
          # This lets NixOS know this is a "real" user rather than a system user,
          # giving you for example a home directory.
          isNormalUser = true;
          description = "fmway";
          extraGroups = [ "wheel" "systemd-journal" ];
          openssh.authorizedKeys.keys = [
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDddMpFZp3RjlW73Dwpi8FGtY/SGCqb7Fj7dTbIno7FRRDkGJsUEwywbBZxhDhTFqP9h0z59OAxmM5PsfHiCq3jqdFSIp2hyLe+j16uMwRViiPSQ3zWuuTDZ84KEIwp4yn90SOGe6+Gnb7fR3h89l3MMyd51ajd6z73kc6Z+IFG1cTYXKhZ0UmIXkHQihoZyiE33ymBw1zwajM296AYWxzvaAF6J/uHOFFXIzqtG5NOamqnb13BWaF/iBoI3MwHrQ/m5Tn7DtqGrMXnamH5CWAV6W5QgWXe9O+4YurA/5rqXcEdi5vhRrS9snJo/d2emsYP2FUr21RvXGS/ZsiJlhnqVsHNlmfKwBmhFaItaPDGWD965BMi096uRNreics5OqgVZrNMxxgPMsDQEhNAJ0NO61sEluSsXo/XA/C4jxPYjWuPJaOWAmPVMaF+0z2fh9Osi0Db3TOr2wYxeYMNa/uTETWZIcyKnEujYrsodzCCuFe8bhRBM2B111sp39NvuVBRuQR9nzJC361LwxCgp2U7LlpB4FLYzpcceE0JTf5PRnQt4tX3gASxooWQ0ELweYzTQ23fWGAQf2HV1U9Y2QfhTZJm8Bee1ZXN2P+PpJKFCvYeVGGcQ8qTz+wTZd7dW7s1TdtmeaEhrP4o5V4lEjAJf3ZxmhgVODqw+hObiy/EDQ== fm18lv@gmail.com"
          ];
        };
        }
      ];
    };
  };
}
