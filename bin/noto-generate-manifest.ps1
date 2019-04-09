$templateString = @"
{
    "version": "0.0",
    "license": "SIL Open Font License v1.1",
    "homepage": "https://www.google.com/get/noto/",
    "url": "https://noto-website-2.storage.googleapis.com/pkgs/%name.zip",
    "hash": " ",
    "depends": "sudo",
    "autoupdate": {
        "url": "https://noto-website-2.storage.googleapis.com/pkgs/%name.zip"
    },
    "checkver": {
        "url": "https://github.com/googlei18n/noto-fonts/releases/latest",
        "re":  "\\/releases\\/tag\\/(?:v|V)?(\\d+\\-\\d+\\-\\d+)"
    },
    "installer": {
        "script": [
            "if(!(is_admin)) { error \"Admin rights are required, please run 'sudo scoop install `$app'\"; exit 1 }",
            "Get-ChildItem `$dir | ForEach-Object {",
            "    New-ItemProperty -Path 'HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Fonts' -Name `$_.Name.Replace(`$_.Extension, ' (TrueType)') -Value `$_.Name -Force | Out-Null",
            "    Copy-Item \"`$dir\\`$_\" -destination \"`$env:windir\\Fonts\"",
            "}"
        ]
    },
    "uninstaller": {
        "script": [
            "if(!(is_admin)) { error \"Admin rights are required, please run 'sudo scoop uninstall `$app'\"; exit 1 }",
            "Get-ChildItem `$dir | ForEach-Object {",
            "    Remove-ItemProperty -Path 'HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Fonts' -Name `$_.Name.Replace(`$_.Extension, ' (TrueType)') -Force -ErrorAction SilentlyContinue",
            "    Remove-Item \"`$env:windir\\Fonts\\`$(`$_.Name)\" -Force -ErrorAction SilentlyContinue",
            "}",
            "Write-Host \"The '`$(`$app)' Font family has been uninstalled and will not be present after restarting your computer.\" -Foreground Magenta"
        ]
    }
}
"@

$fontNames = @(
    "Noto-hinted",
    "NotoColorEmoji-unhinted",
    "NotoEmoji-unhinted",
    "NotoMono-hinted"
    "NotoSans-hinted",
    "NotoSansDisplay-hinted",
    "NotoSansMono-hinted",
    "NotoSerif-hinted",
    "NotoSerifDisplay-hinted"
)

$bucket = "$PSScriptRoot\..\bucket"
if (-not (Test-Path $bucket))
{
    mkdir -Path $bucket
}

# Generate manifests
$fontNames | ForEach-Object {
    $manifest = ($_ -replace "-hinted", "" -replace "-unhinted", "").ToLower()
    $content = ($templateString -replace "%name", $_)
    [System.IO.File]::WriteAllText("$bucket\$manifest-font.json", $content)
}
