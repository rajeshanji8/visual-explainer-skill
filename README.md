# visual-explainer-skill

A reusable **visual explainer** skill for AI coding agents. Install it once and every agent can generate architecture diagrams, C4 models, sequence diagrams, flowcharts, and layman-friendly visual explanations from any codebase — zero source code, pure prompt engineering.

**Supported agents:** Claude Code · Codex · Gemini CLI · Cursor · GitHub Copilot

---

## Quick Install

**TLDR — run this in your project directory:**
```bash
curl -fsSL https://raw.githubusercontent.com/rajeshanji8/visual-explainer-skill/main/install.sh | bash -s -- . --with-instructions
```

### All agents — project level (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/rajeshanji8/visual-explainer-skill/main/install.sh | bash -s -- ~/projects/my-app
```

### With Copilot instruction reinforcement (optional)

```bash
curl -fsSL https://raw.githubusercontent.com/rajeshanji8/visual-explainer-skill/main/install.sh | bash -s -- ~/projects/my-app --with-instructions
```

### Specific agent only

```bash
curl -fsSL https://raw.githubusercontent.com/rajeshanji8/visual-explainer-skill/main/install.sh | bash -s -- --agent claude ~/projects/my-app
```

### User level (applies to all projects)

```bash
curl -fsSL https://raw.githubusercontent.com/rajeshanji8/visual-explainer-skill/main/install.sh | bash -s -- --user
```

### Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/rajeshanji8/visual-explainer-skill/main/install.sh | bash -s -- --uninstall
```

---

## Local Install (after cloning)

```bash
git clone https://github.com/rajeshanji8/visual-explainer-skill.git
cd visual-explainer-skill

# Install for all agents in a project
./install.sh ~/projects/my-app

# With Copilot instruction reinforcement
./install.sh --with-instructions ~/projects/my-app

# Install for Claude only
./install.sh --agent claude ~/projects/my-app

# Install at user level for Gemini
./install.sh --user --agent gemini

# Windows
.\install.ps1 C:\projects\my-app
.\install.ps1 -WithInstructions C:\projects\my-app
.\install.ps1 -Agent claude C:\projects\my-app
```

---

## What's Inside

The skill is a set of markdown files that AI agents read on demand. The entry point is `SKILL.md`, which links to focused reference docs:

| Module | Reference | Covers |
|--------|-----------|--------|
| Diagram Routing | `diagram-routing.md` | Which diagram type and format for each request |
| C4 Syntax | `c4-syntax.md` | C4 notation for Mermaid and PlantUML, macros, templates |
| CSS Patterns | `css-patterns.md` | Design system for HTML/SVG visualizations |
| Metaphors | `metaphors.md` | Technical-to-layman translation dictionary |

### Prompts (slash-command workflows)

| Prompt | Purpose |
|--------|---------|
| `analyze-architecture.md` | Full multi-level architecture analysis |
| `generate-c4.md` | C4 diagram generation at a specific level |
| `explain-simply.md` | Layman-friendly visual explanation |

### Templates (starters)

| Template | Purpose |
|----------|---------|
| `c4-context.mermaid` | C4 Level 1 system context template |
| `c4-container.mermaid` | C4 Level 2 container diagram template |
| `sequence-api.mermaid` | API request flow sequence diagram template |

Agents load only the reference they need for the current task — they don't read everything at once.

---

## Copilot Reinforcement Layer (Optional)

The skill is designed to be **self-sufficient** — `SKILL.md` contains all critical rules inline and instructs the agent to read reference files before generating. No additional files are required.

For **maximum compliance** with GitHub Copilot, the installer supports `--with-instructions` which adds two optional reinforcement layers:

### What `--with-instructions` Does

| Action | Effect |
|--------|--------|
| **Appends** to `.github/copilot-instructions.md` | Adds a snippet with the top 7 rules, wrapped in `<!-- visual-explainer-skill:start/end -->` markers for clean uninstall. Safe if the file already exists — your existing instructions are preserved. |
| **Copies** `.instructions.md` files to `.github/instructions/` | Path-specific rules that auto-trigger when Copilot touches matching files. Skips files that already exist. |

### Path-Specific Instruction Files

| File | Triggers On | Enforces |
|------|-------------|----------|
| `mermaid-diagrams.instructions.md` | `**/*.mermaid`, `**/*.mmd` | Mermaid syntax safety, label requirements |

### How the Layers Work Together

```
Request arrives
  │
  ├─ copilot-instructions.md              ← Always loaded (top 7 rules)       [--with-instructions]
  ├─ instructions/mermaid-diagrams.md      ← Auto-loaded for .mermaid files    [--with-instructions]
  ├─ skills/visual-explainer/SKILL.md      ← Loaded when skill matches prompt  [default]
  │    ├─ Workflow (Think→Structure→Style→Deliver)
  │    ├─ Routing table (diagram type → format)
  │    ├─ Quality gates (swap test, label test)
  │    └─ Framework detection heuristics
  └─ references/*.md                       ← Deep-dive docs (read on demand)   [default]
```

### Template Files

All reinforcement files live in `templates/` in this repo. You can also copy them manually — see [templates/README.md](templates/README.md) for details.

---

## How It Works

The installer copies `skills/visual-explainer/` into the agent's skill directory:

| Agent | Project-level path | User-level path |
|-------|-------------------|-----------------|
| Claude Code | `.claude/skills/visual-explainer/` | `~/.claude/skills/visual-explainer/` |
| Codex | `.codex/skills/visual-explainer/` | `~/.codex/skills/visual-explainer/` |
| Gemini CLI | `.gemini/skills/visual-explainer/` | `~/.gemini/skills/visual-explainer/` |
| Cursor | `.cursor/skills/visual-explainer/` | `~/.cursor/skills/visual-explainer/` |
| GitHub Copilot | `.github/skills/visual-explainer/` | `~/.copilot/skills/visual-explainer/` |

Once installed, the agent automatically picks up the skill when working on diagram or architecture tasks.

---

## Requirements

- **Git** (for cloning during remote install)
- **Bash** (macOS/Linux) or **PowerShell 5.1+** (Windows)
- No additional dependencies — this installs skill files only

---

## Contributing

1. Edit files under `skills/visual-explainer/`
2. Test by installing locally: `./install.sh .`
3. Verify the agent picks up your changes

---

## License

MIT
