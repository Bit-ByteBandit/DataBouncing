function watchLogs {
    param (
        [string]$LogFilePath = "logs.txt",
        [string]$IdsFilePath = "file-IDs.txt"
    )

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

    # Check each ID in the log file
    foreach ($id in $fileIds) {
        if ($logFileContent -match $id) {
            Write-Host "ID found in log file: $id"
            recreate -regex "$id"
        } else {
            #Write-Host "ID not found in log file: $id"
        }
    }
}

# Example usage of the function
Check-LogFile
