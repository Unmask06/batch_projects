function Write-ColorText {
    param(
        [string]$Text,
        [ConsoleColor]$Color = "White"
    )
    Write-Host $Text -ForegroundColor $Color
}

function Write-Header {
    Clear-Host
    Write-Host ""
    Write-Host "  ================================================================" -ForegroundColor Cyan
    Write-Host "                FOLDER CLEANUP UTILITY v1.0                      " -ForegroundColor Yellow
    Write-Host "          Safely clean up unwanted files and folders             " -ForegroundColor Gray
    Write-Host "  ================================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Separator {
    param([string]$Title = "")
    if ($Title) {
        Write-Host ""
        Write-Host "  $('=' * 70)" -ForegroundColor DarkCyan
        Write-Host "  $Title" -ForegroundColor White
        Write-Host "  $('=' * 70)" -ForegroundColor DarkCyan
    } else {
        Write-Host "  $('-' * 70)" -ForegroundColor DarkGray
    }
}

function Write-Success {
    param([string]$Message)
    Write-Host "  [+] " -ForegroundColor Green -NoNewline
    Write-Host $Message -ForegroundColor Green
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "  [-] " -ForegroundColor Red -NoNewline
    Write-Host $Message -ForegroundColor Red
}

function Write-Info {
    param([string]$Message)
    Write-Host "  [i] " -ForegroundColor Cyan -NoNewline
    Write-Host $Message -ForegroundColor White
}

function Write-Warning-Custom {
    param([string]$Message)
    Write-Host "  [!] " -ForegroundColor Yellow -NoNewline
    Write-Host "WARNING: " -ForegroundColor Red -NoNewline
    Write-Host $Message -ForegroundColor Yellow
}

function Write-Bullet {
    param(
        [string]$Message, 
        [ConsoleColor]$Color = "White"
    )
    Write-Host "      - " -ForegroundColor DarkGray -NoNewline
    Write-Host $Message -ForegroundColor $Color
}
