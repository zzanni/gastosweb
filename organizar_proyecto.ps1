# Script para organizar el proyecto GastosWeb
Write-Host "Iniciando organización del proyecto..." -ForegroundColor Cyan

# 1. Crear estructura de carpetas
$folders = @(
    "web",
    "web/assets",
    "web/js",
    "web/css",
    "android",
    "keystore",
    ".github/workflows"
)

foreach ($folder in $folders) {
    $path = Join-Path -Path $PSScriptRoot -ChildPath $folder
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
        Write-Host "Creada carpeta: $folder" -ForegroundColor Green
    }
}

# 2. Mover archivos a la carpeta web
$moves = @{
    "index.html" = "web/"
    "manifest.json" = "web/"
    "sw.js" = "web/"
    "screenshot1.png" = "web/"
}

foreach ($file in $moves.GetEnumerator()) {
    $source = Join-Path -Path $PSScriptRoot -ChildPath $file.Key
    $destination = Join-Path -Path $PSScriptRoot -ChildPath $file.Value
    
    if (Test-Path $source -PathType Leaf) {
        Move-Item -Path $source -Destination $destination -Force -ErrorAction SilentlyContinue
        Write-Host "Movido: $($file.Key) -> $($file.Value)" -ForegroundColor Yellow
    }
}

# 3. Mover archivos de assets
$assetsSource = Join-Path -Path $PSScriptRoot -ChildPath "assets"
$assetsDest = Join-Path -Path $PSScriptRoot -ChildPath "web/assets"

if (Test-Path $assetsSource) {
    Get-ChildItem -Path $assetsSource | ForEach-Object {
        $destFile = Join-Path -Path $assetsDest -ChildPath $_.Name
        if (-not (Test-Path $destFile)) {
            Move-Item -Path $_.FullName -Destination $assetsDest -Force -ErrorAction SilentlyContinue
            Write-Host "Movido: assets/$($_.Name) -> web/assets/" -ForegroundColor Yellow
        }
    }
}

# 4. Crear archivos de configuración
$gitignoreContent = @"
# Dependencias
node_modules/

# Android
android/
.idea/
*.iml
*.keystore
keystore/

# Archivos del sistema
.DS_Store
Thumbs.db

# Variables de entorno
.env
.env.local
.env.*.local

# Logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Editor
.vscode/
"@

$gitignorePath = Join-Path -Path $PSScriptRoot -ChildPath ".gitignore"
if (-not (Test-Path $gitignorePath)) {
    $gitignoreContent | Out-File -FilePath $gitignorePath -Encoding utf8
    Write-Host "Creado archivo .gitignore" -ForegroundColor Green
}

# 5. Crear package.json básico
$packageJson = @{
    name = "cuanto-gastamos"
    version = "1.0.0"
    description = "Aplicación para dividir gastos entre amigos"
    main = "index.js"
    scripts = @{
        build = "echo 'Build script'"
        test = "echo 'Test script'"
        android = "npx cap sync android && npx cap open android"
    }
    keywords = @("gastos", "división", "pwa", "android")
    author = "Tu Nombre"
    license = "MIT"
    dependencies = @{}
    devDependencies = @{
        "@capacitor/cli" = "^5.0.0"
        "@capacitor/core" = "^5.0.0"
        "@capacitor/android" = "^5.0.0"
    }
} | ConvertTo-Json -Depth 10

$packageJsonPath = Join-Path -Path $PSScriptRoot -ChildPath "package.json"
if (-not (Test-Path $packageJsonPath)) {
    $packageJson | Out-File -FilePath $packageJsonPath -Encoding utf8
    Write-Host "Creado archivo package.json" -ForegroundColor Green
}

Write-Host "`n¡Estructura del proyecto organizada con éxito!" -ForegroundColor Green
Write-Host "Ahora puedes ejecutar 'npm install' para instalar las dependencias." -ForegroundColor Cyan
Write-Host "Luego ejecuta 'npm run android' para abrir el proyecto en Android Studio." -ForegroundColor Cyan
