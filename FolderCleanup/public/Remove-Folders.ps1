function Remove-FoldersByKeyword {
    <#
    .SYNOPSIS
        Remove folders by keyword from parent scope
    .DESCRIPTION
        Prompts for keyword, scans and removes matching folders with double confirmation
    .EXAMPLE
        Remove-FoldersByKeyword
    #>
    [CmdletBinding()]
    param()
    
    Write-Header
    Write-Separator "CLEAN FOLDERS BY KEYWORD"
    Write-Host ""
    Write-Info "Scope: $($script:Config.ParentScope)"
    Write-Host ""
    Write-Host "  Enter keyword to search in folder names: " -ForegroundColor Cyan -NoNewline
    Write-Host ""
    Write-Host "  Example: node_modules, cache, temp, __pycache__" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  [M] Main Menu" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Keyword: " -ForegroundColor Cyan -NoNewline
    $keyword = Read-Host
    
    if ($keyword.ToUpper() -eq 'M' -or [string]::IsNullOrWhiteSpace($keyword)) {
        return
    }
    
    Write-Host ""
    Write-Host "  Scanning for folders containing '$keyword'..." -ForegroundColor Yellow
    
    $folders = @()
    $totalSize = 0
    $allFolders = Get-ChildItem -Path $script:Config.ParentScope -Directory -Recurse -ErrorAction SilentlyContinue
    
    foreach ($folder in $allFolders) {
        if ($folder.Name -like "*$keyword*") {
            $folders += $folder
            try {
                $folderSize = (Get-ChildItem -Path $folder.FullName -Recurse -File -ErrorAction SilentlyContinue | 
                               Measure-Object -Property Length -Sum).Sum
                $totalSize += $folderSize
            } catch {
                # Skip if cannot calculate size
            }
        }
    }
    
    if ($folders.Count -eq 0) {
        Write-Host ""
        Write-Success "No folders found matching '$keyword'. Nothing to delete!"
        Start-Sleep -Seconds 2
        return
    }
    
    Show-ItemsPreview -Items $folders -ItemType "folder" -TargetPath $script:Config.ParentScope
    
    $confirmed = Get-DoubleConfirmation -ItemType "folder" -Count $folders.Count -TotalSize $totalSize
    
    if ($confirmed) {
        Invoke-DeleteItems -Items $folders -ItemType "folder"
    }
    
    Write-Host ""
    Write-Host "  Press any key to continue..." -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
