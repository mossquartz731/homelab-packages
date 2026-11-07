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
      cominFor = system: import ./pkgs/comin comin.packages.${system}.default;
      systemManagerFor = system:
        (import nixpkgs-stable { inherit system; overlays = [ self.overlays.system-manager ]; }).callPackage
          "${system-manager}/package.nix" { };
    in
    {
      # System Manager's library builds its own package, so homelab patches it through this overlay.
      overlays.system-manager = import ./pkgs/system-manager;

      packages.x86_64-linux = {
        atlantis = pkgs.callPackage ./pkgs/atlantis { };
        gitea = pkgs.callPackage ./pkgs/gitea { };
        comin = cominFor "x86_64-linux";
        system-manager = systemManagerFor "x86_64-linux";
      };
      packages.aarch64-linux.comin = cominFor "aarch64-linux";

      checks = self.packages;
    };
}
