function Send-CustomRequest {
    param (
        [string]$Url,
        [string]$Domain
    )

    $headers = @{
        "Host" = "host.Adobe.com.$Domain"
        "Accept" = "*/*"
        "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"
        "Origin" = "https://Adobe.com"
        "X-Forwarded-For" = "xff.Adobe.com.$Domain"
        "X-Wap-Profile" = "http://wafp.Adobe.com.$Domain/wap.xml"
        "CF-Connecting_IP" = "cfcon.Adobe.com.$Domain"
        "Contact" = "root@contact.Adobe.com.$Domain"
        "X-Real-IP" = "rip.Adobe.com.$Domain"
        "True-Client-IP" = "trip.Adobe.com.$Domain"
        "X-Client-IP" = "xclip.Adobe.com.$Domain"
        "Forwarded" = "for=ff.Adobe.com.$Domain"
        "X-Originating-IP" = "origip.Adobe.com.$Domain"
        "Client-IP" = "clip.Adobe.com.$Domain"
        "Referer" = "ref.Adobe.com.$Domain"
        "From" = "root@from.Adobe.com.$Domain"
        "Test" = "cookies"
    }

    try {
        $response = Invoke-WebRequest -Uri $Url -Headers $headers
        return $response
    } catch {
        Write-Error "Error: $_"
    }
}
