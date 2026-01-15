# FolderCleanup Module - Quick Reference

## Module Structure

```
FolderCleanup/
├── private/                      # Internal functions (not exported)
│   ├── Config.ps1                # Module configuration
│   ├── UI.ps1                    # UI helpers (Write-Header, etc.)
│   ├── PathValidation.ps1        # Path validation logic
│   ├── Scanner.ps1               # File/folder scanning
│   └── Confirmation.ps1          # Double confirmation dialogs
├── public/                       # Exported functions
│   ├── Remove-Files.ps1          # Remove-CleanupFiles
│   ├── Remove-Folders.ps1        # Remove-CleanupFolders
│   ├── Invoke-FullCleanup.ps1    # Full cleanup
│   ├── Show-CleanupConfiguration.ps1
│   ├── Set-CleanupConfiguration.ps1
│   └── Start-CleanupTool.ps1     # Interactive menu
├── tests/                        # Pester tests
│   └── FolderCleanup.Tests.ps1
├── docs/                         # Documentation
│   └── USAGE.md
├── FolderCleanup.psd1            # Module manifest
├── FolderCleanup.psm1            # Root module file
├── Launch.ps1                    # Quick launcher
└── README.md
```

## Exported Functions (Public API)

| Function                    | Description                       |
| --------------------------- | --------------------------------- |
| `Start-CleanupTool`         | Launch interactive menu interface |
| `Remove-CleanupFiles`       | Remove files by extension         |
| `Remove-CleanupFolders`     | Remove folders by keyword         |
| `Invoke-FullCleanup`        | Remove both files and folders     |
| `Show-CleanupConfiguration` | Display current settings          |
| `Set-CleanupConfiguration`  | Modify settings interactively     |

## Quick Start

### Option 1: Use Launcher

```powershell
.\FolderCleanup\Launch.ps1
```

### Option 2: Import and Run

```powershell
Import-Module .\FolderCleanup\FolderCleanup.psd1
Start-CleanupTool
```

### Option 3: Command Line

```powershell
Import-Module .\FolderCleanup\FolderCleanup.psd1
Set-CleanupConfiguration          # Configure first
Remove-CleanupFiles -Path "C:\Temp"
```

## UI Improvements

### Before (Original)

- Complex box-drawing characters
- Verbose separators
- Cluttered output

### After (Modular)

- Clean ASCII-based UI
- Simplified headers and separators
- Better spacing and readability
- Consistent color scheme:
  - **Cyan**: Headers and info
  - **Yellow**: Warnings and highlights
  - **Green**: Success messages
  - **Red**: Errors and critical actions
  - **Gray**: Secondary info

## Benefits of Modular Structure

✅ **Maintainability**: Each function in separate file
✅ **Testability**: Pester tests included
✅ **Reusability**: Import individual functions
✅ **Documentation**: Built-in help with Comment-Based Help
✅ **Discoverability**: `Get-Help` works on all functions
✅ **Scalability**: Easy to add new features
✅ **Standards**: Follows PowerShell module best practices

## Testing

Run Pester tests:

```powershell
cd FolderCleanup
Invoke-Pester -Path .\tests\FolderCleanup.Tests.ps1
```

## Help System

Get help for any function:

```powershell
Get-Help Start-CleanupTool -Full
Get-Help Remove-CleanupFiles -Examples
Get-Help Invoke-FullCleanup -Detailed
```

## Installation for Daily Use

Copy to PowerShell modules directory:

```powershell
$modulePath = "$env:USERPROFILE\Documents\PowerShell\Modules\FolderCleanup"
Copy-Item -Path .\FolderCleanup -Destination $modulePath -Recurse -Force
Import-Module FolderCleanup
```

Then use anywhere:

```powershell
Start-CleanupTool
```
