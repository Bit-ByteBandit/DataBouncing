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
