# Quick launcher script for FolderCleanup module
# Simply run: .\Launch.ps1

# Import the module
Import-Module $PSScriptRoot\FolderCleanup.psd1 -Force

# Start the interactive tool
Start-CleanupTool
