{ stdenvNoCC, fetchurl }:

# Gitea's official static binary, unbuilt: nixpkgs ships only the 3.x runner.
# Use nixpkgs' own once it carries the 5.x line. A Renovate PR moving the
# version fails on the stale hashes until they are refreshed from the
# release's checksums.txt.
let
  # renovate: datasource=gitea-releases depName=gitea/runner
  version = "5.4.1";
  arch = { x86_64-linux = "amd64"; aarch64-linux = "arm64"; }.${stdenvNoCC.hostPlatform.system};
  hash = {
    amd64 = "sha256:674145e627e5c879d72c293a08991458cf73c81124e54afdd40cf6995098a01b";
    arm64 = "sha256:035de0952d4f024f9efdd7f747ae2a3239b47552a50a2c901b2d74f1500e2c7c";
  }.${arch};
in
stdenvNoCC.mkDerivation {
  pname = "gitea-runner";
  inherit version;
  src = fetchurl {
    url = "https://gitea.com/gitea/runner/releases/download/v${version}/gitea-runner-${version}-linux-${arch}";
    inherit hash;
  };
  dontUnpack = true;
  installPhase = "install -Dm755 $src $out/bin/gitea-runner";
  meta.mainProgram = "gitea-runner";
}
