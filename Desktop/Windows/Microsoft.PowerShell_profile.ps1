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
