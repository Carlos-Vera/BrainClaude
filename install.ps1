# ============================================================
#  Instalador NotebookLM Skill para Claude Code (Windows)
#  por Carlos Vera
#
#  Uso (PowerShell):
#    irm https://raw.githubusercontent.com/Carlos-Vera/BrainClaude/main/install.ps1 | iex
#
#  Instala Python de forma aislada con uv (sin admin), deja la CLI
#  notebooklm-py lista y copia las skills en ~/.claude/skills.
# ============================================================

# Envuelto en funcion para que un 'return' no cierre la sesion de PowerShell
# cuando se ejecuta via "irm | iex".
function Install-NotebookLMSkill {
    $ErrorActionPreference = "Stop"

    # --- Configuracion (versiones oficiales fijas) ---
    $RepoSlug      = "Carlos-Vera/BrainClaude"
    $Branch        = "main"
    $PythonVersion = "3.14"      # version de Python fija (ej. "3.14" o un patch "3.14.0")
    # -------------------------------------------------

    $Raw    = "https://raw.githubusercontent.com/$RepoSlug/$Branch"
    $Skills = @("notebooklm", "wrapup")
    $Venv   = Join-Path $env:USERPROFILE ".notebooklm-venv"
    $UvDir  = Join-Path $env:USERPROFILE ".local\bin"

    Write-Host "============================================"
    Write-Host "   Instalador NotebookLM Skill - por Carlos Vera"
    Write-Host "============================================"
    Write-Host ""

    # --- 1) uv (instala Python sin admin) ---
    Write-Host "[1/5] Comprobando uv..."
    if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
        if (Test-Path (Join-Path $UvDir "uv.exe")) {
            $env:Path = "$UvDir;$env:Path"
        } else {
            Write-Host "   Instalando uv (sin admin, en tu carpeta de usuario)..."
            powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
            $env:Path = "$UvDir;$env:Path"
        }
    }
    if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
        Write-Host "   x No se pudo instalar uv."
        return
    }
    Write-Host "   OK - uv listo."

    # --- 2) Python fijo via uv ---
    Write-Host "[2/5] Asegurando Python $PythonVersion (aislado, sin tocar el sistema)..."
    uv python install $PythonVersion
    Write-Host "   OK - Python $PythonVersion disponible."

    # --- 3) CLI notebooklm-py ---
    Write-Host "[3/5] Instalando notebooklm-py (3-7 minutos, es normal que tarde)..."
    uv venv --python $PythonVersion $Venv
    uv pip install --python (Join-Path $Venv "Scripts\python.exe") "notebooklm-py[browser]"
    & (Join-Path $Venv "Scripts\playwright.exe") install chromium
    Write-Host "   OK - notebooklm-py instalado."

    # --- 4) Verificacion ---
    Write-Host "[4/5] Verificando CLI..."
    & (Join-Path $Venv "Scripts\notebooklm.exe") --help *> $null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "   x Fallo la verificacion. Escribe a carlos@braveslab.com con el error."
        return
    }
    Write-Host "   OK - CLI operativa."

    # --- 5) Instalar las skills en Claude Code ---
    Write-Host "[5/5] Instalando las skills en Claude Code..."
    $dst = Join-Path $env:USERPROFILE ".claude\skills"
    foreach ($s in $Skills) {
        $skillDir = Join-Path $dst $s
        New-Item -ItemType Directory -Force -Path $skillDir | Out-Null
        Invoke-WebRequest -UseBasicParsing "$Raw/skills/$s/SKILL.md" -OutFile (Join-Path $skillDir "SKILL.md")
        Write-Host "   OK - skill '$s' instalada."
    }

    Write-Host ""
    Write-Host "============================================"
    Write-Host "   OK - Instalacion completada"
    Write-Host "============================================"
    Write-Host ""
    Write-Host "Pasos siguientes:"
    Write-Host "   1. Abre (o reinicia) Claude Code"
    Write-Host "   2. Escribe: instala notebooklm"
    Write-Host "   3. Inicia sesion en Google cuando se abra el navegador"
    Write-Host ""
    Write-Host "De un venezolano para el mundo, con el favor de nuestro Senor JesusCristo."
}

Install-NotebookLMSkill
