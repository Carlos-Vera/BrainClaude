#!/usr/bin/env bash
# ============================================================
#  Instalador NotebookLM Skill para Claude Code (Mac / Linux)
#  por Carlos Vera
#
#  Uso:
#    curl -fsSL https://raw.githubusercontent.com/Carlos-Vera/BrainClaude/main/install.sh | bash
#
#  Instala Python de forma aislada con uv (sin contrasena ni sudo),
#  deja la CLI notebooklm-py lista y copia las skills en ~/.claude/skills.
# ============================================================
set -euo pipefail

# --- Configuracion (versiones oficiales fijas) ---
REPO_SLUG="Carlos-Vera/BrainClaude"
BRANCH="main"
PYTHON_VERSION="3.14"          # version de Python fija (ej. "3.14" o un patch "3.14.0")
# -------------------------------------------------

RAW="https://raw.githubusercontent.com/${REPO_SLUG}/${BRANCH}"
SKILLS=(notebooklm wrapup)
VENV="$HOME/.notebooklm-venv"

echo "============================================"
echo "   Instalador NotebookLM Skill - por Carlos Vera"
echo "============================================"
echo ""

# Localiza uv en el PATH o en sus rutas de instalacion conocidas
ensure_uv_in_path() {
    command -v uv >/dev/null 2>&1 && return 0
    for p in "$HOME/.local/bin" "$HOME/.cargo/bin"; do
        if [ -x "$p/uv" ]; then
            export PATH="$p:$PATH"
            return 0
        fi
    done
    return 1
}

# --- 1) uv (instala Python sin contrasena) ---
echo "[1/5] Comprobando uv..."
if ! ensure_uv_in_path; then
    echo "   Instalando uv (sin contrasena, en tu carpeta de usuario)..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    ensure_uv_in_path || { echo "   x No se pudo instalar uv."; exit 1; }
fi
echo "   OK - $(uv --version)"

# --- 2) Python fijo via uv ---
echo "[2/5] Asegurando Python ${PYTHON_VERSION} (aislado, sin tocar el sistema)..."
uv python install "$PYTHON_VERSION"
echo "   OK - Python ${PYTHON_VERSION} disponible."

# --- 3) CLI notebooklm-py ---
echo "[3/5] Instalando notebooklm-py (3-7 minutos, es normal que tarde)..."
uv venv --python "$PYTHON_VERSION" "$VENV"
uv pip install --python "$VENV/bin/python" --quiet "notebooklm-py[browser]"
"$VENV/bin/playwright" install chromium
echo "   OK - notebooklm-py instalado."

# --- 4) Verificacion ---
echo "[4/5] Verificando CLI..."
if ! "$VENV/bin/notebooklm" --help >/dev/null 2>&1; then
    echo "   x Fallo la verificacion. Escribe a carlos@braveslab.com con el error."
    exit 1
fi
echo "   OK - CLI operativa."

# --- 5) Instalar las skills en Claude Code ---
echo "[5/5] Instalando las skills en Claude Code..."
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
