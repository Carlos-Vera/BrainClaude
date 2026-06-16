# NotebookLM Skill para Claude Code

Conecta **Claude Code** con **Google NotebookLM** y añade un cierre de sesión que
guarda tu memoria a largo plazo. Instalación con un solo comando: deja la CLI lista
y copia las skills en `~/.claude/skills/`.

Incluye dos skills:

- **notebooklm** — acceso completo a NotebookLM (crear cuadernos, añadir fuentes,
  generar podcasts, vídeos, infografías, presentaciones, quizzes, mapas mentales, informes…).
- **wrapup** — cierre de sesión: resume lo trabajado, guarda memorias y sube un
  registro a tu cuaderno "AI Brain" en NotebookLM.

---

## Instalación (un solo comando)

> Solo necesitas Claude Code. Si no tienes Python, el instalador lo instala por ti
> (aislado, con `uv`, sin contraseña de administrador).

### Mac / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/Carlos-Vera/BrainClaude/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/Carlos-Vera/BrainClaude/main/install.ps1 | iex
```

El instalador:

1. Instala `uv` si no lo tienes (en tu carpeta de usuario, sin admin).
2. Instala Python 3.14 aislado, sin tocar el sistema.
3. Instala `notebooklm-py` y Chromium en un entorno aislado (`~/.notebooklm-venv`).
4. Verifica que la CLI funciona.
5. Copia las skills `notebooklm` y `wrapup` en `~/.claude/skills/`.

---

## Después de instalar

1. Abre (o reinicia) Claude Code.
2. Escribe: `instala notebooklm`.
3. Se abrirá un navegador: inicia sesión en tu cuenta de Google.
4. Vuelve a Claude Code y confirma que ya estás dentro.

El login de Google es el único paso manual: una contraseña no se automatiza.

---

## Soporte

Dudas o errores: **carlos@braveslab.com**

De un venezolano para el mundo, con el favor de nuestro Señor JesusCristo.
