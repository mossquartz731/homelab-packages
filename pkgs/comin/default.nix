# The pinned Comin must be the version these patches were written for. A
# Renovate PR moving it means upstream released: check whether each fix
# landed, then drop that patch and its checkFlags entry.
# renovate: datasource=github-releases depName=nlewo/comin
comin: assert comin.version == "0.14.0";
comin.overrideAttrs (oldAttrs: {
  patches = (oldAttrs.patches or []) ++ [
    # A commit fetched mid-build could be garbage-collected before
    # evaluation, leaving the host stuck on its previous generation.
    # Remove once upstream stops the running build before storing a new
    # generation.
    ./comin-generation-race.patch
    # Upstream reads access_token_path once at startup, but the OpenBao
    # Agent renews the GitHub App token hourly. Restarting Comin instead is
    # unsafe: switch-to-configuration runs inside comin.service, so a
    # restart can cut an activation short. Remove once upstream rereads the
    # token file for each fetch.
    ./comin-access-token-rotation.patch
    # Upstream makes the gRPC socket 0777, so any local user can suspend or
    # confirm deployments (nlewo/comin#191). Remove once upstream restricts
    # the socket or offers an option for its mode or group.
    ./comin-root-only-socket.patch
  ];
  vendorHash = "sha256-AvEwuroaTVmBi0kNgzhbLNkbJjhsPJh21xPLh5EmbTY=";
  doCheck = true;
  checkFlags = [ "-run=^(TestConfig|TestAccessToken(TracksAtomicReplacement|RejectsUnavailableFile|WithoutFile)|TestManagerStopsBuildBeforeCreatingFetchedGeneration|TestDeployer(ComparesLatestCompletedDeployment|RestoredDeploymentComparison|QueuedRevertWins|ComparisonDuringActivation))$" ];
})
