# Functions ===================================================================

function ln {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Target,
        [Parameter(Mandatory=$true)]
        [string]$LinkPath
    )
    New-Item -ItemType SymbolicLink -Path $LinkPath -Value $Target
}

function push {
    param (
        [Parameter(Mandatory=$true)]
        [string]$CommitMessage
    )

    git add .
    git commit -m $CommitMessage
    git pull
    git push
}

function backup {
    Set-Location -Path "$env:USERPROFILE\\Dotfiles"
    push -CommitMessage "Backup from Windows Desktop"
    Pop-Location
    winget export --include-versions -o $HOME/Dotfiles/Desktop/Windows/winget.json
}

# Start Inits =================================================================

Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })

# Recycle Bin =================================================================

Add-Type -AssemblyName Microsoft.VisualBasic

function Remove-ItemToRecycleBin {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$Path
    )
    process {
        foreach ($item in $Path) {
            $fullPath = (Get-Item $item -ErrorAction Stop).FullName
            if (Test-Path $fullPath -PathType Container) {
                [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory(
                    $fullPath, 'OnlyErrorDialogs', 'SendToRecycleBin'
                )
            } else {
                [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile(
                    $fullPath, 'OnlyErrorDialogs', 'SendToRecycleBin'
                )
            }
            Write-Host "Moved to Recycle Bin: $fullPath" -ForegroundColor Green
        }
    }
}

Set-Alias rm Remove-ItemToRecycleBin -Option AllScope
