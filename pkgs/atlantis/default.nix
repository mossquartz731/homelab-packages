{ atlantis, git }:

# The pinned nixpkgs must ship the version the patch was written for. A
# Renovate PR moving it means upstream released: check whether the fix landed.
# renovate: datasource=github-releases depName=runatlantis/atlantis
assert atlantis.version == "0.49.0";
atlantis.overrideAttrs (old: {
  # v0.49.0's policy DB writes lose completed plan state; share the API transition.
  patches = (old.patches or [ ]) ++ [ ./atlantis-policy-status.patch ];
  nativeCheckInputs = (old.nativeCheckInputs or [ ]) ++ [ git ];
  checkFlags = [ "-short" ];
})
