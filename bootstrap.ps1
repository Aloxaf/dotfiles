#!/usr/bin/pwsh

$root_dirs = @(Get-ChildItem / -Directory | ForEach-Object { $_.Name })

function deploy_to_root($config_name) {
    return @(Get-ChildItem $config_name -Force).Where({ $root_dirs.Contains($_.Name) }).Count
}

Get-ChildItem -Directory | ForEach-Object {
    if (deploy_to_root $_) {
        echo "deploy to / : $($_.Name)"
        sudo stow $_.Name --ignore=.directory --target=/
    } else {
        echo "deploy to ~ : $($_.Name)"
        stow $_.Name --ignore=.directory --target=$HOME
    }
}