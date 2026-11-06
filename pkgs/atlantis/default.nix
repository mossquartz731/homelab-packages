{ atlantis, git }:

atlantis.overrideAttrs (old: {
  # v0.49.0's policy DB writes lose completed plan state; share the API transition.
  patches = (old.patches or [ ]) ++ [ ./atlantis-policy-status.patch ];
  nativeCheckInputs = (old.nativeCheckInputs or [ ]) ++ [ git ];
  checkFlags = [ "-short" ];
})
