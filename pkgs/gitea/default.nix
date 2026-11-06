{ gitea }:

gitea.overrideAttrs (old: {
  # Opt-in [webhook] RETRY_PACKAGE_DELIVERIES keeps failed package-event
  # deliveries queued until acknowledged, so no published package is missed.
  patches = (old.patches or [ ]) ++ [ ./gitea-retry-package-events.patch ];
})
