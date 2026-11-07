{ pkgs }:

# Not in nixpkgs. A Renovate PR moving the version needs the matching rev and
# hashes too.
pkgs.buildGo127Module rec {
  pname = "openbao-plugin-secrets-github";
  # renovate: datasource=github-releases depName=rknightion/openbao-plugin-secrets-github
  version = "0.1.3";
  src = pkgs.fetchFromGitHub {
    owner = "rknightion";
    repo = pname;
    rev = "aaceee6ee546c177f448035ce95528d33fe08d4c";
    hash = "sha256-JkyNjfQ9f/ofn3zT5040cL23lFUrRAMKN90RRmq0BL4=";
  };
  vendorHash = "sha256-SKqLvVEbEXG98JkDPaq5uyJCTe13+O/Eb7YFSPI8RwA=";
  subPackages = [ "." ];
  env.CGO_ENABLED = 0;
  passthru = {
    pluginType = "secret";
    pluginName = "github";
  };
  ldflags = [
    "-s"
    "-w"
    "-X github.com/rknightion/openbao-plugin-secrets-github/github.projectVersion=v${version}"
    "-X github.com/rknightion/openbao-plugin-secrets-github/github.projectName=${pname}"
    "-X github.com/prometheus/common/version.Version=v${version}"
    "-X github.com/prometheus/common/version.Revision=aaceee6ee546c177f448035ce95528d33fe08d4c"
  ];
  meta = {
    description = "OpenBao GitHub App installation-token engine";
    homepage = "https://github.com/rknightion/openbao-plugin-secrets-github";
    license = pkgs.lib.licenses.asl20;
    platforms = pkgs.lib.platforms.linux;
    mainProgram = pname;
  };
}
