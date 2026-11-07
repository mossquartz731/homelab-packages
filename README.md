# homelab-packages

Patched builds of upstream packages that [alxleo/homelab](https://github.com/alxleo/homelab) consumes as a flake input. Homelab carries no patches of its own; each fix lives here until upstream has it.

| Package | Base | Fix | Retire when |
|---|---|---|---|
| `atlantis` | nixos-unstable | policy-check DB writes keep completed plan status | upstream Atlantis keeps plan status across policy checks |
| `gitea` | nixos-unstable | opt-in `RETRY_PACKAGE_DELIVERIES` keeps failed package-event webhooks queued | upstream Gitea retries package-event deliveries |
| `comin` | nixos-26.05, x86_64 and aarch64 | no garbage-collected mid-build generations; rereads the rotating access token; root-only gRPC socket | upstream covers each fix (drop patches one by one) |
| `system-manager` (overlay) | nixos-26.05 | failed service or Userborn restarts fail activation | upstream activation reports those failures |
| `gitea-runner` | nixos-26.05 | the 5.x runner, which nixpkgs does not ship yet | nixpkgs carries the 5.x line |
| `openbao-plugin-secrets-github` | homelab's OpenBao nixpkgs pin | builds the OpenBao GitHub App token plugin, which nixpkgs lacks | nixpkgs packages the plugin |

Everything stays pinned: nothing here updates on its own. Each recipe asserts the upstream version its patch was written for, and Renovate opens a PR when upstream releases a newer one. That PR fails its build until someone moves the nixpkgs pin and either drops the patch (fixed upstream) or rebases it.

| Workflow | When | What |
|---|---|---|
| Build | push, pull request | `nix flake check` on x86_64 and aarch64 builds and tests every package |
