# This Package is inspired by
#   proudcanadianeh - uBlock Origin for Firefox
#   doc - adblockplus-firefox
# Thanks for that!

$packageName= 'umatrix-firefox'
$url        = 'https://addons.cdn.mozilla.net/user-media/addons/613250/umatrix-1.4.0-an+fx.xpi?filehash=sha256%3A991f0fa5c64172b8a2bc0a010af60743eba1c18078c490348e1c6631882cbfc7'
$extensionName = "uMatrix0@raymondhill.net.xpi"
$extensionFileName = "{915f22d0-2e5d-4443-a915-08086bb194fd}.xpi"


# For deploying Firefox Addons the Filename has to be "<extension_specific_id>.xpi"
# in all other cases Firefox ignores xpi file

# Install the Extension on Reference Machine
# open about:memory (Firefox)
# Section "Show memory reports" click on "Measure"
# Search for Addon Name -> there should be an entry with extension id="<extension_specific_id>"


#Find Firefox install location
if(test-path 'hklm:\SOFTWARE\Mozilla\Firefox\TaskBarIDs'){
  $installDir = Get-Item -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Mozilla\Firefox\TaskBarIDs | Select-Object -ExpandProperty Property
    Write-Output "Install Path located via Registry"
}elseif(test-path 'hklm:\SOFTWARE\Wow6432Node\Mozilla\Firefox\TaskBarIDs'){
  $installDir = Get-Item -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Mozilla\Firefox\TaskBarIDs | Select-Object -ExpandProperty Property
    Write-Output "Install path found via Wow6432Node in the registry"
}else{
	throw "Firefox install not detected"
}

#Generate path for copy
$browserFolder = Join-Path $installDir "browser"
$extensionsFolder = Join-Path $browserFolder "extensions"
$extFile = Join-Path $extensionsFolder "$extensionFileName"

#Check to see if process running
$isrunning = Get-Process -Name firefox -ErrorAction SilentlyContinue
if ($isrunning){
    throw "Firefox running"
}

#Copy to Firefox system extensions folder
Write-Output "Preparing to install to path $extFile"
try {
    Get-ChocolateyWebFile -PackageName $packageName -FileFullPath "$extFile" -url $url -ForceDownload
 }catch{
    Write-Output "Error occured, fail to copy file."
 }
