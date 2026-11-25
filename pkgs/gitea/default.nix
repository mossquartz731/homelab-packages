{ gitea, gitMinimal }:

# The pinned nixpkgs must ship the version the patch was written for. A
# Renovate PR moving it means upstream released: check whether the fix landed.
# renovate: datasource=github-releases depName=go-gitea/gitea
assert gitea.version == "28.3.0";
gitea.overrideAttrs (old: {
  # Opt-in [webhook] RETRY_PACKAGE_DELIVERIES keeps failed package events
  # in Forge's database until acknowledged, with paced retries.
  patches = (old.patches or [ ]) ++ [ ./gitea-retry-package-events.patch ];
  postCheck = (old.postCheck or "") + ''
    PATH="${gitMinimal}/bin:$PATH" go test -tags "${builtins.concatStringsSep "," (old.tags or [ ])}" ./services/webhook \
      -run '^TestPackageWebhookRetriesArePacedAndRetained$' -count=1
  '';
})
