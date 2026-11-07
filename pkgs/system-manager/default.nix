# The pinned System Manager must be the version the patch was written for. A
# Renovate PR moving it means upstream released: check whether the fix landed.
_final: prev: {
  rustPlatform = prev.rustPlatform // {
    buildRustPackage = args:
      let package = prev.rustPlatform.buildRustPackage args;
      in if (package.pname or null) == "system-manager"
      # renovate: datasource=github-releases depName=numtide/system-manager
      then assert package.version == "1.1.0"; package.overrideAttrs (old: {
        # A failed service or Userborn restart fails activation instead of reporting success.
        patches = (old.patches or [ ]) ++ [ ./system-manager-activation-errors.patch ];
      })
      else package;
  };
}
