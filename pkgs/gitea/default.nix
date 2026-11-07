{ gitea }:

# The pinned nixpkgs must ship the version the patch was written for. A
# Renovate PR moving it means upstream released: check whether the fix landed.
# renovate: datasource=github-releases depName=go-gitea/gitea
assert gitea.version == "28.3.0";
gitea.overrideAttrs (old: {
  # Opt-in [webhook] RETRY_PACKAGE_DELIVERIES keeps failed package-event
  # deliveries queued until acknowledged, so no published package is missed.
  patches = (old.patches or [ ]) ++ [ ./gitea-retry-package-events.patch ];
})
