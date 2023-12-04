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

        for ($i = 0; $i -lt $chunks.Count; $i++) {
            # Add each chunk as a property to the object
            $hexObject | Add-Member -MemberType NoteProperty -Name ($i + 1) -Value $chunks[$i].Value
        }

        # Return the object
        return $hexObject
    }
    catch {
        Write-Error "An error occurred: $_"
    }
}

# Example usage:
# $hexObject = Convert-FileToHexChunks -FilePath "C:\path\to\your\file.txt"
# $hexObject
