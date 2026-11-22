{ atlantis, fetchFromGitHub, git }:

# The pinned nixpkgs must ship the version the patch was written for. A
# Renovate PR moving it means upstream released: check whether the fix landed.
# renovate: datasource=github-releases depName=runatlantis/atlantis
assert atlantis.version == "0.49.0";
atlantis.overrideAttrs (old: rec {
  version = "0.50.0";
  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    tag = "v${version}";
    hash = "sha256-/NhnJ4a4uB9JaYmAtAk2ckWNVCw/Ntgh55KGyR48+og=";
  };
  vendorHash = "sha256-Ym1IKn16yUxSdvEhXM4MVZgQsQA1k96OvzsFmeO7BFo=";
  # v0.50.0 still loses completed plan state across policy DB writes. The
  # run-review patch adds value-free summaries and a proxy-authenticated exact-plan action.
  patches = (old.patches or [ ]) ++ [ ./atlantis-policy-status.patch ./atlantis-run-review.patch ];
  nativeCheckInputs = (old.nativeCheckInputs or [ ]) ++ [ git ];
  checkFlags = [ "-short" ];
})
