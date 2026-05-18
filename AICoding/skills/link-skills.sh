#!/usr/bin/env bash
# Recreate AICoding/skills symlinks after clone (Linux / macOS / Git Bash).
# Source of truth: myvaex/AICoding/skills/* and var/AICoding/skills/*
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SKILLS="$ROOT/AICoding/skills"

links=(
  myvaex-discriminator-loss-compatibility:myvaex/AICoding/skills/discriminator-loss-compatibility
  myvaex-memory-and-skill-practice:myvaex/AICoding/skills/memory-and-skill-practice
  myvaex-project-overview:myvaex/AICoding/skills/project-overview
  myvaex-repo-navigation:myvaex/AICoding/skills/repo-navigation
  myvaex-training-operations:myvaex/AICoding/skills/training-operations
  myvaex-two-stage-training:myvaex/AICoding/skills/two-stage-training
  var-architecture:var/AICoding/skills/architecture
  var-continuous-ar-head:var/AICoding/skills/continuous-ar-head
  var-lr-data-conventions:var/AICoding/skills/lr-data-conventions
  var-project-overview:var/AICoding/skills/project-overview
  var-repo-navigation:var/AICoding/skills/repo-navigation
  var-training-operations:var/AICoding/skills/training-operations
)

mkdir -p "$SKILLS"
cd "$SKILLS"

for entry in "${links[@]}"; do
  name="${entry%%:*}"
  target_rel="${entry#*:}"
  target_abs="$ROOT/$target_rel"

  if [[ ! -d "$target_abs" ]]; then
    echo "skip $name: target missing ($target_rel) — init submodules first" >&2
    continue
  fi

  rel_target="$(python3 -c "import os; print(os.path.relpath('$target_abs', '$SKILLS'))" 2>/dev/null || true)"
  if [[ -z "$rel_target" ]]; then
    rel_target="$(realpath --relative-to="$SKILLS" "$target_abs")"
  fi

  rm -rf "$name"
  ln -s "$rel_target" "$name"
  echo "linked $name -> $rel_target"
done

echo "Done. Verify with: ls -al $SKILLS"
