<#
.SYNOPSIS
    Pulls Docker images for a specified platform (linux/arm64) and saves them as .tar files.

.DESCRIPTION
    This script reads the Ansible inventory file to determine which Docker images and tags to download.
    It then pulls the arm64 version of each image, saves it as a .tar archive, and names it
    according to the convention required by the Ansible roles.

.NOTES
    - Requires Docker Desktop for Windows running with the WSL 2 backend.
    - Run this script from the 'ansible-deployment' directory.
#>

param(
    [string]$InventoryFile = "./inventory.ini",
    [string]$OutputDir = "./docker_images_arm64",
    [string]$Platform = "linux/arm64"
)

# --- Script Start ---

Write-Host "================================================="
Write-Host "Docker ARM64 Image Packaging Script"
Write-Host "================================================="

# 1. Create Output Directory if it doesn't exist
if (-not (Test-Path -Path $OutputDir)) {
    Write-Host "Creating output directory: $OutputDir"
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

# 2. Parse Inventory File to get image specifications
Write-Host "Reading image list from: $InventoryFile"
$imageSpecs = @{}
try {
    Get-Content $InventoryFile | ForEach-Object {
        if ($_ -match '(\w+)_image_(repo|tag):\s*(.*)') {
            $component = $matches[1]
            $key = $matches[2]
            $value = $matches[3].Trim().Trim('"')

            if (-not $imageSpecs.ContainsKey($component)) {
                $imageSpecs[$component] = @{ }
            }
            $imageSpecs[$component][$key] = $value
        }
    }
}
catch {
    Write-Error "Failed to read or parse inventory file '$InventoryFile'. Error: $_"
    exit 1
}

# 3. Process each image
foreach ($component in $imageSpecs.Keys) {
    $spec = $imageSpecs[$component]
    if ($spec.repo -and $spec.tag) {
        $imageName = "$($spec.repo):$($spec.tag)"
        $safeRepoName = $spec.repo.Replace('/', '_')
        $outputFile = Join-Path -Path $OutputDir -ChildPath "${safeRepoName}-${spec.tag}.tar"

        Write-Host "-------------------------------------------------"
        Write-Host "Processing: $imageName"
        Write-Host "Target Platform: $Platform"
        Write-Host "Output File: $outputFile"
        Write-Host "-------------------------------------------------"

        try {
            # Pull the image for the specified platform
            Write-Host "STEP 1/2: Pulling image..."
            docker pull --platform $Platform $imageName
            if ($LASTEXITCODE -ne 0) { throw "Docker pull failed." }

            # Save the image to a .tar file
            Write-Host "STEP 2/2: Saving image to .tar file..."
            docker save -o $outputFile $imageName
            if ($LASTEXITCODE -ne 0) { throw "Docker save failed." }

            Write-Host "[SUCCESS] Successfully packaged $imageName" -ForegroundColor Green
        }
        catch {
            Write-Error "Failed to process '$imageName'. Please check the image name, tag, and your internet connection. Error: $_"
        }
    }
}

Write-Host "================================================="
Write-Host "Script finished."
Write-Host "All packaged images are located in the '$OutputDir' directory."
Write-Host "IMPORTANT: Please move the generated .tar files to './files/docker-images/' for the Ansible playbook to use." -ForegroundColor Yellow
Write-Host "=================================================" 