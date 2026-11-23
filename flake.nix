{
  description = "Homelab's patched builds of upstream packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Comin and System Manager build against homelab's stable release.
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
    comin = {
      url = "github:nlewo/comin/1399adecc682e557bc3ee914d929f8e20391a148";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    system-manager = {
      url = "github:numtide/system-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, comin, system-manager }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      netdataPkgs = import nixpkgs-stable {
        system = "x86_64-linux";
        config.allowUnfreePredicate = package: nixpkgs-stable.lib.getName package == "netdata";
      };
      cominFor = system: import ./pkgs/comin comin.packages.${system}.default;
      # Official release binaries, downloaded rather than built.
      giteaRunnerFor = system: nixpkgs-stable.legacyPackages.${system}.callPackage ./pkgs/gitea-runner { };
      openbaoPluginFor = system:
        nixpkgs-stable.legacyPackages.${system}.callPackage ./pkgs/openbao-plugin-secrets-github { };
      systemManagerFor = system:
        (import nixpkgs-stable { inherit system; overlays = [ self.overlays.system-manager ]; }).callPackage
          "${system-manager}/package.nix" { };
    in
    {
      # System Manager's library builds its own package, so homelab patches it through this overlay.
      overlays.system-manager = import ./pkgs/system-manager;

      packages.x86_64-linux = {
        atlantis = pkgs.callPackage ./pkgs/atlantis { };
        coreos-installer = nixpkgs-stable.legacyPackages.x86_64-linux.callPackage ./pkgs/coreos-installer.nix { };
        gitea = pkgs.callPackage ./pkgs/gitea { };
        comin = cominFor "x86_64-linux";
        system-manager = systemManagerFor "x86_64-linux";
        gitea-runner = giteaRunnerFor "x86_64-linux";
        openbao-plugin-secrets-github = openbaoPluginFor "x86_64-linux";
        netdata = netdataPkgs.netdataCloud;
      };
      packages.aarch64-linux = {
        comin = cominFor "aarch64-linux";
        gitea-runner = giteaRunnerFor "aarch64-linux";
        openbao-plugin-secrets-github = openbaoPluginFor "aarch64-linux";
      };

      # gitea.com refuses GitHub-hosted runners, so the Gitea runner's download
      # is only evaluated here; homelab's machines fetch it.
      checks = builtins.mapAttrs (
        system: packages:
        removeAttrs packages [ "gitea-runner" ]
        // nixpkgs-stable.lib.optionalAttrs (system == "x86_64-linux") {
          netdata-license = netdataPkgs.runCommand "netdata-dashboard-license" { } ''
            dashboard=${packages.netdata}/share/netdata/web/v3
            grep -Fq 'Netdata Cloud UI License v1.0 (NCUL1)' "$dashboard/LICENSE.md"
            test -s "$dashboard/3D_PARTY_LICENSES.txt"
            touch "$out"
          '';
        }
      ) self.packages;
    };
}
