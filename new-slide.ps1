$SCRIPT_DIR = $PSScriptRoot
$TEMPLATE_DIR = Join-Path $SCRIPT_DIR "slide_template"
$SLIDEV_VERSION = "52.15.0"

# --- Check template dir exists ---
if (-not (Test-Path $TEMPLATE_DIR)) {
    Write-Host "[ERROR] slide_template/ folder not found at: $TEMPLATE_DIR" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path (Join-Path $TEMPLATE_DIR "package.json"))) {
    Write-Host "[ERROR] package.json not found in slide_template/" -ForegroundColor Red
    exit 1
}

# --- Ask for project name ---
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Slidev - New slide creator" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[WARNING] Uppercase letters in the project name can cause issues with" -ForegroundColor Yellow
Write-Host "          Mermaid diagrams and other Slidev features on Windows." -ForegroundColor Yellow
Write-Host "          It is strongly recommended to use lowercase only." -ForegroundColor Yellow
Write-Host ""

$PROJECT_NAME = Read-Host "Project name"

if ([string]::IsNullOrWhiteSpace($PROJECT_NAME)) {
    Write-Host "[ERROR] Project name cannot be empty." -ForegroundColor Red
    exit 1
}

# --- Force lowercase ---
$PROJECT_NAME_LOWER = $PROJECT_NAME.ToLower()

if ($PROJECT_NAME -cne $PROJECT_NAME_LOWER) {
    Write-Host ""
    Write-Host "[WARNING] Your project name contains uppercase letters: '$PROJECT_NAME'" -ForegroundColor Yellow
    Write-Host "          It will be converted to: '$PROJECT_NAME_LOWER'" -ForegroundColor Yellow
    $CONFIRM = Read-Host "Continue with '$PROJECT_NAME_LOWER'? (y/n)"
    if ($CONFIRM -ne "y" -and $CONFIRM -ne "Y") {
        Write-Host "Aborted." -ForegroundColor Gray
        exit 0
    }
    $PROJECT_NAME = $PROJECT_NAME_LOWER
}

$TARGET_DIR = Join-Path $SCRIPT_DIR $PROJECT_NAME

# --- Check if folder already exists ---
if (Test-Path $TARGET_DIR) {
    Write-Host "[ERROR] Folder '$PROJECT_NAME' already exists." -ForegroundColor Red
    exit 1
}

# --- Scaffold via pnpm create slidev ---
Write-Host ""
Write-Host "Scaffolding Slidev $SLIDEV_VERSION..." -ForegroundColor Cyan
Set-Location $SCRIPT_DIR

pnpm create slidev@$SLIDEV_VERSION $PROJECT_NAME --no-install

if (-not (Test-Path $TARGET_DIR)) {
    Write-Host "[ERROR] Scaffold failed. Check pnpm create slidev output." -ForegroundColor Red
    exit 1
}

# --- Remove demo files ---
Write-Host ""
$CLEAN = Read-Host "Remove demo files (components/, snippets/, netlify.toml, vercel.json, slides.md)? (y/n)"
if ($CLEAN -eq "y" -or $CLEAN -eq "Y") {
    $demoItems = @("components", "snippets", "netlify.toml", "vercel.json", "slides.md")
    foreach ($item in $demoItems) {
        $itemPath = Join-Path $TARGET_DIR $item
        if (Test-Path $itemPath) {
            Remove-Item $itemPath -Recurse -Force
            Write-Host "  Removed: $item" -ForegroundColor Gray
        }
    }
}

# --- Copy slide_template contents ---
Write-Host "Copying slide_template contents..." -ForegroundColor Cyan
Copy-Item (Join-Path $TEMPLATE_DIR "*") -Destination $TARGET_DIR -Recurse -Force

# --- Update "name" field in package.json ---
$packageJsonPath = Join-Path $TARGET_DIR "package.json"
$packageJson = Get-Content $packageJsonPath -Raw
$packageJson = $packageJson -replace '"name":\s*"[^"]*"', "`"name`": `"$PROJECT_NAME`""
Set-Content $packageJsonPath $packageJson

# --- Install ---
Write-Host "Running pnpm install..." -ForegroundColor Cyan
Set-Location $TARGET_DIR
pnpm install

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] pnpm install failed." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host "  '$PROJECT_NAME' created successfully." -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""

# --- Optionally launch pnpm dev ---
$LAUNCH = Read-Host "Launch 'pnpm dev' now? (y/n)"
if ($LAUNCH -eq "y" -or $LAUNCH -eq "Y") {
    pnpm dev
}
