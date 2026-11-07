# homelab-packages

Patched builds of upstream packages that [alxleo/homelab](https://github.com/alxleo/homelab) consumes as a flake input. Homelab carries no patches of its own; each fix lives here until upstream has it.

| Package | Base | Fix | Retire when |
|---|---|---|---|
| `atlantis` | nixos-unstable | policy-check DB writes keep completed plan status | upstream Atlantis keeps plan status across policy checks |
| `gitea` | nixos-unstable | opt-in `RETRY_PACKAGE_DELIVERIES` keeps failed package-event webhooks queued | upstream Gitea retries package-event deliveries |

Everything stays pinned: nothing here updates on its own. Each recipe asserts the upstream version its patch was written for, and Renovate opens a PR when upstream releases a newer one. That PR fails its build until someone moves the nixpkgs pin and either drops the patch (fixed upstream) or rebases it.

| Workflow | When | What |
|---|---|---|
| Build | push, pull request | `nix flake check` builds and tests every package |
