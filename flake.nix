{
  description = "garnix minecraft server";
  inputs = {
          nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-24.05";
       garnix-lib.url = "github:garnix-io/garnix-lib";
      packwiz2nix.url = "github:getchoo/packwiz2nix";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };
  outputs = inputs: {
    nixosConfigurations.server = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        inputs.garnix-lib.nixosModules.garnix
        ( { pkgs, nix-minecraft, ... }: {

          # TODO: does persistence.name need to be unique per user?
          garnix.server = { enable = true; persistence = { enable = true; name = "minecraft"; }; };

          users.users.me = {
            isNormalUser = true;
            extraGroups = [ "wheel" "systemd-journal" ];
            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPCatP3klEjfQPSiJNUc3FRDdz927BG1IzektpouzOZR"
            ];
          };

          services = {
            minecraft-server = {
              enable = true;
              eula = true;
              openFirewall = true;
              enableReload = true;
              declarative = true;

              serverProperties = {
                gamemode = 1; # survival
                difficulty = 3; # hard
                motd = "minecraft server on garnix.io";

                # white-list = true;
              };

              # whitelist = {
              #   "username" = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
              # };

              package = pkgs.fabricServers.fabric-1_21_1;

              # see hotspot docs for more info:
              # https://docs.oracle.com/en/java/javase/11/gctuning/garbage-first-garbage-collector-tuning.html
              jvmOpts = builtins.concatStringsSep " " [
                "-Xms2G" "-Xmx3G"
                "-XX:+CMSIncrementalPacing" "-XX:+CMSClassUnloadingEnabled"
                "-XX:+ParallelRefProcEnabled" "-XX:+DisableExplicitGC"
              ];
            };

            # TODO: add some mods using moderinth fetcher fixed output derivations (or packwiz)
            # including carpet, any datapack/texturepack, and this prometheus exporter:
            # https://github.com/cpburnz/minecraft-prometheus-exporter

            # TODO: declaratively set up a grafana dashboard using:
            # https://grafana.com/grafana/dashboards/16508-minecraft-server-stats/
            # also try to add chat/map/online players

            openssh.enable = true;
          };

          environment = {
            enableAllTerminfo = true;
            systemPackages = [
              pkgs.htop
            ];
          };

          security.sudo.wheelNeedsPassword = false;

          nixpkgs = {
            hostPlatform = "x86_64-linux";
            config.allowUnfree = true;
            overlays = [ nix-minecraft.overlay ];
          };
          system.stateVersion = "24.05";
        })
      ];
    };
  };
}
