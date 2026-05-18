# Recreate AICoding/skills directory junctions on Windows (local dev).
# Git stores these as symlinks (mode 120000); run this if checkout created plain files.
$ErrorActionPreference = "Stop"

$Root = (Resolve-Path (Join-Path $PSScriptRoot "../..")).Path
$Skills = Join-Path $Root "AICoding/skills"

$Links = [ordered]@{
  "myvaex-discriminator-loss-compatibility" = "myvaex\AICoding\skills\discriminator-loss-compatibility"
  "myvaex-memory-and-skill-practice"        = "myvaex\AICoding\skills\memory-and-skill-practice"
  "myvaex-project-overview"                 = "myvaex\AICoding\skills\project-overview"
  "myvaex-repo-navigation"                  = "myvaex\AICoding\skills\repo-navigation"
  "myvaex-training-operations"              = "myvaex\AICoding\skills\training-operations"
  "myvaex-two-stage-training"               = "myvaex\AICoding\skills\two-stage-training"
  "var-architecture"                        = "var\AICoding\skills\architecture"
  "var-continuous-ar-head"                  = "var\AICoding\skills\continuous-ar-head"
  "var-lr-data-conventions"                 = "var\AICoding\skills\lr-data-conventions"
  "var-project-overview"                    = "var\AICoding\skills\project-overview"
  "var-repo-navigation"                     = "var\AICoding\skills\repo-navigation"
  "var-training-operations"                 = "var\AICoding\skills\training-operations"
}

New-Item -ItemType Directory -Force -Path $Skills | Out-Null
Set-Location $Skills

foreach ($name in $Links.Keys) {
  $target = Join-Path $Root $Links[$name]
  if (-not (Test-Path $target)) {
    Write-Warning "skip $name : target missing ($($Links[$name]))"
    continue
  }

  if (Test-Path $name) {
    $item = Get-Item $name -Force
    if ($item.LinkType) {
      Remove-Item $name -Force
    } else {
      Remove-Item $name -Recurse -Force
    }
  }

  cmd /c mklink /J "$name" "$target" | Out-Null
  Write-Host "junction $name -> $target"
}

Write-Host "Done. Verify with: Get-ChildItem $Skills | Format-Table Name, LinkType"
