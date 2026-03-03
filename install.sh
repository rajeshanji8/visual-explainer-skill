#!/usr/bin/env bash

set -Eeuo pipefail

# ============================================================
# visual-explainer-skill installer
# Installs skills into AI agent directories at project or user level
# Supports: Claude Code, Codex, Gemini CLI, Cursor, GitHub Copilot
#
# Works two ways:
#   1. Local:  ./install.sh ~/projects/my-app
#   2. Remote: curl -fsSL https://raw.githubusercontent.com/rajeshanji8/visual-explainer-skill/main/install.sh | bash -s -- ~/projects/my-app
# ============================================================

GITHUB_REPO="https://github.com/rajeshanji8/visual-explainer-skill.git"
AI_AGENTS=("claude" "codex" "gemini" "cursor" "copilot")
INSTALL_LEVEL="project"
SELECTED_AGENTS=()
WITH_INSTRUCTIONS=false

MARKER_START="<!-- visual-explainer-skill:start -->"
MARKER_END="<!-- visual-explainer-skill:end -->"

usage() {
  cat <<EOF

Usage: $0 [PROJECT_PATH] [OPTIONS]

Install visual-explainer-skill for AI coding agents.

OPTIONS:
  --project              Install at project level (default)
  --user                 Install at user level (~/.claude, ~/.codex, etc.)
  --agent AGENT          Install for specific agent(s): claude, codex, gemini, cursor, copilot, or 'all'
                         Can be specified multiple times. Default: all agents
  --with-instructions    (Copilot only) Also append to copilot-instructions.md and add path-specific
                         .instructions.md files for extra rule enforcement. Uses marker comments
                         for clean uninstall. Safe to run multiple times.
  --uninstall            Remove installed skill from agent directories
  -h, --help             Show this help message

EXAMPLES:
  # --- Skill only (default, safe, portable) ---
  $0 ~/projects/my-app
  $0 --agent copilot ~/projects/my-app

  # --- Skill + Copilot instruction reinforcement ---
  $0 --with-instructions ~/projects/my-app

  # --- Other examples ---
  $0 --user                                 # Install for all agents at user level
  $0 --user --agent claude                  # Install for Claude at user level
  $0 --uninstall ~/projects/my-app          # Remove skill from a project

EOF
  exit 0
}

UNINSTALL=false
PROJECT_PATH=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)   INSTALL_LEVEL="project"; shift ;;
    --user)      INSTALL_LEVEL="user";    shift ;;
    --agent)
      shift
      if [[ "$1" == "all" ]]; then
        SELECTED_AGENTS=("${AI_AGENTS[@]}")
      else
        SELECTED_AGENTS+=("$1")
      fi
      shift ;;
    --with-instructions) WITH_INSTRUCTIONS=true; shift ;;
    --uninstall) UNINSTALL=true; shift ;;
    -h|--help)   usage ;;
    *)
      if [[ -z "$PROJECT_PATH" ]]; then
        PROJECT_PATH="$1"
      fi
      shift ;;
  esac
done

# Default: all agents
if [[ ${#SELECTED_AGENTS[@]} -eq 0 ]]; then
  SELECTED_AGENTS=("${AI_AGENTS[@]}")
fi

# Validate project path
if [[ "${INSTALL_LEVEL}" == "project" ]]; then
  if [[ -z "$PROJECT_PATH" ]]; then
    PROJECT_PATH="."
  fi
  PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd)"
  if [[ ! -d "$PROJECT_PATH" ]]; then
    echo "Error: Project path '$PROJECT_PATH' does not exist."
    exit 1
  fi
fi

# --------------- RESOLVE SOURCE ---------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -d "${SCRIPT_DIR}/skills" ]]; then
  SOURCE_SKILLS_DIR="${SCRIPT_DIR}/skills"
else
  echo "No local skills/ directory found. Downloading from GitHub..."
  if ! command -v git &>/dev/null; then
    echo "Error: git is required for remote install."
    exit 1
  fi
  TEMP_DIR="$(mktemp -d)"
  trap 'rm -rf "$TEMP_DIR"' EXIT
  git clone --depth 1 "$GITHUB_REPO" "$TEMP_DIR" 2>/dev/null
  SOURCE_SKILLS_DIR="${TEMP_DIR}/skills"
  if [[ ! -d "$SOURCE_SKILLS_DIR" ]]; then
    echo "Error: Could not find skills/ in cloned repo."
    exit 1
  fi
fi

# --------------- MAIN ---------------
echo ""
echo "Visual Explainer Skill Installer"
echo "================================"
echo "Source:  ${SCRIPT_DIR}"
echo "Level:  ${INSTALL_LEVEL}"
if [[ "${INSTALL_LEVEL}" == "project" ]]; then
  echo "Project: ${PROJECT_PATH}"
fi
echo "Agents: ${SELECTED_AGENTS[*]}"
echo ""

# Map agent name to its dot-directory (copilot uses .github)
agent_dir_name() {
  if [[ "$1" == "copilot" ]]; then echo ".github"; else echo ".$1"; fi
}

for agent in "${SELECTED_AGENTS[@]}"; do
  DIR_NAME="$(agent_dir_name "$agent")"
  if [[ "${INSTALL_LEVEL}" == "user" ]]; then
    AGENT_DIR="${HOME}/${DIR_NAME}"
  else
    AGENT_DIR="${PROJECT_PATH}/${DIR_NAME}"
  fi

  SKILLS_DIR="${AGENT_DIR}/skills"

  if $UNINSTALL; then
    if [[ -d "${SKILLS_DIR}/visual-explainer" ]]; then
      rm -rf "${SKILLS_DIR}/visual-explainer"
      echo "✓ Removed visual-explainer skill for ${agent} from ${SKILLS_DIR}"
    else
      echo "⚠ No visual-explainer skill found for ${agent} at ${SKILLS_DIR}"
    fi
    # Clean up Copilot instruction snippets/files added by --with-instructions
    if [[ "$agent" == "copilot" ]]; then
      # Remove marker block from copilot-instructions.md
      COPILOT_INSTR="${AGENT_DIR}/copilot-instructions.md"
      if [[ -f "$COPILOT_INSTR" ]] && grep -q "$MARKER_START" "$COPILOT_INSTR" 2>/dev/null; then
        # Remove everything between markers (inclusive)
        sed -i.bak "/$MARKER_START/,/$MARKER_END/d" "$COPILOT_INSTR"
        rm -f "${COPILOT_INSTR}.bak"
        # Remove file if it's now empty (only whitespace)
        if [[ ! -s "$COPILOT_INSTR" ]] || [[ -z "$(tr -d '[:space:]' < "$COPILOT_INSTR")" ]]; then
          rm -f "$COPILOT_INSTR"
          echo "✓ Removed copilot-instructions.md (was empty after cleanup)"
        else
          echo "✓ Removed visual-explainer snippet from copilot-instructions.md"
        fi
      fi
      # Remove path-specific instruction files (only ours)
      INSTR_DIR="${AGENT_DIR}/instructions"
      for fname in mermaid-diagrams.instructions.md; do
        [[ -f "${INSTR_DIR}/${fname}" ]] && rm -f "${INSTR_DIR}/${fname}" && echo "✓ Removed ${fname}"
      done
    fi
  else
    echo "Installing for ${agent} at ${INSTALL_LEVEL} level..."
    mkdir -p "${SKILLS_DIR}"
    rm -rf "${SKILLS_DIR}/visual-explainer"
    cp -r "${SOURCE_SKILLS_DIR}/visual-explainer" "${SKILLS_DIR}/"
    echo "✓ Installed visual-explainer skill for ${agent} into ${SKILLS_DIR}/visual-explainer"

    # --with-instructions: append snippet + copy path-specific files (Copilot only)
    if [[ "$agent" == "copilot" ]] && $WITH_INSTRUCTIONS; then
      TEMPLATES_DIR="${SCRIPT_DIR}/templates"
      if [[ -d "$TEMPLATES_DIR" ]]; then
        # Append snippet to copilot-instructions.md (idempotent — skip if markers already present)
        COPILOT_INSTR="${AGENT_DIR}/copilot-instructions.md"
        SNIPPET="${TEMPLATES_DIR}/copilot-instructions-snippet.md"
        if [[ -f "$SNIPPET" ]]; then
          if [[ -f "$COPILOT_INSTR" ]] && grep -q "$MARKER_START" "$COPILOT_INSTR" 2>/dev/null; then
            echo "⚠ Visual Explainer snippet already present in copilot-instructions.md, skipping"
          else
            echo "" >> "$COPILOT_INSTR"
            echo "$MARKER_START" >> "$COPILOT_INSTR"
            cat "$SNIPPET" >> "$COPILOT_INSTR"
            echo "$MARKER_END" >> "$COPILOT_INSTR"
            echo "✓ Appended visual-explainer snippet to copilot-instructions.md"
          fi
        fi

        # Copy path-specific .instructions.md files (skip if they already exist)
        INSTR_SOURCE_DIR="${TEMPLATES_DIR}/instructions"
        if [[ -d "$INSTR_SOURCE_DIR" ]]; then
          INSTR_TARGET_DIR="${AGENT_DIR}/instructions"
          mkdir -p "$INSTR_TARGET_DIR"
          for file in "${INSTR_SOURCE_DIR}"/*.instructions.md; do
            [[ ! -f "$file" ]] && continue
            BASENAME="$(basename "$file")"
            TARGET="${INSTR_TARGET_DIR}/${BASENAME}"
            if [[ ! -f "$TARGET" ]]; then
              cp "$file" "$TARGET"
              echo "✓ Installed ${BASENAME} into ${INSTR_TARGET_DIR}"
            else
              echo "⚠ Skipped ${BASENAME} (already exists)"
            fi
          done
        fi
      else
        echo "⚠ templates/ directory not found — skipping instruction files"
      fi
    fi
  fi
done

echo ""
echo "Done!"
if ! $UNINSTALL; then
  echo ""
  echo "Installed structure:"
  echo "  .<agent>/skills/visual-explainer/"
  echo "  ├── SKILL.md              # Entry point (agent reads this first)"
  echo "  ├── references/           # Detailed guides (read on demand)"
  echo "  ├── prompts/              # Slash-command workflows"
  echo "  └── templates/            # Mermaid/PlantUML starter templates"
  if $WITH_INSTRUCTIONS && printf '%s\n' "${SELECTED_AGENTS[@]}" | grep -q '^copilot$'; then
    echo ""
    echo "Copilot extras (via --with-instructions):"
    echo "  .github/copilot-instructions.md          # Appended visual-explainer snippet"
    echo "  .github/instructions/                     # Path-specific rules"
    echo "  └── mermaid-diagrams.instructions.md      # Fires on *.mermaid, *.mmd files"
  elif printf '%s\n' "${SELECTED_AGENTS[@]}" | grep -q '^copilot$'; then
    echo ""
    echo "Tip: For extra Copilot compliance, re-run with --with-instructions"
    echo "     to add always-on rules and path-specific instruction files."
  fi
fi
