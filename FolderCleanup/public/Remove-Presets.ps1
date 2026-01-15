function Remove-EmptyFiles {
    <#
    .SYNOPSIS
        Remove files with 0 bytes from parent scope
    .DESCRIPTION
        Scans and removes all empty files (0 bytes) with double confirmation
    .EXAMPLE
        Remove-EmptyFiles
    #>
    [CmdletBinding()]
    param()
    
    Write-Header
    Write-Separator "REMOVE EMPTY FILES (0 BYTES)"
    Write-Host ""
    Write-Info "Scope: $($script:Config.ParentScope)"
    Write-Host ""
    Write-Host "  Scanning for empty files..." -ForegroundColor Yellow
    
    $files = @()
    $allFiles = Get-ChildItem -Path $script:Config.ParentScope -File -Recurse -ErrorAction SilentlyContinue
    
    foreach ($file in $allFiles) {
        if ($file.Length -eq 0) {
            $files += $file
        }
    }
    
    if ($files.Count -eq 0) {
        Write-Host ""
        Write-Success "No empty files found. Nothing to delete!"
        Start-Sleep -Seconds 2
        return
    }
    
    Show-ItemsPreview -Items $files -ItemType "file" -TargetPath $script:Config.ParentScope
    
    $confirmed = Get-DoubleConfirmation -ItemType "file" -Count $files.Count -TotalSize 0
    
    if ($confirmed) {
        Invoke-DeleteItems -Items $files -ItemType "file"
    }
    
    Write-Host ""
    Write-Host "  Press any key to continue..." -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Remove-EmptyFolders {
    <#
    .SYNOPSIS
        Remove empty folders from parent scope
    .DESCRIPTION
        Scans and removes all empty folders with double confirmation
    .EXAMPLE
        Remove-EmptyFolders
    #>
    [CmdletBinding()]
    param()
    
    Write-Header
    Write-Separator "REMOVE EMPTY FOLDERS"
    Write-Host ""
    Write-Info "Scope: $($script:Config.ParentScope)"
    Write-Host ""
    Write-Host "  Scanning for empty folders..." -ForegroundColor Yellow
    
    $folders = @()
    $allFolders = Get-ChildItem -Path $script:Config.ParentScope -Directory -Recurse -ErrorAction SilentlyContinue
    
    foreach ($folder in $allFolders) {
        $contents = Get-ChildItem -Path $folder.FullName -Force -ErrorAction SilentlyContinue
        if ($contents.Count -eq 0) {
            $folders += $folder
        }
    }
    
    if ($folders.Count -eq 0) {
        Write-Host ""
        Write-Success "No empty folders found. Nothing to delete!"
        Start-Sleep -Seconds 2
        return
    }
    
    Show-ItemsPreview -Items $folders -ItemType "folder" -TargetPath $script:Config.ParentScope
    
    $confirmed = Get-DoubleConfirmation -ItemType "folder" -Count $folders.Count -TotalSize 0
    
    if ($confirmed) {
        Invoke-DeleteItems -Items $folders -ItemType "folder"
    }
    
    Write-Host ""
    Write-Host "  Press any key to continue..." -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
