# FolderCleanup PowerShell Module

A simple, safe PowerShell tool for cleaning up files and folders with double confirmation.

## Features

- Clean files by keyword (matches filename)
- Clean folders by keyword (matches folder name)
- Clean files by extension
- Parent scope restriction for safety
- Double confirmation before deletion
- Progress tracking
- No defaults - you specify what to delete each time

## Installation

```powershell
Import-Module .\FolderCleanup\FolderCleanup.psd1
```

Or use the launcher:

```powershell
.\FolderCleanup\Launch.ps1
```

## Quick Start

```powershell
Start-CleanupTool
```

### Flow:

1. **Set Parent Scope** - Enter path (or `.` for current dir)
2. **Choose Action**:
   - `[1]` Clean Files by Keyword
   - `[2]` Clean Folders by Keyword
   - `[3]` Clean Files by Extension
3. **Enter search term** when prompted
4. **Review** items found
5. **Confirm** deletion (YES → DELETE)

### Navigation:

- `[M]` Return to Main Menu
- `[R]` Restart (clear scope, start fresh)
- `[Q]` Exit

You specify which folder names to target.
Example: `temp, cache, node_modules, __pycache__, .cache`

## Safety Features

- **Parent Scope Required** - Must set before any operation
- **No Defaults** - You specify what to delete each time
- **Double Confirmation** - YES then DELETE
- **Preview** - Shows items before deletion
- **Size Calculation** - Shows space to be freed

## Module Structure

```
FolderCleanup/
├── private/
│   ├── Config.ps1
│   ├── UI.ps1
│   ├── PathValidation.ps1
│   ├── Scanner.ps1
│   └── Confirmation.ps1
├── public/
│   ├── Remove-Files.ps1
│   ├── Remove-Folders.ps1
│   └── Start-CleanupTool.ps1
├── docs/
│   └── USAGE.md
├── FolderCleanup.psd1
├── FolderCleanup.psm1
├── Launch.ps1
└── README.md
```

## Examples

### Delete `.log` files

```powershell
Start-CleanupTool
# Set scope → [3] → enter: log → confirm
```

### Delete `node_modules` folders

```powershell
Start-CleanupTool
# Set scope → [2] → enter: node_modules → confirm
```

### Delete files with "backup" in name

```powershell
Start-CleanupTool
# Set scope → [1] → enter: backup → confirm
```

## License

MIT License
