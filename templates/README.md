# Optional: Boost Copilot Skill Compliance

The visual-explainer skill works **standalone** — `SKILL.md` contains all rules inline and instructs the agent to read reference files on demand. No additional files are required.

However, for **maximum compliance** with GitHub Copilot, you can add these optional reinforcement layers:

---

## Layer 1: Always-On Instructions (`copilot-instructions.md`)

Append the snippet from `copilot-instructions-snippet.md` to your project's `.github/copilot-instructions.md`. This ensures the top rules are loaded on **every request**, not just when the skill is triggered.

**Manual:**
```bash
cat templates/copilot-instructions-snippet.md >> .github/copilot-instructions.md
```

**Automated (via installer):**
```bash
./install.sh --with-instructions ~/projects/my-app
```

The installer appends with marker comments (`<!-- visual-explainer-skill:start/end -->`) so it can be cleanly removed later with `--uninstall`.

---

## Layer 2: Path-Specific Instructions (`.instructions.md` files)

Copy the instruction files from `instructions/` into your project's `.github/instructions/` directory. These fire **automatically** when Copilot touches matching file types:

| File | Triggers On | Purpose |
|------|-------------|---------|
| `mermaid-diagrams.instructions.md` | `**/*.mermaid`, `**/*.mmd` | Mermaid syntax safety rules, label requirements |

**Manual:**
```bash
mkdir -p .github/instructions
cp templates/instructions/*.instructions.md .github/instructions/
```

**Automated (via installer):**
```bash
./install.sh --with-instructions ~/projects/my-app
```

---

## How the Layers Work Together

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

The skill is designed to work at every layer. The more layers you enable, the higher the compliance rate — but even with just the skill alone, the most critical rules are enforced.
