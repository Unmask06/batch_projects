# Root Module File - FolderCleanup
# Imports all public and private functions

# Import configuration
. $PSScriptRoot\private\Config.ps1

# Import private functions
. $PSScriptRoot\private\UI.ps1
. $PSScriptRoot\private\PathValidation.ps1
. $PSScriptRoot\private\Scanner.ps1
. $PSScriptRoot\private\Confirmation.ps1

# Import public functions
. $PSScriptRoot\public\Remove-Files.ps1
. $PSScriptRoot\public\Remove-Folders.ps1
. $PSScriptRoot\public\Remove-Presets.ps1
. $PSScriptRoot\public\Start-CleanupTool.ps1

# Export public functions
Export-ModuleMember -Function @(
    'Start-CleanupTool',
    'Remove-Files',
    'Remove-FoldersByKeyword',
    'Remove-EmptyFiles',
    'Remove-EmptyFolders'
)
