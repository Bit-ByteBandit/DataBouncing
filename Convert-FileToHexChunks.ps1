function Convert-FileToHexChunks {
    param(
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )

    try {
        # Read the file as a byte array
        $bytes = [System.IO.File]::ReadAllBytes($FilePath)

        # Convert each byte to hexadecimal and join them into a string
        $hexString = ($bytes | ForEach-Object { "{0:X2}" -f $_ }) -join ''

        # Split the hex string into chunks of 16 characters
        $chunks = [Regex]::Matches($hexString, '.{1,16}')

        # Create a PSObject to store the chunks
        $hexObject = New-Object PSObject

        # Randomly select a separator for the total number of segments
        $totalSeparator = Get-Random -InputObject @('G', 'H', 'I')
        $hexObject | Add-Member -MemberType NoteProperty -Name 1 -Value ($chunks.Count.ToString() + $totalSeparator)

        for ($i = 0; $i -lt $chunks.Count; $i++) {
            # Randomly select a separator from G, H, I for each chunk
            $separator = Get-Random -InputObject @('G', 'H', 'I')

            # Add each chunk as a property to the object
            # Prepend each chunk with its segment number and a random separator
            $segmentLabel = ($i + 1).ToString() + $separator
            $hexObject | Add-Member -MemberType NoteProperty -Name ($i + 2) -Value ($segmentLabel + $chunks[$i].Value)
        }

        # Return the object
        return $hexObject
    }
    catch {
        Write-Error "An error occurred: $_"
    }
}
