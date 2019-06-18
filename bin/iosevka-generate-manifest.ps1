$templateString = @"
{
    "version": "0.0",
    "license": "SIL Open Font License v1.1",
    "homepage": "https://github.com/be5invis/Iosevka",
    "url": " ",
    "hash": " ",
    "checkver": "github",
    "depends": "sudo",
    "autoupdate": {
        "url": "https://github.com/be5invis/Iosevka/releases/download/v`$version/%name-`$version.zip"
    },
    "installer": {
        "script": [
            "if(!(is_admin)) { error \"Admin rights are required, please run 'sudo scoop install `$app'\"; exit 1 }",
            "Get-ChildItem `$dir\\ttf | ForEach-Object {",
            "    New-ItemProperty -Path 'HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Fonts' -Name `$_.Name.Replace(`$_.Extension, ' (TrueType)') -Value `$_.Name -Force | Out-Null",
            "    Copy-Item \"`$dir\\ttf\\`$_\" -destination \"`$env:windir\\Fonts\"",
            "}"
        ]
    },
    "uninstaller": {
        "script": [
            "if(!(is_admin)) { error \"Admin rights are required, please run 'sudo scoop uninstall `$app'\"; exit 1 }",
            "Get-ChildItem `$dir\\ttf | ForEach-Object {",
            "    Remove-ItemProperty -Path 'HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Fonts' -Name `$_.Name.Replace(`$_.Extension, ' (TrueType)') -Force -ErrorAction SilentlyContinue",
            "    Remove-Item \"`$env:windir\\Fonts\\`$(`$_.Name)\" -Force -ErrorAction SilentlyContinue",
            "}",
            "Write-Host \"The '`$(`$app)' Font family has been uninstalled and will not be present after restarting your computer.\" -Foreground Magenta"
        ]
    }
}
"@

$fontNames = @(
    "01-iosevka",
    "02-iosevka-term",
    "03-iosevka-type",
    "04-iosevka-cc",
    "05-iosevka-slab",
    "06-iosevka-term-slab",
    "07-iosevka-type-slab",
    "08-iosevka-cc-slab"
)

$bucket = "$PSScriptRoot\..\bucket"
if (-not (Test-Path $bucket))
{
    mkdir -Path $bucket
}

# Generate manifests
$fontNames | ForEach-Object {
    $manifest = $_ -replace "^\d+-", ""
    $content = ($templateString -replace "%name", $_)
    [System.IO.File]::WriteAllText("$bucket\$manifest-font.json", $content)
}
