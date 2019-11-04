function ll() {
    exa -l
}

function la {
    exa -a
}

Set-Alias -Name ls -Value exa

function Prompt {
    $CurrentDir = $PWD.ToString() `
        -replace "^$ENV:HOME","~" `
        -replace "/([^/.])[^/]*(?=/)",'/$1' `
        -replace "/\.([^/])[^/]*(?=/)",'/.$1';
    Write-Host -NoNewline -ForegroundColor Green "$CurrentDir";
    "> ";
}
