function Send-CustomRequest {
    param (
        [string]$Url,
        [string]$Domain
    )

    $headers = @{
        "Host" = "host.$Url.$Domain"
        "Accept" = "*/*"
        "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"
        "Origin" = "https://$Url"
        "X-Forwarded-For" = "xff.$Url.$Domain"
        "X-Wap-Profile" = "http://wafp.$Url.$Domain/wap.xml"
        "CF-Connecting_IP" = "cfcon.$Url.$Domain"
        "Contact" = "root@contact.$Url.$Domain"
        "X-Real-IP" = "rip.$Url.$Domain"
        "True-Client-IP" = "trip.$Url.$Domain"
        "X-Client-IP" = "xclip.$Url.$Domain"
        "Forwarded" = "for=ff.$Url.$Domain"
        "X-Originating-IP" = "origip.$Url.$Domain"
        "Client-IP" = "clip.$Url.$Domain"
        "Referer" = "ref.$Url.$Domain"
        "From" = "root@from.$Url.$Domain"
    }

    try {
        $response = Invoke-WebRequest -Uri $Url -Headers $headers
        return $response
    } catch {
        Write-Error "Error: $_"
    }
}
