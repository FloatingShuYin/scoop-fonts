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
    "08-iosevka-cc-slab",
    "iosevka-ss01",
    "iosevka-ss02",
    "iosevka-ss03",
    "iosevka-ss04",
    "iosevka-ss05",
    "iosevka-ss06",
    "iosevka-ss07",
    "iosevka-ss08",
    "iosevka-ss09",
    "iosevka-ss10",
    "iosevka-ss11",
    "iosevka-term-ss01",
    "iosevka-term-ss02",
    "iosevka-term-ss03",
    "iosevka-term-ss04",
    "iosevka-term-ss05",
    "iosevka-term-ss06",
    "iosevka-term-ss07",
    "iosevka-term-ss08",
    "iosevka-term-ss09",
    "iosevka-term-ss10",
    "iosevka-term-ss11"
)

# Generate manifests
$fontNames | ForEach-Object {
    $manifest = $_ -replace "^\d+-", ""
    $templateString -replace "%name", $_ | Out-File -FilePath "$PSScriptRoot\..\$manifest-font.json" -Encoding utf8
}

# Use scoop's checkver script to autoupdate the manifests
& $psscriptroot\checkver.ps1 * -u
