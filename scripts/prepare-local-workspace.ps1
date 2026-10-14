$ErrorActionPreference = 'Stop'

# Keep editable content outside the public checkout, including tracked samples.
$templateRoot = Split-Path -Parent $PSScriptRoot
if (-not $env:LOCALAPPDATA) { throw 'LOCALAPPDATA is required.' }
$hash = [System.Security.Cryptography.SHA256]::Create()
try {
    $bytes = $hash.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($templateRoot.ToLowerInvariant()))
    $id = ([System.BitConverter]::ToString($bytes)).Replace('-', '').Substring(0, 16)
} finally { $hash.Dispose() }
$localRoot = Join-Path $env:LOCALAPPDATA "Mr. Mak Workspace\workspaces\$id"
$marker = Join-Path $localRoot '.local-workspace-ready'

if (Test-Path -LiteralPath $localRoot) {
    if (-not (Test-Path -LiteralPath $marker -PathType Leaf)) {
        throw "Local workspace initialization is incomplete: $localRoot. Preserve any personal files before renaming that folder and retrying."
    }
} else {
    New-Item -ItemType Directory -Path $localRoot -Force | Out-Null
    # Seed once. Future launches never replace local notes, settings or cards.
    foreach ($folder in @('workspace', 'projects', 'context', 'knowledge', 'processes', 'inbox', '.agents', '.claude', '.codex', 'scripts', 'docs')) {
        $source = Join-Path $templateRoot $folder
        if (Test-Path -LiteralPath $source -PathType Container) {
            Copy-Item -LiteralPath $source -Destination (Join-Path $localRoot $folder) -Recurse
        }
    }
    foreach ($file in @('AGENTS.md', 'CLAUDE.md', '.mcp.json', '.env.example', 'LICENSE', 'THIRD_PARTY_NOTICES.md')) {
        Copy-Item -LiteralPath (Join-Path $templateRoot $file) -Destination $localRoot
    }
    New-Item -ItemType Directory -Path (Join-Path $localRoot 'desktop') | Out-Null
    Copy-Item -LiteralPath (Join-Path $templateRoot 'desktop\coordinator.md') -Destination (Join-Path $localRoot 'desktop')
    # Defense in depth if someone later initializes Git in this private folder.
    Set-Content -LiteralPath (Join-Path $localRoot '.gitignore') -Value '*' -Encoding ASCII
    # Let agents search local content despite the defensive Git ignore rule.
    Set-Content -LiteralPath (Join-Path $localRoot '.ignore') -Value '!**' -Encoding ASCII
    Set-Content -LiteralPath $marker -Value 'Local workspace; never publish this folder.' -Encoding ASCII
}
if (-not (Test-Path -LiteralPath (Join-Path $localRoot 'workspace\workspace.json') -PathType Leaf)) {
    throw "Local workspace registry is missing: $localRoot"
}
# The launcher reads this path only after successful initialization.
Write-Output $localRoot
