import-module /root/Find-secret.ps1
import-module /root/Convert-HexToAscii.ps1
Convert-HexToAscii (find-secret -FilePath ./logs.txt -XRegex 'xregex') > raw.txt
