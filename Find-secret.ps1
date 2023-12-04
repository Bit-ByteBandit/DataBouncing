Function Find-secret {
    Param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [Parameter(Mandatory = $true)]
        [string]$XRegex
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
        If ($_ -Match "$XRegex\.([^\.]+)\.") {
            # Add matched string in uppercase
            $MatchesFound += $Matches[1].ToUpper()
        }
    }

    # Output unique matches only
    $MatchesFound | Select-Object -Unique
}
