# Define the directory containing the Nmap output files
$directory = "C:\Path\To\Nmap\Outputs"

# Define the IIS versions to look for
$iisVersions = @("Microsoft IIS httpd 8.5", "Microsoft IIS httpd 10.0", "Microsoft IIS httpd 7.0")

# Initialize a hash table to store results
$results = @{}

# Add each IIS version as a key in the hash table
foreach ($version in $iisVersions) {
    $results[$version] = @()
}

# Get all text files in the specified directory
$nmapFiles = Get-ChildItem -Path $directory -Filter *.txt

# Function to extract hostname and check for IIS version
function Check-IISVersion {
    param (
        [string]$fileContent,
        [string[]]$versions
    )

    # Extract hostname (assuming it starts with "Nmap scan report for" and ends with newline)
    $hostnameRegex = "Nmap scan report for ([^\r\n]+)"
    $matches = [regex]::Matches($fileContent, $hostnameRegex)

    foreach ($match in $matches) {
        $hostname = $match.Groups[1].Value

        # Check for each IIS version
        foreach ($version in $versions) {
            if ($fileContent -match [regex]::Escape($version)) {
                $results[$version] += $hostname
            }
        }
    }
}

# Process each file
foreach ($file in $nmapFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    Check-IISVersion -fileContent $content -versions $iisVersions
}

# Output the results
foreach ($version in $iisVersions) {
    Write-Output "Hosts with $version:"
    $results[$version] | ForEach-Object { Write-Output " - $_" }
    Write-Output ""
}