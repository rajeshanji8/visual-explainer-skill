# CSS Patterns Reference — HTML Visualizations

Design system for generating self-contained HTML visualizations when Mermaid
or PlantUML are insufficient (presentations, interactive diagrams, dashboards).

---

## Design Principles

1. **Self-contained**: All CSS and JS inline — single HTML file, no external dependencies
2. **Dual-theme**: Support both light and dark modes via `prefers-color-scheme`
3. **Responsive**: Work on screens from 768px to 4K
4. **Accessible**: Minimum 4.5:1 contrast ratio, readable font sizes (≥14px body)
5. **Distinctive**: Every output should look intentionally designed, not generic

---

## CSS Custom Properties Foundation

Every HTML visualization MUST define a theme using CSS custom properties:

```css
:root {
    /* Light theme (default) */
    --bg-primary: #FAFAFA;
    --bg-secondary: #FFFFFF;
    --bg-tertiary: #F0F0F0;
    --text-primary: #1A1A2E;
    --text-secondary: #4A4A68;
    --text-muted: #8888A0;
    --accent-primary: #4361EE;
    --accent-secondary: #3A0CA3;
    --accent-tertiary: #7209B7;
    --border-color: #E0E0E8;
    --shadow-color: rgba(0, 0, 0, 0.08);
    --success: #06D6A0;
    --warning: #FFD166;
    --danger: #EF476F;
    --info: #118AB2;
    --radius-sm: 4px;
    --radius-md: 8px;
    --radius-lg: 16px;
    --font-body: 'Source Sans 3', system-ui, sans-serif;
    --font-heading: 'Space Grotesk', system-ui, sans-serif;
    --font-mono: 'JetBrains Mono', 'Fira Code', monospace;
}

@media (prefers-color-scheme: dark) {
    :root {
        --bg-primary: #0D1117;
        --bg-secondary: #161B22;
        --bg-tertiary: #21262D;
        --text-primary: #E6EDF3;
        --text-secondary: #A8B3C2;
        --text-muted: #6E7A8A;
        --accent-primary: #58A6FF;
        --accent-secondary: #BC8CFF;
        --accent-tertiary: #D2A8FF;
        --border-color: #30363D;
        --shadow-color: rgba(0, 0, 0, 0.3);
    }
}
```

---

## Aesthetic Directions

Choose ONE aesthetic per visualization. Do NOT mix them.

### 1. Blueprint
- Dark blue background (#0A1628), white/cyan lines, technical feel
- Grid overlay pattern, engineering-drawing aesthetic
- Best for: architecture diagrams, infrastructure layouts

### 2. Editorial
- Clean white/cream backgrounds, strong typographic hierarchy
- Generous whitespace, serif headings, fine hairline borders
- Best for: documentation, reports, stakeholder presentations

### 3. Monochrome Terminal
- Black background, green/amber monospace text, ASCII-inspired
- Scanline effects optional, command-prompt aesthetic
- Best for: developer-facing tools, CLI explanations

### 4. Neon
- Dark backgrounds with vibrant glowing accent colors
- Subtle glow effects (box-shadow with spread), high contrast
- Best for: dashboards, real-time monitoring visualizations

### 5. Paper & Ink
- Warm off-white (#FDF6E3), hand-drawn feel, sketch-like borders
- Earthy colors, slight texture, organic shapes
- Best for: concept explanations, whiteboard-style diagrams

### 6. IDE-Inspired
- VS Code / JetBrains color palette, sidebar + editor layout
- Syntax-highlighted code blocks, tabbed navigation
- Best for: code walkthroughs, component deep-dives

### 7. Data-Dense
- Minimal chrome, maximum information density
- Small but readable type, tight grid, muted colors
- Best for: data tables, metrics dashboards, comparison matrices

### 8. Gradient Mesh
- Subtle gradient backgrounds, glassmorphism cards
- Frosted glass effects (backdrop-filter: blur), modern feel
- Best for: product overviews, marketing-adjacent presentations

---

## Layout Patterns

### CSS Grid Architecture Layout
For showing system components in a spatial arrangement:

```css
.architecture-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1.5rem;
    padding: 2rem;
}

.component-card {
    background: var(--bg-secondary);
    border: 1px solid var(--border-color);
    border-radius: var(--radius-md);
    padding: 1.25rem;
    box-shadow: 0 2px 8px var(--shadow-color);
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.component-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 16px var(--shadow-color);
}

.component-card .tech-badge {
    font-family: var(--font-mono);
    font-size: 0.75rem;
    color: var(--accent-primary);
    background: color-mix(in srgb, var(--accent-primary) 10%, transparent);
    padding: 0.15rem 0.5rem;
    border-radius: var(--radius-sm);
    display: inline-block;
    margin-top: 0.5rem;
}
```

### Connection Lines (SVG overlay)
For drawing arrows between components in HTML layouts:

```html
<svg class="connections" style="position:absolute; top:0; left:0; width:100%; height:100%; pointer-events:none;">
    <defs>
        <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
            <polygon points="0 0, 10 3.5, 0 7" fill="var(--accent-primary)" />
        </marker>
    </defs>
    <!-- Lines drawn via JavaScript calculating element positions -->
</svg>
```

### Slide Deck Layout
For multi-slide presentations:

```css
.slide-deck {
    width: 100%;
    max-width: 960px;
    margin: 0 auto;
}

.slide {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    padding: 3rem;
    scroll-snap-align: start;
}

.slide-deck {
    scroll-snap-type: y mandatory;
    overflow-y: scroll;
    height: 100vh;
}
```

### Data Table
For tabular data displays:

```css
.data-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    font-family: var(--font-body);
}

.data-table thead th {
    background: var(--bg-tertiary);
    color: var(--text-primary);
    font-weight: 600;
    text-align: left;
    padding: 0.75rem 1rem;
    border-bottom: 2px solid var(--accent-primary);
    position: sticky;
    top: 0;
    z-index: 1;
}

.data-table tbody td {
    padding: 0.75rem 1rem;
    border-bottom: 1px solid var(--border-color);
    color: var(--text-secondary);
}

.data-table tbody tr:hover {
    background: color-mix(in srgb, var(--accent-primary) 5%, var(--bg-primary));
}
```

---

## Typography

### Recommended Google Font Pairings

| Heading Font | Body Font | Mood |
|---|---|---|
| Space Grotesk | Source Sans 3 | Modern technical |
| Playfair Display | Lato | Editorial elegance |
| JetBrains Mono | Inter | Developer-focused |
| Fraunces | Work Sans | Warm professional |
| Sora | Nunito Sans | Clean contemporary |
| DM Serif Display | DM Sans | Bold documentation |

### Font Loading (inline in HTML)

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Source+Sans+3:wght@400;600&family=JetBrains+Mono:wght@400&display=swap" rel="stylesheet">
```

---

## Banned Defaults (Anti-Slop)

Do NOT use these unless explicitly requested — they are generically overused:

- ❌ Inter or Roboto as the only font
- ❌ Emoji as icons (use SVG icons or CSS shapes)
- ❌ Perfectly symmetric grid layouts (add intentional asymmetry)
- ❌ Generic blue (#007bff) as primary color
- ❌ Border-radius: 50% circles as the only shape
- ❌ Drop shadows greater than 20px blur (too fuzzy)
- ❌ Pure black (#000) on pure white (#FFF) text

---

## Chart.js Integration

For data visualizations in HTML output:

```html
<script src="https://cdn.jsdelivr.net/npm/chart.js@4/dist/chart.umd.min.js"></script>
<canvas id="chart" width="600" height="400"></canvas>
<script>
new Chart(document.getElementById('chart'), {
    type: 'bar', // or 'line', 'doughnut', 'radar', 'scatter'
    data: {
        labels: ['Label 1', 'Label 2', 'Label 3'],
        datasets: [{
            label: 'Dataset',
            data: [12, 19, 3],
            backgroundColor: [
                'rgba(67, 97, 238, 0.7)',
                'rgba(58, 12, 163, 0.7)',
                'rgba(114, 9, 183, 0.7)'
            ],
            borderWidth: 0,
            borderRadius: 4
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: { labels: { font: { family: 'Source Sans 3' } } }
        }
    }
});
</script>
```

---

## HTML Boilerplate

Use this as the starting point for all HTML visualizations:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>[Visualization Title]</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Source+Sans+3:wght@400;600&display=swap" rel="stylesheet">
    <style>
        /* CSS custom properties and theme */
        /* Layout */
        /* Component styles */
        /* Responsive adjustments */
    </style>
</head>
<body>
    <!-- Content -->
    <script>
        // Interactivity (if needed)
    </script>
</body>
</html>
```
