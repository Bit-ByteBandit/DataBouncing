function Convert-ToBase32AndStoreSegments {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )

    # Function to convert to Base32
    function Convert-ToBase32 {
        param([byte[]]$bytes)
        $base32Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
        $result = ''

        for ($i = 0; $i -lt $bytes.Length; $i += 5) {
            $byteArray = @($bytes[$i], 0, 0, 0, 0)
            if ($i + 1 -lt $bytes.Length) { $byteArray[1] = $bytes[$i + 1] }
            if ($i + 2 -lt $bytes.Length) { $byteArray[2] = $bytes[$i + 2] }
            if ($i + 3 -lt $bytes.Length) { $byteArray[3] = $bytes[$i + 3] }
            if ($i + 4 -lt $bytes.Length) { $byteArray[4] = $bytes[$i + 4] }

            $index1 = [math]::Floor($byteArray[0] / 8)
            $index2 = [math]::Floor((($byteArray[0] % 8) * 4) + ($byteArray[1] / 64))
            $index3 = [math]::Floor((($byteArray[1] % 64) / 2))
            $index4 = [math]::Floor((($byteArray[1] % 2) * 16) + ($byteArray[2] / 16))
            $index5 = [math]::Floor((($byteArray[2] % 16) * 2) + ($byteArray[3] / 128))
            $index6 = [math]::Floor((($byteArray[3] % 128) / 8))
            $index7 = [math]::Floor((($byteArray[3] % 8) * 4) + ($byteArray[4] / 64))
            $index8 = [math]::Floor($byteArray[4] % 64)

            $result += $base32Chars[$index1] + $base32Chars[$index2] + $base32Chars[$index3] + $base32Chars[$index4] + 
                       $base32Chars[$index5] + $base32Chars[$index6] + $base32Chars[$index7] + $base32Chars[$index8]
        }
        
        return $result.TrimEnd("A")
    }

    # Check if the file exists
    if (Test-Path $FilePath) {
        try {
            # Read the file as bytes
            $bytes = [System.IO.File]::ReadAllBytes($FilePath)
            
            # Convert to Base32
            $base32 = Convert-ToBase32 -bytes $bytes

            # Output the Base32 string
            Write-Output "Base32 String:"
            Write-Output $base32

            # Prepare an object to store segments
            $segmentsObject = New-Object PSObject

            # Calculate the number of segments
            $numSegments = [math]::Ceiling($base32.Length / 16)

            # Store the number of segments as the first segment
            $segmentsObject | Add-Member -MemberType NoteProperty -Name "1" -Value "$numSegments"

            # Split the base32 string into 16-character segments
            $segmentIndex = 2
            for ($i = 0; $i -lt $base32.Length; $i += 16) {
                $segment = $base32.Substring($i, [Math]::Min(16, $base32.Length - $i))
                $segmentsObject | Add-Member -MemberType NoteProperty -Name "$segmentIndex" -Value $segment
                $segmentIndex++
            }

            # Output the segments object
            Write-Output "Segments:"
            $segmentsObject
        }
        catch {
            Write-Error "Error occurred while processing the file."
        }
    } else {
        Write-Error "File not found: $FilePath"
    }
}
