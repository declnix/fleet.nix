$Distro = "NixOS"
$HostName = "c4rg0x"
$InstallDir = "$env:LOCALAPPDATA\WSL\$Distro"
$BackupDir = "$env:USERPROFILE\wsl-backups"
$Backup = "$BackupDir\$Distro-$(Get-Date -Format yyyyMMdd-HHmmss).tar"
$Installer = "$env:TEMP\nixos.wsl"
$Repo = "https://github.com/declnix/nix-config.git"
$ConfigDir = "/home/nixos/.config/nix"
$CertDir = "$env:TEMP\zscaler-certs"

New-Item -ItemType Directory -Force $BackupDir | Out-Null
New-Item -ItemType Directory -Force $CertDir | Out-Null

wsl --shutdown

Write-Host "Exporting $Distro to $Backup"
wsl --export $Distro $Backup
if ($LASTEXITCODE -ne 0) {
  throw "Failed to export $Distro. Aborting before unregister."
}

$confirmation = Read-Host "Backup created. Type UNREGISTER to delete and reinstall $Distro"
if ($confirmation -ne "UNREGISTER") {
  throw "Aborted."
}

wsl --unregister $Distro
if ($LASTEXITCODE -ne 0) {
  throw "Failed to unregister $Distro."
}

Remove-Item -Recurse -Force $InstallDir -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force $InstallDir | Out-Null

Invoke-WebRequest `
  -Uri "https://github.com/nix-community/NixOS-WSL/releases/latest/download/nixos.wsl" `
  -OutFile $Installer

wsl --install --from-file $Installer --name $Distro --location $InstallDir
if ($LASTEXITCODE -ne 0) {
  Write-Host "wsl --install --from-file failed; falling back to wsl --import"
  wsl --import $Distro $InstallDir $Installer --version 2
}
if ($LASTEXITCODE -ne 0) {
  throw "Failed to install $Distro."
}

Get-ChildItem Cert:\CurrentUser\Root, Cert:\LocalMachine\Root |
  Where-Object { $_.Subject -match "Zscaler|Zscaler Root|Zscaler Intermediate" } |
  ForEach-Object {
    Export-Certificate `
      -Cert $_ `
      -FilePath "$CertDir\$($_.Thumbprint).cer" `
      -Type CERT | Out-Null
  }

wsl -d $Distro -u root -- mkdir -p /etc/ssl/certs /tmp/zscaler-certs
wsl -d $Distro -u root -- bash -lc "rm -f /tmp/zscaler-certs/*"

$CertDirWsl = (wsl -d $Distro -u root -- wslpath -a "$CertDir").Trim()
wsl -d $Distro -u root -- bash -lc "cp '$CertDirWsl'/*.cer /tmp/zscaler-certs/ 2>/dev/null || true"

wsl -d $Distro -u root -- bash -lc @'
for cert in /tmp/zscaler-certs/*.cer; do
  [ -e "$cert" ] || continue
  name="$(basename "$cert" .cer)"
  openssl x509 -inform DER -in "$cert" -out "/etc/ssl/certs/$name.pem" 2>/dev/null ||
    cp "$cert" "/etc/ssl/certs/$name.pem"
done
cat /etc/ssl/certs/*.pem > /etc/ssl/certs/ca-certificates.crt
'@

wsl -d $Distro -u root -- bash -lc "mkdir -p /home/nixos/.config && chown -R nixos:users /home/nixos/.config"

wsl -d $Distro --cd /home/nixos -- bash -lc `
  "NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt nix --extra-experimental-features 'nix-command flakes' shell nixpkgs#git -c git clone $Repo $ConfigDir"
if ($LASTEXITCODE -ne 0) {
  throw "Failed to clone $Repo."
}

wsl -d $Distro -u root -- bash -lc `
  "NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt nixos-rebuild switch --flake $ConfigDir#$HostName"
if ($LASTEXITCODE -ne 0) {
  throw "nixos-rebuild switch failed."
}

wsl --shutdown
wsl -d $Distro
