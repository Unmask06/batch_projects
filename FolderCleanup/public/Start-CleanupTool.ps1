function Start-CleanupTool {
    <#
    .SYNOPSIS
        Start the interactive cleanup tool
    .DESCRIPTION
        Launches the main menu-driven interface for the folder cleanup utility
    .EXAMPLE
        Start-CleanupTool
    #>
    [CmdletBinding()]
    param()
    
    # Check if parent scope is set, if not, prompt to set it first
    if ($null -eq $script:Config.ParentScope -or [string]::IsNullOrWhiteSpace($script:Config.ParentScope)) {
        Write-Header
        Write-Host ""
        Write-Warning-Custom "Parent scope is not set!"
        Write-Info "You must set a parent scope folder before using the cleanup tool."
        Write-Info "This restricts all cleanup operations to the specified folder and its subfolders."
        Write-Host ""
        Set-ParentScope
        
        # If still not set, exit
        if ($null -eq $script:Config.ParentScope -or [string]::IsNullOrWhiteSpace($script:Config.ParentScope)) {
            Write-Host ""
            Write-Error-Custom "Parent scope is required to run cleanup operations. Exiting..."
            Write-Host ""
            return
        }
    }
    
    $running = $true
    
    while ($running) {
        Write-Header
        Write-Separator "MAIN MENU"
        Write-Host ""
        Write-Info "Scope: $($script:Config.ParentScope)"
        Write-Host ""
        Write-Host "    [1] Clean Files (by Keyword and/or Extension)" -ForegroundColor White
        Write-Host "    [2] Clean Folders by Keyword" -ForegroundColor White
        Write-Host ""
        Write-Host "    --- Presets ---" -ForegroundColor DarkGray
        Write-Host "    [3] Remove Empty Files (0 bytes)" -ForegroundColor White
        Write-Host "    [4] Remove Empty Folders" -ForegroundColor White
        Write-Host ""
        Write-Host "    [R] Restart (Clear All & Set New Scope)" -ForegroundColor Yellow
        Write-Host "    [Q] Exit" -ForegroundColor Red
        Write-Host ""
        Write-Separator
        Write-Host ""
        Write-Host "  Enter your choice: " -ForegroundColor Cyan -NoNewline
        $choice = Read-Host
        
        switch ($choice.ToUpper()) {
            "1" { Remove-Files }
            "2" { Remove-FoldersByKeyword }
            "3" { Remove-EmptyFiles }
            "4" { Remove-EmptyFolders }
            "R" {
                # Restart - clear scope and re-prompt
                $script:Config.ParentScope = $null
                Clear-Host
                Write-Header
                Write-Host ""
                Write-Info "Restarting... Please set a new parent scope."
                Write-Host ""
                Set-ParentScope
                if ($null -eq $script:Config.ParentScope -or [string]::IsNullOrWhiteSpace($script:Config.ParentScope)) {
                    Write-Host ""
                    Write-Error-Custom "Parent scope is required. Exiting..."
                    Write-Host ""
                    $running = $false
                }
            }
            "Q" {
                Write-Host ""
                Write-Host "  Thank you for using Folder Cleanup Utility!" -ForegroundColor Cyan
                Write-Host "  Goodbye!" -ForegroundColor Gray
                Write-Host ""
                $running = $false
            }
            default {
                Write-Host ""
                Write-Error-Custom "Invalid option. Please try again."
                Start-Sleep -Seconds 1
            }
        }
    }
}
