{ pkgs }:

# Use nixpkgs' own runner once it carries the 5.x line. A Renovate PR moving
# the version fails on the stale hashes until they are refreshed.
(pkgs.gitea-actions-runner.override {
  buildGoModule = pkgs.buildGo127Module;
}).overrideAttrs (finalAttrs: _oldAttrs: {
  # renovate: datasource=gitea-releases depName=gitea/runner
  version = "5.2.4";
  # Named after the version so a bump with a stale hash cannot reuse the old source.
  src = pkgs.fetchFromGitea {
    name = "gitea-runner-${finalAttrs.version}-source";
    domain = "gitea.com";
    owner = "gitea";
    repo = "runner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hwhkgVPT1deu6o0/20O0nAUHij7PTzRea0f2UYez2Kg=";
  };
  vendorHash = "sha256-MobDUw9qnjLVm/uX0BJil+DdgnC30ek3pfvVOmNC09I=";
})
