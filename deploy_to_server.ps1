# Configuration
$GODOT_PATH = "C:\Users\wes\Documents\windev\Godot_v4.3-stable_win64.exe"
$PROJECT_PATH = "C:\Users\wes\Documents\windev\breach-vector\project.godot"
$BUILD_PATH = "C:\Users\wes\Documents\windev\breach-vector\output\web"
$REMOTE_SERVER = "blog"
$REMOTE_PATH = "/home/wes/blog/games"
# $PROJECT_NAME = "breach-vector"  # production name
# $PROJECT_NAME = "breach-vector-dev"  # dev name
$PROJECT_NAME = "breach-vector-day4"  # daily name

# Remove existing build directory if it exists
if (Test-Path $BUILD_PATH) {
   Write-Host "[*] Removing existing build directory..."
   Remove-Item -Path $BUILD_PATH -Recurse -Force
}

# Create fresh build directory
New-Item -ItemType Directory -Force -Path $BUILD_PATH

# Build the web export
Write-Host "[*] Building web export..."
$buildProcess = Start-Process -FilePath $GODOT_PATH -ArgumentList "--headless", "--export-release", "Web", "$BUILD_PATH\$PROJECT_NAME.html", $PROJECT_PATH -NoNewWindow -PassThru -Wait

if ($buildProcess.ExitCode -eq 0) {
   Write-Host "[*] Build successful, deploying to server..."
   
   # Convert Windows path to WSL path format
   $wslSource = $BUILD_PATH -replace "\\", "/"
   $wslSource = $wslSource -replace "C:", "/mnt/c"
   
   # Execute rsync command through WSL
   wsl rsync -avz --delete --include="${PROJECT_NAME}.*" --exclude="*" "${wslSource}/" "${REMOTE_SERVER}:${REMOTE_PATH}/"
   
   Write-Host
   Write-Host "[*] Deployment for '$PROJECT_NAME' complete!"
} else {
   Write-Host
   Write-Host "[!] Build failed with exit code: $($buildProcess.ExitCode)"
   exit 1
}