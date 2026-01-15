function Remove-Files {
    <#
    .SYNOPSIS
        Remove files by keyword and/or extension from parent scope
    .DESCRIPTION
        Prompts for keywords and extensions, scans and removes matching files with double confirmation
    .EXAMPLE
        Remove-Files
    #>
    [CmdletBinding()]
    param()
    
    Write-Header
    Write-Separator "CLEAN FILES"
    Write-Host ""
    Write-Info "Scope: $($script:Config.ParentScope)"
    Write-Host ""
    Write-Info "You can search by keywords, extensions, or both."
    Write-Info "Leave blank to skip that filter."
    Write-Host ""
    
    # Get keywords
    Write-Host "  Enter keyword(s) to search in filenames (comma-separated): " -ForegroundColor Cyan
    Write-Host "  Example: backup, old, copy" -ForegroundColor DarkGray
    Write-Host "  [M] Main Menu" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Keyword(s): " -ForegroundColor Cyan -NoNewline
    $keywordInput = Read-Host
    
    if ($keywordInput.ToUpper() -eq 'M') {
        return
    }
    
    Write-Host ""
    
    # Get extensions
    Write-Host "  Enter extension(s) to search (comma-separated, without dot): " -ForegroundColor Cyan
    Write-Host "  Example: tmp, log, bak" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  Extension(s): " -ForegroundColor Cyan -NoNewline
    $extInput = Read-Host
    
    if ($extInput.ToUpper() -eq 'M') {
        return
    }
    
    # Parse inputs
    $keywords = @()
    $extensions = @()
    
    if (-not [string]::IsNullOrWhiteSpace($keywordInput)) {
        $keywords = $keywordInput.Split(',') | ForEach-Object { $_.Trim() } | Where-Object { $_ }
    }
    
    if (-not [string]::IsNullOrWhiteSpace($extInput)) {
        $extensions = $extInput.Split(',') | ForEach-Object { $_.Trim() } | Where-Object { $_ }
    }
    
    # Check if at least one filter is provided
    if ($keywords.Count -eq 0 -and $extensions.Count -eq 0) {
        Write-Host ""
        Write-Error-Custom "No keywords or extensions provided. Nothing to search for."
        Start-Sleep -Seconds 2
        return
    }
    
    Write-Host ""
    if ($keywords.Count -gt 0) {
        Write-Host "  Searching for keywords: $($keywords -join ', ')" -ForegroundColor Yellow
    }
    if ($extensions.Count -gt 0) {
        Write-Host "  Searching for extensions: $($extensions -join ', ')" -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "  Scanning..." -ForegroundColor Yellow
    
    $files = @()
    $totalSize = 0
    $allFiles = Get-ChildItem -Path $script:Config.ParentScope -File -Recurse -ErrorAction SilentlyContinue
    
    foreach ($file in $allFiles) {
        $matchKeyword = $false
        $matchExtension = $false
        
        # Check keywords
        if ($keywords.Count -gt 0) {
            foreach ($kw in $keywords) {
                if ($file.Name -like "*$kw*") {
                    $matchKeyword = $true
                    break
                }
            }
        }
        
        # Check extensions
        if ($extensions.Count -gt 0) {
            $fileExt = $file.Extension.TrimStart('.')
            if ($extensions -contains $fileExt) {
                $matchExtension = $true
            }
        }
        
        # Add file if it matches any filter
        if (($keywords.Count -gt 0 -and $matchKeyword) -or ($extensions.Count -gt 0 -and $matchExtension)) {
            $files += $file
            $totalSize += $file.Length
        }
    }
    
    if ($files.Count -eq 0) {
        Write-Host ""
        Write-Success "No matching files found. Nothing to delete!"
        Start-Sleep -Seconds 2
        return
    }
    
    Show-ItemsPreview -Items $files -ItemType "file" -TargetPath $script:Config.ParentScope
    
    $confirmed = Get-DoubleConfirmation -ItemType "file" -Count $files.Count -TotalSize $totalSize
    
    if ($confirmed) {
        Invoke-DeleteItems -Items $files -ItemType "file"
    }
    
    Write-Host ""
    Write-Host "  Press any key to continue..." -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Show-ItemsPreview {
    param(
        [array]$Items,
        [string]$ItemType,
        [string]$TargetPath
    )
    
    Write-Host ""
    Write-Separator "$($ItemType.ToUpper())S FOUND"
    Write-Host ""
    
    if ($ItemType -eq "file") {
        $grouped = $Items | Group-Object { $_.Extension }
        foreach ($group in $grouped) {
            Write-Host "    $($group.Name): " -ForegroundColor Cyan -NoNewline
            Write-Host "$($group.Count) file(s)" -ForegroundColor White
        }
        Write-Host ""
    }
    
    Write-Info "Showing first 20 items:"
    Write-Host ""
    
    $displayItems = $Items | Select-Object -First 20
    foreach ($item in $displayItems) {
        $relativePath = $item.FullName.Replace($TargetPath, "").TrimStart('\')
        if ($ItemType -eq "file") {
            Write-Bullet "$relativePath ($(Format-FileSize $item.Length))" -Color DarkGray
        } else {
            Write-Bullet $relativePath -Color DarkGray
        }
    }
    
    if ($Items.Count -gt 20) {
        Write-Host ""
        Write-Host "      ... and $($Items.Count - 20) more $($ItemType)s" -ForegroundColor DarkYellow
    }
}

function Invoke-DeleteItems {
    param(
        [array]$Items,
        [string]$ItemType
    )
    
    $deleted = 0
    $failed = 0
    
    Write-Host "  Deleting $($ItemType)s..." -ForegroundColor Yellow
    Write-Host ""
    
    # Sort folders by depth (deepest first) to avoid deleting parent before child
    if ($ItemType -eq "folder") {
        $Items = $Items | Sort-Object { $_.FullName.Split('\').Count } -Descending
    }
    
    foreach ($item in $Items) {
        try {
            if ($ItemType -eq "folder") {
                Remove-Item -Path $item.FullName -Recurse -Force -ErrorAction Stop
            } else {
                Remove-Item -Path $item.FullName -Force -ErrorAction Stop
            }
            $deleted++
            $progress = [math]::Round(($deleted / $Items.Count) * 100)
            Write-Host "`r  Progress: [$('#' * [math]::Floor($progress/5))$('-' * (20 - [math]::Floor($progress/5)))] $progress% ($deleted/$($Items.Count))" -ForegroundColor Green -NoNewline
        } catch {
            $failed++
        }
    }
    
    Write-Host ""
    Write-Host ""
    Write-Separator "DELETION COMPLETE"
    Write-Host ""
    Write-Success "Successfully deleted: $deleted $($ItemType)(s)"
    if ($failed -gt 0) {
        Write-Error-Custom "Failed to delete: $failed $($ItemType)(s)"
    }
}


