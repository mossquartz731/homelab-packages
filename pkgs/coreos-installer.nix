{
  lib,
  rustPlatform,
  fetchurl,
  pkg-config,
  openssl,
  xz,
  zstd,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "coreos-installer";
  # renovate: datasource=github-releases depName=coreos/coreos-installer
  version = "0.27.0";
  src = fetchurl {
    url = "https://github.com/coreos/coreos-installer/archive/refs/tags/v${version}.tar.gz";
    sha256 = "b1491d7f0af8e01c80e77e9d480301b9bd23bf4dd9752019a7b1182c299810be";
  };
  vendor = fetchurl {
    url = "https://github.com/coreos/coreos-installer/releases/download/v${version}/coreos-installer-${version}-vendor.tar.gz";
    sha256 = "ae09eb00b524c5e175b0f5ec80113eac81348deb468d7c42bffa5326a278df15";
  };
  postUnpack = ''
    tar -xzf "$vendor" -C "$sourceRoot"
  '';
  cargoVendorDir = "vendor";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    xz
    zstd
  ];
  enableParallelBuilding = false;
  doCheck = false;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  meta = {
    description = "Upstream CoreOS install-media customization tool";
    homepage = "https://github.com/coreos/coreos-installer";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "coreos-installer";
  };
}
