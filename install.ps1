# ============================================================
#  Instalador NotebookLM Skill para Claude Code (Windows)
#  por Carlos Vera
#
#  Uso (PowerShell):
#    irm https://raw.githubusercontent.com/Carlos-Vera/BrainClaude/main/install.ps1 | iex
# ============================================================

# Envuelto en funcion para que un 'return' no cierre la sesion de PowerShell
# cuando se ejecuta via "irm | iex".
function Install-NotebookLMSkill {
    $ErrorActionPreference = "Stop"

    # --- Configuracion (se ajusta al publicar el repo) ---
    $RepoSlug = "Carlos-Vera/BrainClaude"
    $Branch   = "main"
    # ------------------------------------------------------

    $Raw    = "https://raw.githubusercontent.com/$RepoSlug/$Branch"
    $Skills = @("notebooklm", "wrapup")
    $Venv   = Join-Path $env:USERPROFILE ".notebooklm-venv"

    Write-Host "============================================"
    Write-Host "   Instalador NotebookLM Skill - por Carlos Vera"
    Write-Host "============================================"
    Write-Host ""

    # --- 1) Python 3.10+ ---
    Write-Host "[1/4] Comprobando Python..."
    $python = $null
    foreach ($c in @("python", "python3", "py")) {
        if (Get-Command $c -ErrorAction SilentlyContinue) {
            $ok = (& $c -c "import sys; print(1 if sys.version_info >= (3,10) else 0)" 2>$null)
            if ("$ok".Trim() -eq "1") { $python = $c; break }
        }
    }
    if (-not $python) {
        Write-Host "   x Python 3.10 o superior no encontrado."
        Write-Host "     Instalalo desde https://www.python.org/downloads/ (marca 'Add Python to PATH') y reintenta."
        Start-Process "https://www.python.org/downloads/"
        return
    }
    Write-Host "   OK - Python encontrado."

    # --- 2) CLI notebooklm-py ---
    Write-Host "[2/4] Instalando notebooklm-py (3-7 minutos, es normal que tarde)..."
    & $python -m venv $Venv
    & "$Venv\Scripts\pip.exe" install --quiet --upgrade pip
    & "$Venv\Scripts\pip.exe" install "notebooklm-py[browser]"
    & "$Venv\Scripts\playwright.exe" install chromium
    Write-Host "   OK - notebooklm-py instalado."

    # --- 3) Verificacion ---
    Write-Host "[3/4] Verificando CLI..."
    & "$Venv\Scripts\notebooklm.exe" --help *> $null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "   x Fallo la verificacion. Escribe a carlos@braveslab.com con el error."
        return
    }
    Write-Host "   OK - CLI operativa."

    # --- 4) Instalar las skills en Claude Code ---
    Write-Host "[4/4] Instalando las skills en Claude Code..."
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
