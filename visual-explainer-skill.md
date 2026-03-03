# Visual Explainer Skill

> A reusable AI coding skill for visual architecture documentation. Install into any project for any AI agent — Claude Code, Codex, Gemini CLI, Cursor, GitHub Copilot.

---

## Usage

### Quick Install (from GitHub — no clone needed)

**Bash (macOS/Linux):**
```bash
# Install for all agents at project level
curl -fsSL https://raw.githubusercontent.com/rajeshanji8/visual-explainer-skill/main/install.sh | bash -s -- ~/projects/my-app

# Install for specific agent(s)
curl -fsSL https://raw.githubusercontent.com/rajeshanji8/visual-explainer-skill/main/install.sh | bash -s -- ~/projects/my-app --agent claude

# Install at user level (applies to all your projects)
curl -fsSL https://raw.githubusercontent.com/rajeshanji8/visual-explainer-skill/main/install.sh | bash -s -- --user

# Install at user level for specific agent
curl -fsSL https://raw.githubusercontent.com/rajeshanji8/visual-explainer-skill/main/install.sh | bash -s -- --user --agent claude

# Uninstall
curl -fsSL https://raw.githubusercontent.com/rajeshanji8/visual-explainer-skill/main/install.sh | bash -s -- --uninstall ~/projects/my-app
```

**PowerShell (Windows):**
```powershell
# Clone first, then:
.\install.ps1 C:\projects\my-app
.\install.ps1 C:\projects\my-app -Agent claude
.\install.ps1 -User
.\install.ps1 -Uninstall C:\projects\my-app
```

### Install from Cloned Repo

```bash
git clone https://github.com/rajeshanji8/visual-explainer-skill.git
cd visual-explainer-skill
```

**Bash:**
```bash
./install.sh ~/projects/my-app                      # All agents, project level
./install.sh ~/projects/my-app --agent claude        # Claude only
./install.sh --user                                  # All agents, user level
./install.sh --user --agent claude --agent codex     # Specific agents, user level
./install.sh --uninstall                             # Remove skill
```

**PowerShell:**
```powershell
.\install.ps1 C:\projects\my-app                     # All agents, project level
.\install.ps1 C:\projects\my-app -Agent claude        # Claude only
.\install.ps1 -User                                   # All agents, user level
.\install.ps1 -User -Agent claude -Agent codex        # Specific agents, user level
.\install.ps1 -Uninstall                              # Remove skill
```

### Manual Installation

Copy the `skills/visual-explainer` folder into the agent's skill directory:

| Agent | Project Level | User Level |
|-------|--------------|------------|
| Claude Code | `project/.claude/skills/visual-explainer` | `~/.claude/skills/visual-explainer` |
| Codex | `project/.codex/skills/visual-explainer` | `~/.codex/skills/visual-explainer` |
| Gemini CLI | `project/.gemini/skills/visual-explainer` | `~/.gemini/skills/visual-explainer` |
| Cursor | `project/.cursor/skills/visual-explainer` | `~/.cursor/skills/visual-explainer` |
| GitHub Copilot | `project/.github/skills/visual-explainer` | `~/.github/skills/visual-explainer` |

---

## Structure

```
visual-explainer-skill/
├── visual-explainer-skill.md               # This file
├── install.sh                              # Bash installer
├── install.ps1                             # PowerShell installer
├── skills/
│   └── visual-explainer/
│       ├── SKILL.md                        # Entry point — agent reads this first
│       ├── references/                     # Detailed guides (read on demand)
│       │   ├── diagram-routing.md
│       │   ├── c4-syntax.md
│       │   ├── css-patterns.md
│       │   └── metaphors.md
│       ├── prompts/                        # Slash-command workflows
│       │   ├── analyze-architecture.md
│       │   ├── generate-c4.md
│       │   └── explain-simply.md
│       └── templates/                      # Mermaid/PlantUML starter templates
│           ├── c4-context.mermaid
│           ├── c4-container.mermaid
│           └── sequence-api.mermaid
└── templates/                              # Optional Copilot reinforcement
    ├── README.md
    ├── copilot-instructions-snippet.md
    └── instructions/
        └── mermaid-diagrams.instructions.md
```

### How it works

1. **SKILL.md** is the entry point with YAML frontmatter describing the skill
2. It links to **references/** — agents only read the reference they need for the current task
3. It links to **prompts/** — slash-command workflows for specific actions
4. **templates/** provide starter diagrams to build from
5. This keeps context small and focused instead of dumping everything upfront

---

## Skill Modules

| Module | Reference | Description |
|--------|-----------|-------------|
| Diagram Routing | `diagram-routing.md` | Decision tables for diagram type, format, and complexity |
| C4 Syntax | `c4-syntax.md` | Complete C4 notation for Mermaid and PlantUML |
| CSS Patterns | `css-patterns.md` | Design system, aesthetics, layout patterns for HTML output |
| Metaphors | `metaphors.md` | 40+ technical-to-layman translations |

---

## Customizing

- Edit files in `skills/visual-explainer/references/` — re-run install to update projects
- Add new references and link them from `SKILL.md`
- Add new diagram templates to `skills/visual-explainer/templates/`
- Add new prompts to `skills/visual-explainer/prompts/`

---

## References

- [Claude Agent Skills](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/skills)
- [OpenAI Codex](https://openai.com/index/openai-codex/)
- [Gemini CLI](https://github.com/google-gemini/gemini-cli)
- [C4 Model](https://c4model.com/)
- [Mermaid](https://mermaid.js.org/)
- [PlantUML C4](https://github.com/plantuml-stdlib/C4-PlantUML)
