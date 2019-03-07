function ll() {
    exa -l
}

function la {
    exa -a
}

Set-Alias -Name ls -Value exa

function Prompt
{
    $CurrentDir = (Get-Location).ToString() -replace "^$ENV:HOME","~"
    Write-Host -ForegroundColor Green "$CurrentDir"
    "> "
}
