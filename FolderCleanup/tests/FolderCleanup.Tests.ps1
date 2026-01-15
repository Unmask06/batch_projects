# Pester Tests for FolderCleanup Module
# Run: Invoke-Pester -Path .\tests\FolderCleanup.Tests.ps1

BeforeAll {
    # Import module
    Import-Module $PSScriptRoot\..\FolderCleanup.psd1 -Force
    
    # Create test directory
    $script:TestPath = Join-Path $env:TEMP "FolderCleanupTests_$(Get-Random)"
    New-Item -Path $script:TestPath -ItemType Directory -Force | Out-Null
}

AfterAll {
    # Cleanup test directory
    if (Test-Path $script:TestPath) {
        Remove-Item -Path $script:TestPath -Recurse -Force
    }
    
    # Remove module
    Remove-Module FolderCleanup -Force -ErrorAction SilentlyContinue
}

Describe 'FolderCleanup Module' {
    
    Context 'Module Loading' {
        It 'Should import successfully' {
            Get-Module FolderCleanup | Should -Not -BeNullOrEmpty
        }
        
        It 'Should export Start-CleanupTool function' {
            Get-Command Start-CleanupTool -Module FolderCleanup -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }
        
        It 'Should export Remove-CleanupFiles function' {
            Get-Command Remove-CleanupFiles -Module FolderCleanup -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }
        
        It 'Should export Remove-CleanupFolders function' {
            Get-Command Remove-CleanupFolders -Module FolderCleanup -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
        }
    }
    
    Context 'Configuration' {
        It 'Should have default file extensions configured' {
            $config = Get-Variable -Name Config -Scope Script -ValueOnly -ErrorAction SilentlyContinue
            $config.FileExtensions | Should -Contain 'tmp'
            $config.FileExtensions | Should -Contain 'temp'
        }
        
        It 'Should have default folder keywords configured' {
            $config = Get-Variable -Name Config -Scope Script -ValueOnly -ErrorAction SilentlyContinue
            $config.FolderKeywords | Should -Contain 'temp'
            $config.FolderKeywords | Should -Contain 'cache'
        }
    }
    
    Context 'File Operations' {
        BeforeEach {
            # Create test files
            New-Item -Path "$script:TestPath\test1.tmp" -ItemType File -Force | Out-Null
            New-Item -Path "$script:TestPath\test2.log" -ItemType File -Force | Out-Null
            New-Item -Path "$script:TestPath\test3.txt" -ItemType File -Force | Out-Null
        }
        
        AfterEach {
            # Cleanup
            Get-ChildItem -Path $script:TestPath -File | Remove-Item -Force
        }
        
        It 'Should find .tmp files' {
            $files = Get-ChildItem -Path $script:TestPath -Filter "*.tmp"
            $files.Count | Should -Be 1
        }
        
        It 'Should find .log files' {
            $files = Get-ChildItem -Path $script:TestPath -Filter "*.log"
            $files.Count | Should -Be 1
        }
    }
    
    Context 'Folder Operations' {
        BeforeEach {
            # Create test folders
            New-Item -Path "$script:TestPath\temp_folder" -ItemType Directory -Force | Out-Null
            New-Item -Path "$script:TestPath\cache_data" -ItemType Directory -Force | Out-Null
            New-Item -Path "$script:TestPath\normal_folder" -ItemType Directory -Force | Out-Null
        }
        
        AfterEach {
            # Cleanup
            Get-ChildItem -Path $script:TestPath -Directory | Remove-Item -Recurse -Force
        }
        
        It 'Should identify temp folders' {
            $folders = Get-ChildItem -Path $script:TestPath -Directory | Where-Object { $_.Name -like "*temp*" }
            $folders.Count | Should -BeGreaterThan 0
        }
        
        It 'Should identify cache folders' {
            $folders = Get-ChildItem -Path $script:TestPath -Directory | Where-Object { $_.Name -like "*cache*" }
            $folders.Count | Should -BeGreaterThan 0
        }
    }
}
