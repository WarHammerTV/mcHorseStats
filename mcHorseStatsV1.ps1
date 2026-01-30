# mcHorseStats V1.0.0
# W4rH4mm3r
# Work out potential breeding stasistics for horses in minecraft and Horse Datbase searcher

# Creating form and setting parameters
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()
$form = New-Object System.Windows.Forms.Form
$form.Text = "Horse Database Gen"
$form.Size = New-Object System.Drawing.Size(920,560)
$form.StartPosition = "CenterScreen"
$form.MaximizeBox = $false

# Breeding menu
$lblOut = New-Object System.Windows.Forms.Label
$lblOut.Location = New-Object System.Drawing.Point(12,90)
$lblOut.Size = New-Object System.Drawing.Size(80,20)
$lblOut.Text = "Output:"
$form.Controls.Add($lblOut)

$breederTitle = New-Object System.Windows.Forms.Label
$breederTitle.Location = New-Object System.Drawing.Point(12,5)
$breederTitle.Size = New-Object System.Drawing.Size(120,25)
$breederTitle.Text = "Breeding predictor"
$form.Controls.Add($breederTitle)

# Parent 2 combo box
$parent1select = New-Object System.Windows.Forms.ComboBox
$parent1select.Location = New-Object System.Drawing.Point(100,30)
$parent1select.Size = New-Object System.Drawing.Size(240,25)
$parent1select.DropDownStyle = 'DropDownList'
$form.Controls.Add($parent1select)

$csvData = Import-Csv ".\rawData.csv"
$csvData | ForEach-Object { 
    $parent1select.Items.Add($_.Name) | Out-Null
}

# Parent 2 combo box
$parent2select = New-Object System.Windows.Forms.ComboBox
$parent2select.Location = New-Object System.Drawing.Point(100,57)
$parent2select.Size = New-Object System.Drawing.Size(240,25)
$parent2select.DropDownStyle = 'DropDownList'   # Prevents typing / only selection
$form.Controls.Add($parent2select)

$csvData1 = Import-Csv ".\rawData.csv"
$csvData1 | ForEach-Object {
    $parent2select.Items.Add($_.Name) | Out-Null
}

$txtOutput = New-Object System.Windows.Forms.TextBox
$txtOutput.Location = New-Object System.Drawing.Point(12,115)
$txtOutput.Size = New-Object System.Drawing.Size(480,380)
$txtOutput.Multiline = $true
$txtOutput.ScrollBars = "Vertical"
$txtOutput.ReadOnly = $true
$form.Controls.Add($txtOutput)

# Adding buttons for control
$btnClear = New-Object System.Windows.Forms.Button
$btnClear.Location = New-Object System.Drawing.Point(370,47)
$btnClear.Size = New-Object System.Drawing.Size(110,30)
$btnClear.Text = "Clear Output"
$form.Controls.Add($btnClear)

$btnCompute = New-Object System.Windows.Forms.Button
$btnCompute.Location = New-Object System.Drawing.Point(370,10)
$btnCompute.Size = New-Object System.Drawing.Size(110,30)
$btnCompute.Text = "Compute"
$form.Controls.Add($btnCompute)

$btnLog = New-Object System.Windows.Forms.Button
$btnLog.Location = New-Object System.Drawing.Point(370,84)
$btnLog.Size = New-Object System.Drawing.Size(110,30)
$btnLog.Text = "Log File"
$form.Controls.Add($btnLog)

# Adding functions to button clicks
$btnClear.Add_Click({
    $txtOutput.Clear()})
$btnCompute.Add_Click({get-calculcation})
$btnLog.Add_Click({add-logfile})

# Functions for Horse Breeding Calculator
Function get-calculcation{
# Breeding Panel function

# Getting base stats of both Parents
$parent1 = $parent1select.Text
$parent2 = $parent2select.Text

$parent1Speed = [double]$parent1.Speed
$parent1Health = [double]$parent1.Health
$parent1Jump = [double]$parent1.Jump

$parent2Speed = [double]$parent2.speed
$parent2Health = [double]$parent2.Health
$parent2Jump = [double]$parent2.Jump


# Create random value
$randAvg = (
    (Get-Random -Minimum 0.0 -Maximum 1.0) +
    (Get-Random -Minimum 0.0 -Maximum 1.0) +
    (Get-Random -Minimum 0.0 -Maximum 1.0)
) / 3
Function get-Speed{
    # Getting potential speed of foal
$minSpeed = 0.1125
$maxSpeed = 0.3375

$baseSpeed = ([math]::Abs($parent1Speed - $parent2Speed) + ($maxSpeed - $minSpeed) * 0.3) * ($randAvg - 0.5) + ($parent1Speed + $parent2Speed) / 2

if ($baseSpeed -gt $maxSpeed) { $baseSpeed = 2 * $maxSpeed - $baseSpeed }
if ($baseSpeed -lt $minSpeed) { $baseSpeed = 2 * $minSpeed - $baseSpeed }
$RoundedSpeed = [Math]::Round($baseSpeed, 4)
Return $RoundedSpeed
}

Function get-Health{
# Getting Potential Health for foal
$minHealth = 15
$maxHealth = 30

$baseHealth = ([math]::Abs($parent1Health - $parent2Health) + ($maxHealth - $minHealth) * 0.3) * ($randAvg - 0.5) + ($parent1Health + $parent2Health) / 2
if ($baseHealth -gt $maxHealth) { $baseHealth = 2 * $maxHealth - $baseHealth }
if ($baseHealth -lt $minHealth) { $baseHealth = 2 * $minHealth - $baseHealth }

$RoundedHealth = [Math]::Round($baseHealth, 4)
Return $RoundedHealth
}

Function Get-Jump{
# Getting potential Jump Height for foal
$minJump = 0.4
$maxJump = 1.0

$baseJump = ([math]::Abs($parent1Jump - $parent2Jump) + ($maxJump - $minJump) * 0.3) * ($randAvg - 0.5) + ($parent1Jump + $parent2Jump) / 2
if ($baseJump -gt $maxJump) { $baseJump = 2 * $maxJump - $baseJump }
if ($baseJump -lt $minJump) { $baseJump = 2 * $minJump - $baseJump }
$RoundedJump = [Math]::Round($baseJump, 4)
Return $RoundedJump
}

# Getting foal stats using functions
$newSpeed = get-Speed
$newHealth = get-Health
$newJump = get-Jump



# Writing data to output box
Write-OutputBox -text "Calculating Foal Stats..." 
Write-OutputBox -text "***************************
          Foal Stats
Speed: $newSpeed
Health: $newHealth
Jump: $newJump
----------------------------
Parent 1: $parent1
Parent 2: $parent2
***************************"

}

# Horse Database Search 

# Database search Title
$ViewerTitle = New-Object System.Windows.Forms.Label
$ViewerTitle.Location = New-Object System.Drawing.Point(498,5)
$ViewerTitle.Size = New-Object System.Drawing.Size(120,25)
$ViewerTitle.Text = "Horse Viewer"
$form.Controls.Add($ViewerTitle)

# Database dropdown
$databaseSearch = New-Object System.Windows.Forms.ComboBox
$databaseSearch.Location = New-Object System.Drawing.Point(500,35)
$databaseSearch.Size = New-Object System.Drawing.Size(240,25)
$databaseSearch.DropDownStyle = 'DropDownList'   # Prevents typing / only selection
$form.Controls.Add($databaseSearch)

# Adding values to databseSearch Dropdown
$databaseData = Import-Csv ".\rawData.csv"
$databaseData | ForEach-Object { 
    $databaseSearch.Items.Add($_.Name) | Out-Null
} 

$pictureBox_logo = New-Object Windows.Forms.PictureBox
$pictureBox_logo.Location = New-Object System.Drawing.Size(500,60)
$pictureBox_logo.Size = New-Object System.Drawing.Size(250,250)
$pictureBox_logo.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
$form.Controls.Add($pictureBox_logo)

$txtSpeed = New-Object System.Windows.Forms.Label
$txtSpeed.Location = New-Object System.Drawing.Point(770,50)
$txtSpeed.Size = New-Object System.Drawing.Size(120,25)
$form.Controls.Add($txtSpeed)

$txtHealth = New-Object System.Windows.Forms.Label
$txtHealth.Location = New-Object System.Drawing.Point(770,80)
$txtHealth.Size = New-Object System.Drawing.Size(120,25)
$form.Controls.Add($txtHealth)

$txtJump = New-Object System.Windows.Forms.Label
$txtJump.Location = New-Object System.Drawing.Point(770,120)
$txtJump.Size = New-Object System.Drawing.Size(120,25)
$form.Controls.Add($txtJump)

$txtParent1 = New-Object System.Windows.Forms.Label
$txtParent1.Location = New-Object System.Drawing.Point(770,150)
$txtParent1.Size = New-Object System.Drawing.Size(120,25)
$form.Controls.Add($txtParent1)

$txtParent2 = New-Object System.Windows.Forms.Label
$txtParent2.Location = New-Object System.Drawing.Point(770,190)
$txtParent2.Size = New-Object System.Drawing.Size(120,25)
$form.Controls.Add($txtParent2)

$txtLocation = New-Object System.Windows.Forms.Label
$txtLocation.Location = New-Object System.Drawing.Point(770,220)
$txtLocation.Size = New-Object System.Drawing.Size(120,25)
$form.Controls.Add($txtLocation)


# Load horse image based on ComboBox selection
function Update-HorseImage {
    param([string]$selectedName)

    # Find the full CSV record matching the selected horse
    $record = $databaseData | Where-Object { $_.Name -eq $selectedName }

    if (-not $record) {
        return
    }

    $filepath = $record.Asset

    if (-not (Test-Path $filepath)) {
        return
    }

    try {
        # Dispose of any existing image to avoid file-lock issues
        if ($pictureBox_logo.Image) {
            $pictureBox_logo.Image.Dispose()
            $pictureBox_logo.Image = $null
        }

        # Load and show the new image
        $img = [System.Drawing.Image]::FromFile($filepath)
        $pictureBox_logo.Image = $img
    }
    catch {
    }
}

# Functions to display selected horse stats
Function get-horsebase {
    param([string]$selectedName)
    $stats = ($databaseData | Where-Object { $_.Name -eq $selectedName }) | Select-Object -First 1

    if (-not $stats) {
        return
    }
# Avg values for calculating
    $avgJump = 0.7
    $avgHealth = 11.5
    $avgSpeed = 9.49
# Calculating speed in m/s
$baseSpeed = [double]$stats.Speed
$blockSpeed = $baseSpeed * 42.16
$roundedBlockSpeed =[Math]::Round($blockSpeed, 2)

# Calculating Health in hearts
$baseHealth = [double]$stats.Health
$roundedHealth = [math]::Round($baseHealth, 0)
$hearts = $roundedHealth / 2

    # Adding info to database panel
    $txtSpeed.Text  = "Speed:  $($roundedBlockSpeed)m/s"
    $txtHealth.Text = "Health: $($hearts) Hearts"
    $txtJump.Text   = "Jump: $($stats.Jump)"
    $txtParent1.Text = "Parent 1: $($stats.Parent1)"
    $txtParent2.Text = "Parent 2: $($stats.Parent2)"
    $txtLocation.Text = "Location: $($stats.Location)"


    # Checking Speed against avg to set colour
    if ($roundedBlockSpeed -gt $avgSpeed){$txtSpeed.ForeColor = "Green"}
    elseif($roundedBlockSpeed -lt $avgSpeed){$txtSpeed.ForeColor = "Red"}
    # Checking hearts against avg to set colour
    if ($hearts -gt $avgHealth){$txtHealth.ForeColor = "Green"}
    elseif($hearts -lt $avgHealth){$txtHealth.ForeColor = "Red"}
    # Checking jump height against avg to set colour
    if ($stats.Jump -gt $avgJump){$txtJump.ForeColor = "Green"}
    elseif($stats.Jump -lt $avgJump){$txtJump.ForeColor = "Red"}
}

# Update the image when selection box selection changed
$databaseSearch.Add_SelectedIndexChanged({
    $selectedName = $databaseSearch.SelectedItem
    Update-HorseImage -selectedName $selectedName
    get-horsebase -selectedName $selectedName
})

# Horse Database viewer
# Creating button and adding function to button click
$btnDataView = New-Object System.Windows.Forms.Button
$btnDataView.Location = New-Object System.Drawing.Point(500,310)
$btnDataView.Size = New-Object System.Drawing.Size(100,40)
$btnDataView.Text = "View Database"
$form.Controls.Add($btnDataView)

# Function to view database as gridview
function Open-Database{
    $tableData = Import-Csv ".\rawData.csv" 
    $tableData | Out-GridView
}
$btnDataView.Add_Click({Open-Database})


# Script functions
function Write-OutputBox {
# Writing to in Application output box
    param([string]$text)
    if ($txtOutput.InvokeRequired) {
        $txtOutput.Invoke([action]{ param($s) $txtOutput.AppendText($s + [Environment]::NewLine) }, $text) | Out-Null
    } else {
        $txtOutput.AppendText($text + [Environment]::NewLine)
    }
}


Function add-logfile {
# Creation of a logfile with text from output box
$outputtext = $txtOutput.Text
$datetime = get-date -Format "MM-dd-yyyy-HH-mm-ss"
New-Item -Path ".\saved\$datetime.txt" -Value $outputtext
Write-OutputBox "Log file saved: C:\Projects\horseStats\V3\saved\$datetime.txt"
}


# Launch form
[void]$form.ShowDialog()
