function Test-PathInScope {
    param([string]$Path)
    
    if ($null -eq $script:Config.ParentScope -or [string]::IsNullOrWhiteSpace($script:Config.ParentScope)) {
        Write-Error-Custom "No parent scope set. Please configure the scope first."
        return $false
    }
    
    $scopePath = (Resolve-Path $script:Config.ParentScope).Path
    $targetPath = (Resolve-Path $Path).Path
    
    if (-not $targetPath.StartsWith($scopePath)) {
        Write-Error-Custom "Target path is outside the configured parent scope!"
        Write-Error-Custom "Allowed scope: $scopePath"
        return $false
    }
    
    return $true
}

function Set-ParentScope {
    Write-Host ""
    Write-Info "Tip: Enter '.' to use current directory as parent scope"
    Write-Info "Note: Maximum 9 nested folder levels allowed for safety"
    Write-Host ""
    Write-Host "  Enter parent scope folder path: " -ForegroundColor Cyan -NoNewline
    $path = Read-Host
    
    if ([string]::IsNullOrWhiteSpace($path)) {
        Write-Host ""
        Write-Error-Custom "Path cannot be empty."
        Start-Sleep -Seconds 1
        return
    }
    
    # Handle '.' as current directory
    if ($path -eq '.') {
        $path = Get-Location | Select-Object -ExpandProperty Path
    }
    
    if (-not (Test-Path $path -PathType Container)) {
        Write-Host ""
        Write-Error-Custom "Path does not exist or is not a folder: $path"
        Start-Sleep -Seconds 1
        return
    }
    
    $resolvedPath = (Resolve-Path $path).Path
    
    # Check nested folder depth (max 9 levels)
    $maxDepth = 0
    $folders = Get-ChildItem -Path $resolvedPath -Directory -Recurse -ErrorAction SilentlyContinue
    foreach ($folder in $folders) {
        $relativePath = $folder.FullName.Replace($resolvedPath, "").TrimStart('\')
        $depth = ($relativePath.Split('\') | Where-Object { $_ }).Count
        if ($depth -gt $maxDepth) {
            $maxDepth = $depth
        }
    }
    
    if ($maxDepth -gt 9) {
        Write-Host ""
        Write-Error-Custom "This folder has $maxDepth nested levels (max 9 allowed for safety)."
        Write-Error-Custom "Please choose a folder with fewer nested subfolders."
        Start-Sleep -Seconds 2
        return
    }
    
    $script:Config.ParentScope = $resolvedPath
    Write-Host ""
    Write-Success "Parent scope set to: $($script:Config.ParentScope)"
    if ($maxDepth -gt 0) {
        Write-Info "Folder depth: $maxDepth level(s)"
    }
    Start-Sleep -Seconds 1
}
