# Set Parameters ==============================================================

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# cd Last Dir Path ============================================================

$LAST_DIR_PATH = "$HOME/AppData/last-dir.txt"
if (-not (Test-Path $LAST_DIR_PATH)) {
    New-Item -ItemType File -Path $pathFile -Force
    echo $PWD.Path > $LAST_DIR_PATH
}
cd (Get-Content -Path $LAST_DIR_PATH -Raw).Trim()

# Redefine cd =================================================================

Invoke-Expression (& { (zoxide init powershell | Out-String) })
Remove-Item Alias:\cd -Force
function cd {
    param([string]$Path)
    z $Path
    echo $PWD.Path > $LAST_DIR_PATH
}

# Functions ===================================================================

function poweroff {
    Stop-Computer -Force
}
function reboot {
    Restart-Computer -Force
}

function prompt {
    # Get the current location (full path)
    $currentPath = Get-Location

    # Initialize git branch variable
    $gitBranch = ""

    # Check if current directory is a git repository
    if (Test-Path ".git" -PathType Container) {
        try {
            # Get current git branch
            $branch = git rev-parse --abbrev-ref HEAD 2>$null
            if ($branch) {
                $gitBranch = " (git:$branch)"
            }
        }
        catch {
            # Silently ignore git errors
        }
    }

    # Build and return the prompt
    Write-Host "`n$currentPath" -ForegroundColor Cyan -NoNewline
    if ($gitBranch) {
        Write-Host "$gitBranch" -ForegroundColor Yellow -NoNewline
    }

    return "> "
}

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
    winget export --include-versions -o $HOME/Dotfiles/Desktop/Windows/winget.json
    Set-Location -Path "$env:USERPROFILE\\Dotfiles"
    push -CommitMessage "Backup from Windows Desktop"
    Pop-Location
}

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
