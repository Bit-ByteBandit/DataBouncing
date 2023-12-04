function Convert-FromBase32ToAscii {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Base32String
    )

    $base32Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
    $output = New-Object System.Collections.ArrayList
    $bitBuffer = 0
    $currentBits = 0

    foreach ($c in $Base32String.ToCharArray()) {
        $index = $base32Chars.IndexOf($c)
        if ($index -lt 0) {
            continue
        }

        $bitBuffer = ($bitBuffer -shl 5) -bor $index
        $currentBits += 5

        if ($currentBits -ge 8) {
            $output.Add([byte](($bitBuffer -shr ($currentBits - 8)) -band 0xFF)) > $null
            $currentBits -= 8
        }
    }

    # Convert byte array to ASCII string
    return [System.Text.Encoding]::ASCII.GetString($output.ToArray())
}
