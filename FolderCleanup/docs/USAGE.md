# FolderCleanup Usage Guide

A simple, safe PowerShell tool for cleaning up files and folders.

## Quick Launch

```powershell
.\FolderCleanup\Launch.ps1
```

Or manually:

```powershell
Import-Module .\FolderCleanup\FolderCleanup.psd1
Start-CleanupTool
```

---

## Step-by-Step Guide

### Step 1: Set Parent Scope (Required)

On first launch, you must set a **Parent Scope** - this restricts all operations to that folder.

- Enter a path like `C:\Projects` or type `.` for current directory
- **Safety limit**: Maximum 9 nested folder levels allowed
- All cleanup operations will only work within this folder

### Step 2: Choose a Cleanup Action

The Main Menu shows cleanup options and presets:

| Option                           | Description                              | You Enter                             |
| -------------------------------- | ---------------------------------------- | ------------------------------------- |
| **[1] Clean Files**              | Delete files by keyword and/or extension | Keywords + Extensions (or just one)   |
| **[2] Clean Folders by Keyword** | Delete folders containing a word in name | e.g., `node_modules`, `cache`, `temp` |

**Presets (no input needed):**

| Option                       | Description                        |
| ---------------------------- | ---------------------------------- |
| **[3] Remove Empty Files**   | Delete all files with 0 bytes      |
| **[4] Remove Empty Folders** | Delete all folders with no content |

### Clean Files Option Details

When you select **[1] Clean Files**, you'll be asked for:

1. **Keywords** (comma-separated) - matches filenames containing these words
2. **Extensions** (comma-separated, without dot) - matches file types

You can provide:

- **Both** keywords and extensions
- **Only keywords** (leave extensions blank)
- **Only extensions** (leave keywords blank)

Files matching **either** filter will be selected for deletion.

### Step 3: Review Results

After scanning, you'll see:

- List of items found (first 20)
- Total count
- Estimated size to free

### Step 4: Confirm Deletion

Two-step confirmation:

1. Type `YES` to proceed
2. Type `DELETE` to confirm

---

## Navigation

| Key     | Action                                     |
| ------- | ------------------------------------------ |
| **[M]** | Return to Main Menu (during any operation) |
| **[R]** | Restart - Clear scope and start fresh      |
| **[Q]** | Exit the tool                              |

---

## Safety Features

- **No defaults** - You specify exactly what to delete each time
- **Scope restriction** - Cannot delete outside parent scope
- **Max 9 nested levels** - Prevents accidental deep folder access
- **Double confirmation** - Must type YES then DELETE
- **Preview first** - Always shows what will be deleted

---

## Examples

### Delete `.log` and `.tmp` files

1. Launch tool, set scope to `C:\Projects`
2. Press `[1]` Clean Files
3. Keywords: _(leave blank)_
4. Extensions: `log, tmp`
5. Review and confirm

### Delete all `node_modules` folders

1. Launch tool, set scope to `C:\Projects`
2. Press `[2]` Clean Folders by Keyword
3. Enter: `node_modules`
4. Review and confirm

### Delete files with "backup" or "old" in name

1. Launch tool, set scope
2. Press `[1]` Clean Files
3. Keywords: `backup, old`
4. Extensions: _(leave blank)_
5. Review and confirm

### Delete backup files with specific extensions

1. Launch tool, set scope
2. Press `[1]` Clean Files
3. Keywords: `backup`
4. Extensions: `bak, old, tmp`
5. Review and confirm (matches files with keyword OR extension)

---

## Troubleshooting

- **"Parent scope required"** - Enter a valid folder path first
- **No items found** - Check your keyword/extension spelling
- **Access Denied** - Run PowerShell as Administrator
