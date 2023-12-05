function assemble {                              
     param (
         [string]$filePath
     )
 
     # Reading data from the file
     $data = Get-Content $filePath
 
     # Splitting the data into lines by newlines
     $lines = $data -split "`r`n"
 
     # Removing the first line (contains the total count, not needed for processing)
     $lines = $lines[1..($lines.Length - 1)]
 
     # Sorting the lines based on the number at the beginning
     $sortedLines = $lines | Sort-Object { [int]($_ -replace '[GHI].*$', '') }
 
     # Extracting and concatenating the strings without spaces
     $result = ($sortedLines | ForEach-Object { $_ -replace '^[0-9]+[GHI]', '' }) -join ''
 
     return $result
 }
