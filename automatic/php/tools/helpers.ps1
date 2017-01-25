#TODO: Proxy
function UrlExists($uri) {
    try {
        $webClient =[System.Net.HttpWebRequest] [System.Net.WebRequest]::Create($uri)
        $webClient.Method = "HEAD"
        $webClient.Timeout = 3000
        $webClient.GetResponse()
    }
    catch [System.Net.WebException] {
        return $false;
    }
    return $true;
}

function AddArchivePathToUrl($url) {
    $newUrl = $url
    $lix = $url.LastIndexOf("/")
    if ($lix -ne -1)  {
        $newUrl = $url.SubString(0, $lix) + "/archives" + $url.SubString($lix)
    }
    return $newUrl
}

function GetDownloadInfo {
  param(
    [string]$downloadInfoFile,
    $parameters
  )
  Write-Debug "Reading CSV file from $downloadInfoFile"
  $downloadInfo = Get-Content -Encoding UTF8 -Path $downloadInfoFile | ConvertFrom-Csv -Delimiter '|' -Header 'Type','URL32','URL64','Checksum32','Checksum64'
  if ($parameters.ThreadSafe) {
    $downloadInfo | ? { $_.Type -eq 'threadsafe' } | select -first 1
  } else {
    $downloadInfo | ? { $_.Type -eq 'not-threadsafe' } | select -first 1
  }
}
