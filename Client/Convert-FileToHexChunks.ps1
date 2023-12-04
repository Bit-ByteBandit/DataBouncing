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
        $randomHexForFirstSegment = -join ((0..15) | Get-Random -Count (Get-Random -Minimum 8 -Maximum 17) | ForEach-Object { "{0:X}" -f $_ })

        # Randomly select a separator for the total number of segments
        $totalSeparator = 'H'
        $hexObject | Add-Member -MemberType NoteProperty -Name 1 -Value ($chunks.Count.ToString() + $totalSeparator + $randomHexForFirstSegment)

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
