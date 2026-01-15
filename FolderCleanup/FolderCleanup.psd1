@{
    # Module Manifest for FolderCleanup
    
    RootModule = 'FolderCleanup.psm1'
    ModuleVersion = '1.0.0'
    GUID = '12345678-1234-1234-1234-123456789abc'
    Author = 'Your Name'
    CompanyName = 'Unknown'
    Copyright = '(c) 2026. All rights reserved.'
    Description = 'A comprehensive PowerShell module for safely cleaning up unwanted files and folders with double confirmation.'
    
    PowerShellVersion = '5.1'
    
    FunctionsToExport = @(
        'Start-CleanupTool',
        'Remove-Files',
        'Remove-FoldersByKeyword',
        'Remove-EmptyFiles',
        'Remove-EmptyFolders'
    )
    
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    
    PrivateData = @{
        PSData = @{
            Tags = @('Cleanup', 'FileManagement', 'Maintenance', 'Utility')
            LicenseUri = ''
            ProjectUri = ''
            IconUri = ''
            ReleaseNotes = 'Initial release of FolderCleanup module'
        }
    }
}
