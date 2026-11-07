{ lib, stdenvNoCC, fetchurl }:

# The project's official static binary, unbuilt; nixpkgs lacks the plugin. A
# Renovate PR moving the version fails on the stale hashes until they are
# refreshed from the release's checksums.txt.
let
  pname = "openbao-plugin-secrets-github";
  # renovate: datasource=github-releases depName=rknightion/openbao-plugin-secrets-github
  version = "0.1.5";
  arch = { x86_64-linux = "amd64"; aarch64-linux = "arm64"; }.${stdenvNoCC.hostPlatform.system};
  hash = {
    amd64 = "sha256:69b43aba01437d49c6bd2b3f037314278c3de0aafffc829eba129e87766f030b";
    arm64 = "sha256:5e5fe8e7210ef809b38d1ad4fcb5cb62e9eb9502c870390c25a3d1fd3eee9fa6";
  }.${arch};
in
stdenvNoCC.mkDerivation {
  inherit pname version;
  src = fetchurl {
    url = "https://github.com/rknightion/${pname}/releases/download/v${version}/${pname}_linux_${arch}";
    inherit hash;
  };
  dontUnpack = true;
  installPhase = "install -Dm755 $src $out/bin/${pname}";
  passthru = {
    pluginType = "secret";
    pluginName = "github";
  };
  meta = {
    description = "OpenBao GitHub App installation-token engine";
    homepage = "https://github.com/rknightion/openbao-plugin-secrets-github";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = pname;
  };
}
