# /analyze-architecture — Full Architecture Analysis

Perform a comprehensive architecture analysis of the target codebase and produce
a multi-level visual documentation set.

---

## Trigger

Use this prompt when the user says:
- "Analyze the architecture"
- "Show me the full system architecture"
- "Document this codebase"
- "Map out all services and components"
- "Give me a complete architecture overview"

---

## Workflow

### Step 1: Gather High-Signal Files

Read files in this EXACT priority order, stopping when you have enough signal:

1. **Dependency manifests** — Reveal technology stack and infrastructure
   - `pom.xml`, `build.gradle` (Java/Kotlin)
   - `package.json` (Node.js/TypeScript)
   - `*.csproj`, `Directory.Build.props` (.NET)
   - `go.mod` (Go)
   - `requirements.txt`, `pyproject.toml`, `Pipfile` (Python)
   - `Cargo.toml` (Rust)
   - `Gemfile` (Ruby)

2. **Configuration files** — Reveal infrastructure topology
   - `docker-compose.yml`, `docker-compose.*.yml`
   - `application.yml`, `application.properties`, `application-*.yml` (Spring)
   - `appsettings.json`, `appsettings.*.json` (.NET)
   - `.env`, `.env.example`
   - `Dockerfile`, `*.Dockerfile`
   - Kubernetes manifests (`k8s/`, `deploy/`, `helm/`)

3. **Project structure** — Reveal architectural patterns
   - Full directory tree (top 3 levels)
   - Count of `main` entry points, `Dockerfile`s, `package.json`s (monolith vs microservices)

4. **API surface** — Reveal system boundaries
   - Controller/route files
   - OpenAPI/Swagger specs
   - GraphQL schema files
   - gRPC proto files

5. **Service layer** — Reveal business logic structure
   - Service classes/modules
   - Use case / command handler files

6. **Data layer** — Reveal data model
   - Entity/model definitions
   - Database migration files
   - Schema files

### Step 2: Detect Architecture Pattern

Based on gathered signals, classify as:
- **Monolith**: Single entry point, one deployment unit, shared database
- **Modular Monolith**: Single deployment unit but clear module boundaries (packages/namespaces)
- **Microservices**: Multiple entry points, separate databases, inter-service communication
- **Serverless**: Lambda/Function definitions, API Gateway config, event triggers
- **Hybrid**: Mix of patterns (common — document each part)

### Step 3: Generate Diagram Set

Produce the following diagrams (adjust based on complexity):

#### Required:
1. **System Context Diagram (C4 Level 1)**
   - The system as one box, surrounded by users and external systems
   - Label all relationships with what flows
   - ≤8 nodes

2. **Container Diagram (C4 Level 2)**
   - Expand system into deployable containers
   - Show technology choices and communication protocols
   - ≤15 nodes; split if needed

#### If applicable:
3. **Component Diagram (C4 Level 3)** — for the most complex or important container
4. **Sequence Diagram** — for the primary user journey (e.g., signup, checkout, API request)
5. **ER Diagram** — if data model is central to understanding

### Step 4: Write Summary

Provide a structured summary alongside diagrams:

```markdown
## Architecture Overview

**Pattern**: [Monolith | Microservices | Serverless | Hybrid]
**Stack**: [Primary languages and frameworks]
**Database(s)**: [Types and purposes]
**Messaging**: [Queue/event systems if any]
**External Services**: [Third-party integrations]

### Key Observations
- [Notable architectural decisions]
- [Potential concerns or anti-patterns]
- [Strengths of the current design]
```

---

## Output Format

- Use Mermaid for all diagrams by default (unless >20 nodes, then PlantUML)
- Each diagram in a fenced code block with correct language identifier
- Textual summary before/after each diagram explaining what it shows
- If multiple diagrams, number them and explain how they relate

---

## Example Output Structure

Output should follow this pattern, with each section as a markdown heading:

**1. System Context (Who uses the system?)**
- Brief explanation of what the diagram shows
- A Mermaid `C4Context` diagram in a fenced code block
- ≤8 nodes: users + system + external systems

**2. Container Overview (What's inside?)**
- Brief explanation of the system's internal containers
- A Mermaid `C4Container` diagram in a fenced code block
- ≤15 nodes: web app, API, database, queue, workers, etc.

**3. Primary Flow (How does a request travel through the system?)**
- Brief explanation of the most important user journey
- A Mermaid `sequenceDiagram` in a fenced code block
- Trace: User → Frontend → API → Service → Database

**4. Key Observations**
- Bullet points with notable architectural decisions
- Any concerns or anti-patterns detected
- Strengths of the current design
