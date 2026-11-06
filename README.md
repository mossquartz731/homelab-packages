# homelab-packages

Patched builds of upstream packages that [alxleo/homelab](https://github.com/alxleo/homelab) consumes as a flake input. Homelab carries no patches of its own; each fix lives here until upstream has it.

| Package | Base | Fix | Retire when |
|---|---|---|---|
| `atlantis` | nixos-unstable | policy-check DB writes keep completed plan status | upstream Atlantis keeps plan status across policy checks |
| `gitea` | nixos-unstable | opt-in `RETRY_PACKAGE_DELIVERIES` keeps failed package-event webhooks queued | upstream Gitea retries package-event deliveries |

| Workflow | When | What |
|---|---|---|
| Update inputs | daily, or by hand | moves each input on its own, keeps it only if `nix flake check` builds and tests every package, then pushes `main`; a held-back input fails the run |
| Build | push, pull request | `nix flake check` |
