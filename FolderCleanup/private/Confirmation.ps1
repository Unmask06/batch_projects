function Get-DoubleConfirmation {
    param(
        [string]$ItemType,
        [int]$Count,
        [long]$TotalSize
    )
    
    Write-Host ""
    Write-Host "  ================================================================" -ForegroundColor Red
    Write-Host "                  ⚠️  DELETION CONFIRMATION ⚠️                   " -ForegroundColor Yellow
    Write-Host "  ================================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "  SUMMARY:" -ForegroundColor Yellow
    Write-Host "    Type:       $ItemType" -ForegroundColor Cyan
    Write-Host "    Count:      $Count" -ForegroundColor Cyan
    Write-Host "    Total Size: $(Format-FileSize $TotalSize)" -ForegroundColor Cyan
    Write-Host ""
    
    # First Confirmation
    Write-Host "  FIRST CONFIRMATION" -ForegroundColor Magenta
    Write-Host "  $('-' * 70)" -ForegroundColor Magenta
    Write-Host "  Are you sure you want to delete these $Count $ItemType(s)?" -ForegroundColor White
    Write-Host "  Type " -ForegroundColor White -NoNewline
    Write-Host "YES" -ForegroundColor Green -NoNewline
    Write-Host " to confirm or " -ForegroundColor White -NoNewline
    Write-Host "NO" -ForegroundColor Red -NoNewline
    Write-Host " to cancel: " -ForegroundColor White -NoNewline
    $confirm1 = Read-Host
    
    if ($confirm1.ToUpper() -ne "YES") {
        Write-Host ""
        Write-Error-Custom "Operation cancelled by user."
        return $false
    }
    
    Write-Host ""
    Write-Success "First confirmation received."
    Write-Host ""
    
    # Second Confirmation
    Write-Host "  SECOND CONFIRMATION (FINAL)" -ForegroundColor Red
    Write-Host "  $('-' * 70)" -ForegroundColor Red
    Write-Host "  ⚠️  THIS ACTION CANNOT BE UNDONE!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Type " -ForegroundColor White -NoNewline
    Write-Host "DELETE" -ForegroundColor Red -NoNewline
    Write-Host " to permanently remove all items: " -ForegroundColor White -NoNewline
    $confirm2 = Read-Host
    
    if ($confirm2.ToUpper() -ne "DELETE") {
        Write-Host ""
        Write-Error-Custom "Operation cancelled by user."
        return $false
    }
    
    Write-Host ""
    Write-Success "Second confirmation received. Proceeding with deletion..."
    Write-Host ""
    
    return $true
}
