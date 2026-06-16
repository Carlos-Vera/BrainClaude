#!/usr/bin/env bash
# ============================================================
#  Instalador NotebookLM Skill para Claude Code (Mac / Linux)
#  por Carlos Vera
#
#  Uso:
#    curl -fsSL https://raw.githubusercontent.com/Carlos-Vera/BrainClaude/main/install.sh | bash
# ============================================================
set -euo pipefail

# --- Configuracion (se ajusta al publicar el repo) ---
REPO_SLUG="Carlos-Vera/BrainClaude"
BRANCH="main"
# ------------------------------------------------------

RAW="https://raw.githubusercontent.com/${REPO_SLUG}/${BRANCH}"
SKILLS=(notebooklm wrapup)
VENV="$HOME/.notebooklm-venv"

echo "============================================"
echo "   Instalador NotebookLM Skill - por Carlos Vera"
echo "============================================"
echo ""

# --- 1) Python 3.10+ ---
echo "[1/4] Comprobando Python..."
PYTHON=""
for cand in python3.12 python3.11 python3.10 python3; do
    if command -v "$cand" >/dev/null 2>&1 \
        && "$cand" -c 'import sys; raise SystemExit(0 if sys.version_info >= (3,10) else 1)' >/dev/null 2>&1; then
        PYTHON="$cand"
        break
    fi
done
if [ -z "$PYTHON" ]; then
    echo "   x Python 3.10 o superior no encontrado."
    echo "     Instalalo desde https://www.python.org/downloads/ y vuelve a ejecutar este comando."
    exit 1
fi
echo "   OK - $("$PYTHON" --version 2>&1)"

# --- 2) CLI notebooklm-py ---
echo "[2/4] Instalando notebooklm-py (3-7 minutos, es normal que tarde)..."
"$PYTHON" -m venv "$VENV"
"$VENV/bin/pip" install --quiet --upgrade pip
"$VENV/bin/pip" install --quiet "notebooklm-py[browser]"
"$VENV/bin/playwright" install chromium
echo "   OK - notebooklm-py instalado."

# --- 3) Verificacion ---
echo "[3/4] Verificando CLI..."
if ! "$VENV/bin/notebooklm" --help >/dev/null 2>&1; then
    echo "   x Fallo la verificacion. Escribe a carlos@braveslab.com con el error."
    exit 1
fi
echo "   OK - CLI operativa."

# --- 4) Instalar las skills en Claude Code ---
echo "[4/4] Instalando las skills en Claude Code..."
DST="$HOME/.claude/skills"
mkdir -p "$DST"
for S in "${SKILLS[@]}"; do
    mkdir -p "$DST/$S"
    curl -fsSL "${RAW}/skills/${S}/SKILL.md" -o "$DST/$S/SKILL.md"
    echo "   OK - skill '$S' instalada."
done

echo ""
echo "============================================"
echo "   OK - Instalacion completada"
echo "============================================"
echo ""
echo "Pasos siguientes:"
echo "   1. Abre (o reinicia) Claude Code"
echo "   2. Escribe: instala notebooklm"
echo "   3. Inicia sesion en Google cuando se abra el navegador"
echo ""
echo "De un venezolano para el mundo, con el favor de nuestro Senor JesusCristo."
