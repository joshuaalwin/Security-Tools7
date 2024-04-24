$sourcePath = "D:\PurpleKnight-Community.zip.b64"
$targetPath = "D:\PurpleKnight-Community-extract.zip"
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

$base64Data = [System.IO.File]::ReadAllText($sourcePath)
$bytes = [System.Convert]::FromBase64String($base64Data)
[System.IO.File]::WriteAllBytes($targetPath, $bytes)

$stopwatch.Stop()
Write-Host "Elapsed: $($stopwatch.Elapsed.TotalSeconds) seconds for decoding"