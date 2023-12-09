function recreate {
    param (
        [string]$regex
    )

	Function Find-secret {
	    Param (
	        [Parameter(Mandatory = $true)]
	        [string]$FilePath,
	
	        [Parameter(Mandatory = $true)]
	        [string]$Regex
	    )
	
	    # Ensure the file exists
	    If (-Not (Test-Path $FilePath)) {
	        Write-Error "File not found: $FilePath"
	        Return
	    }
	
	    # Initialize an array to hold matches
	    $MatchesFound = @()
	
	    # Read the file and process each line
	    Get-Content $FilePath | ForEach-Object {
	        If ($_ -Match "$Regex\.([^\.]+)\.") {
	            # Add matched string in uppercase
	            $MatchesFound += $Matches[1].ToUpper()
	        }
	    }
	
	    # Output unique matches only
	    $MatchesFound | Select-Object -Unique
	}
	
	
	
	function assemble {                              
	     param (
	         [string]$filePath
	     )
	 
	     # Reading data from the file
	     $data = Get-Content $filePath
	 
	     # Splitting the data into lines by newlines
	     $lines = $data -split "`r`n"

		foreach($line in $lines) {
		    if ($line -match "^j.*j$") {
		        $instructions = $line
		        break
		    }
		}


		# Remove the leading and trailing hyphens
		$trimmedInstructions = $instructions.Trim('J')
		
		# Split the string by 'G', 'H', or 'I'
		$split = [regex]::Split($trimmedInstructions, '[GHI]')
		
		$numSegs   = [int]$split[0]
		
		$hexString = $split[1]

		$hexName   = $split[2]

		$ext       = Convert-HexToAscii $hexString
		$saveName  = Convert-HexToAscii $hexName

  	     # Removing the first line (contains the total count, not needed for processing)
	     $lines = $lines[1..($lines.Length - 1)]
	 
	     # Sorting the lines based on the number at the beginning
	     $sortedLines = $lines | Sort-Object { [int]($_ -replace '[GHI].*$', '') }
	 
	     # Extracting and concatenating the strings without spaces
	     $hexContent = ($sortedLines | ForEach-Object { $_ -replace '^[0-9]+[GHI]', '' }) -join ''
	     $result = Convert-HexToAscii $hexContent 
  	     
	     return $result, $ext, $saveName
	 }
	 
	 
	function Convert-HexToAscii {
	    param (
	        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
	        [string]$HexInput
	    )
	
	    process {
	        # Split the hex string into chunks of two characters each
	        $hexPairs = $HexInput -split "(..)" | Where-Object { $_ }
	
	        # Convert each hex pair to its ASCII representation
	        $asciiString = $hexPairs | ForEach-Object {
	            [char][convert]::ToInt32($_, 16)
	        }
	
	        # Combine the ASCII characters into a single string
	        return -join $asciiString
	    }
	}

	
	$secrets = (find-secret -FilePath ./logs.txt -Regex '$regex') 
	$secrets > ./raw.txt
	
	$result, $ext, $saveName = assemble -filePath ./raw.txt
	
	#$decoded = convert-hexToAscii $rawHex

	# Save the decoded content to a file with the extracted extension
	$result | Out-File -FilePath "$saveName.$ext" -Encoding UTF8

}
