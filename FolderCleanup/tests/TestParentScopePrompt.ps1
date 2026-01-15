# Test the new parent scope prompt feature
# This script demonstrates the new behavior

Write-Host "Testing FolderCleanup Module - Parent Scope First Launch" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host ""

# Remove any existing scope to simulate first launch
$script:Config.ParentScope = $null

Write-Host "Simulating first launch (no parent scope set)..." -ForegroundColor Yellow
Write-Host ""
Write-Host "Expected behavior:" -ForegroundColor Green
Write-Host "  1. Tool should prompt for parent scope immediately" -ForegroundColor White
Write-Host "  2. User can enter '.' for current directory" -ForegroundColor White
Write-Host "  3. After setting scope, main menu appears" -ForegroundColor White
Write-Host ""
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host ""
Write-Host "Press Enter to test Start-CleanupTool..." -ForegroundColor Yellow
Read-Host

# This will trigger the parent scope prompt
# Start-CleanupTool
