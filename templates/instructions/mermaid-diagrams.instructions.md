---
applyTo: "**/*.mermaid,**/*.mmd"
---

# Mermaid Diagram Conventions

Follow the visual-explainer skill at `.github/skills/visual-explainer/SKILL.md` — specifically the Mermaid Syntax Safety Rules.

## Rules
- Never use the bare reserved word `end` — always wrap in quotes or brackets: `["end"]`
- Never use backticks inside node labels
- Use `-->` for flowchart arrows, not `->`
- Use `->>` for async sequence diagram calls
- Keep node IDs simple and alphanumeric — put display text in brackets: `A["Display Text"]`
- Always quote subgraph titles that contain spaces
- Keep labels under 60 characters — use `<br/>` for line breaks if needed
- Every arrow must have a meaningful label
- Limit diagrams to 15-20 nodes maximum
- Use subgraphs to group related elements
