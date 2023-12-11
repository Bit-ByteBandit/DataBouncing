function Regenerate {
    param (
        [string]$regex
    )

    function Find-Secret {
        param (
            [Parameter(Mandatory = $true)]
            [string]$FilePath,

            [Parameter(Mandatory = $true)]
            [string]$Regex
        )

        # Ensure the file exists
        if (-not (Test-Path $FilePath)) {
            Write-Error "File not found: $FilePath"
            return
        }


        # Initialize an array to hold matches
        $MatchesFound = @()

        # Read the file and process each line
        Get-Content $FilePath | ForEach-Object {
            if ($_ -match "$Regex\.([^\.]+)\.") {
                # Add matched string in uppercase
                $MatchesFound += $Matches[1].ToUpper()
            }
        }

        # Output unique matches only
        $MatchesFound | Select-Object -Unique

            # Read the file and process each line
    $content = Get-Content $FilePath | ForEach-Object {
        $line = $_
        if ($line -match "$Regex\.([^\.]+)\.") {
            # Skip lines with matches
            return $null
        } else {
            # Return lines without matches
            return $line
        }
    }

    # Output the modified content
    $content | Set-Content -Path $FilePath -Force
    }

    function Assemble-Instructions {
        param (
            [string]$FilePath
        )

        # Reading data from the file
        $data = Get-Content $FilePath

        # Splitting the data into lines by newlines
        $lines = $data -split "`r`n"

        foreach ($line in $lines) {
            if ($line -match "^j.*j$") {
                $instructions = $line
                break
            }
        }

        # Remove the leading and trailing 'J'
        $trimmedInstructions = $instructions.Trim('J')

        # Split the string by 'G', 'H', or 'I'
        $split = [regex]::Split($trimmedInstructions, '[GHI]')

        $numSegs   = [int]$split[0]
        $hexString = $split[1]
 #       $hexName   = $split[2]

        $ext      = Convert-HexToAscii $hexString
        $saveName = "${regex}."


        # Removing the first line (contains the total count, not needed for processing)
        $lines = $lines[1..($lines.Length - 1)]

        # Sorting the lines based on the number at the beginning
        $sortedLines = $lines | Sort-Object { [int]($_ -replace '[GHI].*$', '') }

        # Extracting and concatenating the strings without spaces
        $hexContent = ($sortedLines | ForEach-Object { $_ -replace '^[0-9]+[GHI]', '' }) -join ''
        $result = Convert-HexToAscii $hexContent

        return $result, $ext, $saveName, $numSegs
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

    $secrets = (Find-Secret -FilePath ./logs.txt -Regex $regex)
    $secrets | Out-File -FilePath ./raw.txt -Encoding UTF8

    $result, $ext, $saveName, $numSegs = Assemble-Instructions -FilePath ./raw.txt

    # Save the decoded content to a file with the extracted extension
    $result | Out-File -FilePath "$saveName$ext" -Encoding UTF8
}



function watchLogs {
    param (
        [string]$LogFilePath = "logs.txt",
        [string]$IdsFilePath = "file-IDs.txt"
    )

    while ($true) {
        # Check if the log file exists
        if (-Not (Test-Path $LogFilePath)) {
            Write-Host "Log file not found: $LogFilePath"
            return
        }

        # Check if the IDs file exists
        if (-Not (Test-Path $IdsFilePath)) {
            Write-Host "IDs file not found: $IdsFilePath"
            return
        }

        # Read the IDs file and split it into an array
        $fileContent = Get-Content $IdsFilePath
        $fileIds = $fileContent -split '\r?\n'

        # Read the log file
        $logFileContent = Get-Content $LogFilePath

        # Initialize variables
        $segments = $null
        $fileIdFound = $false

        # Search for each ID in the log file and capture the number of segments
        foreach ($fileid in $fileIds) {
            $pattern = "$fileid\.J(\d+)"
            foreach ($line in $logFileContent) {
                if ($line -match $pattern) {
                    $segments = $matches[1]
                    Write-Host "ID found: $fileid"
                    Write-Host "Found matching line: $line"
                    Write-Host "Captured number of segments: $segments"
                    $fileIdFound = $true
                    break
                }
            }
            if ($fileIdFound) {
                break
            }
        }

        if (-not $fileIdFound) {
            Write-Host "No ID found in the log file, checking again..."
            Start-Sleep -Seconds 10 # Optional: Delay before next check
            continue
        }

        # Initialize an array to keep track of found segments
        $foundSegments = @()

        # Check for each segment in a loop until all are found
        while ($foundSegments.Count -lt $segments) {
            for ($i = 1; $i -le $segments; $i++) {
                if ($i -notin $foundSegments) {
                    $logFileContent = Get-Content $LogFilePath
                    $segmentPattern = "$fileid\.$i"
                    $segmentFound = $logFileContent | Where-Object { $_ -match $segmentPattern }
                    if ($segmentFound) {
                        $foundSegments += $i
                        Write-Host "Segment $i found"
                    } else {
                        Write-Host "Segment $i not found, checking again..."
                    }
                }
                sleep 3
            }
        }

        Write-Host "All $segments segments have been found for ID $fileid."
        Recreate-Secrets -regex "$fileid"
    }
}


