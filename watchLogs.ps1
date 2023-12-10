import-module /root/DataBouncing/Server/watchLogs.ps1

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
                    $segmentPattern = "$fileid\.$i"
                    $segmentFound = $logFileContent | Where-Object { $_ -match $segmentPattern }
                    if ($segmentFound) {
                        $foundSegments += $i
                        Write-Host "Segment $i found"
                    } else {
                        Write-Host "Segment $i not found, checking again..."
                    }
                }
            }
        }

        Write-Host "All $segments segments have been found for ID $fileid."
        return
    }
}

