# Register AICoding/skills entries as Git symlinks (mode 120000) using relative targets.
# Run from repo root after removing old copied directories from the index.
$ErrorActionPreference = "Stop"

Set-Location (Resolve-Path (Join-Path $PSScriptRoot "../..")).Path

$Links = [ordered]@{
  "AICoding/skills/myvaex-discriminator-loss-compatibility" = "../../myvaex/AICoding/skills/discriminator-loss-compatibility"
  "AICoding/skills/myvaex-memory-and-skill-practice"        = "../../myvaex/AICoding/skills/memory-and-skill-practice"
  "AICoding/skills/myvaex-project-overview"                 = "../../myvaex/AICoding/skills/project-overview"
  "AICoding/skills/myvaex-repo-navigation"                  = "../../myvaex/AICoding/skills/repo-navigation"
  "AICoding/skills/myvaex-training-operations"              = "../../myvaex/AICoding/skills/training-operations"
  "AICoding/skills/myvaex-two-stage-training"               = "../../myvaex/AICoding/skills/two-stage-training"
  "AICoding/skills/var-architecture"                        = "../../var/AICoding/skills/architecture"
  "AICoding/skills/var-continuous-ar-head"                  = "../../var/AICoding/skills/continuous-ar-head"
  "AICoding/skills/var-lr-data-conventions"                 = "../../var/AICoding/skills/lr-data-conventions"
  "AICoding/skills/var-project-overview"                    = "../../var/AICoding/skills/project-overview"
  "AICoding/skills/var-repo-navigation"                     = "../../var/AICoding/skills/repo-navigation"
  "AICoding/skills/var-training-operations"                 = "../../var/AICoding/skills/training-operations"
}

foreach ($path in $Links.Keys) {
  $target = $Links[$path]
  if (Test-Path $path) {
    git rm -r -f -- "$path" 2>$null
    if (Test-Path $path) { Remove-Item -Recurse -Force $path }
  }

  $hash = (echo $target | git hash-object -w --stdin).Trim()
  git update-index --add --cacheinfo "120000,$hash,$path"
  Write-Host "index symlink $path -> $target"
}

Write-Host ""
Write-Host "Verify: git ls-files -s AICoding/skills/"
Write-Host "Linux checkout should show lrwxrwxrwx after commit + pull."
