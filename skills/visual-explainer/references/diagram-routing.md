# Diagram Routing Reference

This file contains detailed routing logic for selecting the right diagram type,
format, and approach based on the user's request and codebase characteristics.

---

## Primary Routing Table

| User Intent | Diagram Type | Format | C4 Level | Max Nodes |
|---|---|---|---|---|
| "Show me the architecture" | C4 Context or Container | Mermaid | L1 or L2 | 15 |
| "How do services communicate?" | C4 Container + Sequence | Mermaid | L2 | 20 |
| "What's inside this service?" | C4 Component | PlantUML | L3 | 25 |
| "Show the API flow" | Sequence diagram | Mermaid | — | 12 participants |
| "How does this function work?" | Flowchart | Mermaid | — | 15 |
| "Show the data model" | ER diagram | Mermaid | — | 20 entities |
| "What states can X be in?" | State diagram | Mermaid | — | 12 |
| "Show the deployment" | Deployment diagram | PlantUML | — | 15 |
| "Compare metrics/data" | Chart or data table | HTML | — | — |
| "Explain to non-technical" | C4 Context + annotations | Mermaid | L1 | 8 |
| "How do users interact?" | User journey / flowchart | Mermaid | — | 12 |

---

## Format Decision Matrix

### When to use Mermaid (Default)
- Output will be rendered in GitHub, GitLab, Notion, Obsidian, or VS Code
- Diagram has fewer than 20 nodes
- Token budget is constrained
- Quick turnaround needed
- Sequence diagrams, flowcharts, ER diagrams, state diagrams
- C4 Level 1-2 diagrams

### When to use PlantUML
- Diagram has 20-50 nodes
- Formal C4 diagrams with full notation (Person, System_Boundary, ContainerDb, etc.)
- Need precise UML semantics (stereotypes, notes, packages)
- Class diagrams with methods and attributes
- Complex deployment diagrams with nested boundaries
- Need LAYOUT_WITH_LEGEND() or other advanced layout control

### When to use HTML/SVG
- Presentation-quality output needed
- Interactive elements (hover, click, expand/collapse)
- Custom branding or color schemes
- Dashboard-style visualizations with Chart.js
- Data tables with sorting/filtering
- Animated explanations
- Self-contained deliverable for stakeholders

---

## Content Type → Rendering Approach

### Architecture Overview
```
Approach: C4 model (start at Context, drill into Container)
Primary:  Mermaid C4 syntax or flowchart with subgraphs
Fallback: PlantUML with C4-PlantUML stdlib
Template: templates/c4-context.mermaid, templates/c4-container.mermaid
```

### API / Request Flow
```
Approach: Sequence diagram tracing HTTP request through layers
Primary:  Mermaid sequenceDiagram
Fallback: PlantUML sequence with boundary/control/entity participants
Template: templates/sequence-api.mermaid
Trace:    Controller → Service → Repository → Database
Include:  alt/else for error paths, opt for optional steps
```

### Business Logic / Algorithm
```
Approach: Flowchart mapping control flow
Primary:  Mermaid flowchart TD (top-down) or LR (left-right)
Mapping:  if/else → diamond, loop → back-arrow, try/catch → error branch
Limit:    15 nodes max, use subgraphs for grouping
```

### Data Model / Schema
```
Approach: ER diagram showing entities and relationships
Primary:  Mermaid erDiagram
Include:  Cardinality (||--o{, }|--|{, etc.), key attributes
Organize: Group by bounded context or domain
```

### System States / Lifecycle
```
Approach: State diagram showing transitions
Primary:  Mermaid stateDiagram-v2
Include:  Entry/exit actions, guard conditions, composite states
```

### Microservices Communication
```
Approach: C4 Container + overlay with communication patterns
Show:     Sync (HTTP/gRPC) vs Async (queues/events)
Annotate: Protocol, message format, direction
Split:    One diagram per bounded context if >15 services
```

### Deployment / Infrastructure
```
Approach: Deployment diagram with infrastructure boundaries
Primary:  PlantUML deployment (richer notation)
Fallback: Mermaid flowchart with subgraphs for environments
Include:  Cloud regions, clusters, networking boundaries
```

---

## Complexity Thresholds

| Complexity | Strategy |
|---|---|
| Simple (1-8 nodes) | Single diagram, Mermaid |
| Medium (8-20 nodes) | Single diagram with subgraphs, Mermaid |
| Complex (20-35 nodes) | Split into 2-3 focused diagrams, or use PlantUML |
| Very Complex (35+ nodes) | Hierarchical approach: overview + detail diagrams |

### Splitting Strategy for Complex Systems
1. **Overview diagram**: C4 Level 1 showing all systems (max 8 nodes)
2. **Per-domain diagrams**: C4 Level 2 for each major subsystem
3. **Flow diagrams**: Sequence diagrams for critical user journeys
4. **Detail diagrams**: C4 Level 3 or ER for specific components on request

---

## Multi-Diagram Sets

When a deep analysis is requested, produce this standard set:

1. **System Context** (C4 L1) — Who uses the system and what external systems it talks to
2. **Container Overview** (C4 L2) — Major deployable units and their communication
3. **Key Flow Sequence** — The most important user journey as a sequence diagram
4. **Data Model** (if applicable) — Core entities and their relationships

Label each diagram clearly and explain how they relate to each other.

---

## Auto-Detection Signals

### "This is an architecture question" signals:
- Multiple services, containers, or deployable units detected
- docker-compose.yml or Kubernetes manifests present
- Multiple database connections configured
- Message queue dependencies found
- API gateway or load balancer configuration present

### "This is a flow question" signals:
- User mentions "request", "flow", "journey", "process", "step by step"
- Single endpoint or function being discussed
- Authentication/authorization flow mentioned
- Error handling or retry logic discussed

### "This is a data question" signals:
- Database schema files present
- ORM entity definitions being discussed
- Migration files referenced
- Data relationships or cardinality mentioned
