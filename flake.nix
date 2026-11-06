{
  description = "Homelab's patched builds of upstream packages";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      packages.x86_64-linux = {
        atlantis = pkgs.callPackage ./pkgs/atlantis { };
        gitea = pkgs.callPackage ./pkgs/gitea { };
      };
      # `nix flake check` builds every package, so CI and the updater share one list.
      checks.x86_64-linux = self.packages.x86_64-linux;
    };
}
