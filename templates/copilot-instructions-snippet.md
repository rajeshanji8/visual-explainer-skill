<!-- Auto-added by visual-explainer-skill installer. Do not edit this block manually. -->
<!-- To remove: run the installer with --uninstall, or delete this block. -->

## Visual Explainer Skill — Global Conventions

When the user asks to explain, diagram, visualize, or document any system architecture:

1. **Always use the visual-explainer skill** at `.github/skills/visual-explainer/SKILL.md`
2. **Follow the Think → Structure → Style → Deliver workflow** defined in SKILL.md
3. **Default to Mermaid format** unless the diagram exceeds 20 nodes (use PlantUML) or needs interactivity (use HTML)
4. **Every arrow must have a meaningful label** — never just "calls" or "uses"
5. **Limit diagrams to 15 nodes** — split into sub-diagrams if larger
6. **For non-technical audiences**, default to C4 Level 1 with metaphor-based annotations
7. **Read the appropriate reference file** before generating: `c4-syntax.md` for C4, `diagram-routing.md` for format selection, `metaphors.md` for layman explanations
