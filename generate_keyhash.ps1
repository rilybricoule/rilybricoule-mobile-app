$sha1 = "15:C6:BD:F4:96:33:06:23:92:C9:32:50:80:8A:30:7A:BD:B8:DD:DB"
$hex = $sha1 -replace ":", ""
$bytes = [byte[]]::new($hex.Length / 2)
for ($i = 0; $i -lt $hex.Length; $i += 2) {
    $bytes[$i / 2] = [Convert]::ToByte($hex.Substring($i, 2), 16)
}
$keyHash = [Convert]::ToBase64String($bytes)
Write-Host "Facebook Key Hash: $keyHash"
