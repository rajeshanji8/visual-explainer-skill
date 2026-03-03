# C4 Diagram Syntax Reference

Complete syntax reference for generating C4 architecture diagrams in both
Mermaid and PlantUML formats.

---

## Mermaid C4 Syntax

> Note: Mermaid C4 support is experimental. For complex C4, prefer PlantUML.

### System Context Diagram (Level 1)

```mermaid
C4Context
    title System Context Diagram — [System Name]

    Person(user, "User", "Description of the user role")
    Person(admin, "Administrator", "Manages system configuration")

    System(system, "System Name", "Brief system description")

    System_Ext(email, "Email Service", "Sends transactional emails")
    System_Ext(payment, "Payment Gateway", "Processes payments")

    Rel(user, system, "Uses", "HTTPS")
    Rel(admin, system, "Manages", "HTTPS")
    Rel(system, email, "Sends emails via", "SMTP/API")
    Rel(system, payment, "Processes payments through", "HTTPS/API")

    UpdateLayoutConfig($c4ShapeInRow="3", $c4BoundaryInRow="1")
```

### Container Diagram (Level 2)

```mermaid
C4Container
    title Container Diagram — [System Name]

    Person(user, "User", "End user of the system")

    System_Boundary(boundary, "System Name") {
        Container(web, "Web Application", "React, TypeScript", "Serves the SPA to users")
        Container(api, "API Server", "Node.js, Express", "Handles business logic and REST API")
        ContainerDb(db, "Database", "PostgreSQL 15", "Stores user data and transactions")
        ContainerQueue(queue, "Message Queue", "RabbitMQ", "Async task processing")
        Container(worker, "Worker Service", "Node.js", "Processes background jobs")
    }

    System_Ext(email, "Email Service", "SendGrid")

    Rel(user, web, "Visits", "HTTPS")
    Rel(web, api, "Makes API calls to", "HTTPS/JSON")
    Rel(api, db, "Reads/writes", "TCP/SQL")
    Rel(api, queue, "Publishes tasks to", "AMQP")
    Rel(queue, worker, "Delivers tasks to", "AMQP")
    Rel(worker, email, "Sends emails via", "HTTPS/API")

    UpdateLayoutConfig($c4ShapeInRow="3", $c4BoundaryInRow="1")
```

### Component Diagram (Level 3)

> Mermaid C4 supports Component() but layout control is limited.
> For complex L3 diagrams (>10 components), prefer PlantUML.

```mermaid
C4Component
    title Component Diagram — API Application

    Container_Boundary(api, "API Application") {
        Component(authCtrl, "Auth Controller", "Spring @RestController", "Handles login, signup, token refresh")
        Component(orderCtrl, "Order Controller", "Spring @RestController", "CRUD operations for orders")
        Component(authSvc, "Auth Service", "Spring @Service", "Authentication and authorization logic")
        Component(orderSvc, "Order Service", "Spring @Service", "Order processing business rules")
        Component(userRepo, "User Repository", "Spring @Repository", "User data access")
        Component(orderRepo, "Order Repository", "Spring @Repository", "Order data access")
        Component(eventPub, "Event Publisher", "Spring @Component", "Publishes domain events to queue")
    }

    ContainerDb(db, "Database", "PostgreSQL", "Stores all persistent data")
    ContainerQueue(mq, "Message Broker", "RabbitMQ", "Routes async events")
    System_Ext(idp, "Identity Provider", "Auth0")

    Rel(authCtrl, authSvc, "Delegates to")
    Rel(orderCtrl, orderSvc, "Delegates to")
    Rel(authSvc, userRepo, "Reads/writes users")
    Rel(authSvc, idp, "Validates tokens with", "HTTPS/OIDC")
    Rel(orderSvc, orderRepo, "Reads/writes orders")
    Rel(orderSvc, eventPub, "Publishes order events")
    Rel(userRepo, db, "SQL queries", "JDBC")
    Rel(orderRepo, db, "SQL queries", "JDBC")
    Rel(eventPub, mq, "Sends events", "AMQP")

    UpdateLayoutConfig($c4ShapeInRow="3", $c4BoundaryInRow="1")
```

### Available Mermaid C4 Elements

| Element | Syntax | Use For |
|---|---|---|
| Person | `Person(id, "Name", "Desc")` | Human users |
| External Person | `Person_Ext(id, "Name", "Desc")` | External human actors |
| System | `System(id, "Name", "Desc")` | Your system |
| External System | `System_Ext(id, "Name", "Desc")` | Third-party systems |
| System Boundary | `System_Boundary(id, "Name") { }` | Groups containers |
| Container | `Container(id, "Name", "Tech", "Desc")` | Deployable unit |
| Container DB | `ContainerDb(id, "Name", "Tech", "Desc")` | Database |
| Container Queue | `ContainerQueue(id, "Name", "Tech", "Desc")` | Message queue |
| Component | `Component(id, "Name", "Tech", "Desc")` | Internal component |
| Relationship | `Rel(from, to, "Label", "Tech")` | Directed relationship |
| Back Relationship | `Rel_Back(from, to, "Label")` | Reverse direction |
| Layout Config | `UpdateLayoutConfig(...)` | Layout tuning |

---

## PlantUML C4 Syntax (Recommended for Complex Diagrams)

### Include Directives

```plantuml
@startuml
!include <C4/C4_Context>
' OR for container level:
!include <C4/C4_Container>
' OR for component level:
!include <C4/C4_Component>
' OR for deployment:
!include <C4/C4_Deployment>
```

### System Context Diagram (Level 1)

```plantuml
@startuml C4_SystemContext
!include <C4/C4_Context>

title System Context Diagram — [System Name]

Person(user, "User", "A user of the system")
Person(admin, "Administrator", "System administrator")

System(system, "System Name", "Provides core functionality including X, Y, Z")

System_Ext(email, "Email Service", "External email delivery service")
System_Ext(payment, "Payment Gateway", "Third-party payment processor")
SystemDb_Ext(analytics, "Analytics Platform", "External analytics and reporting")

Rel(user, system, "Uses to do X", "HTTPS")
Rel(admin, system, "Manages configuration", "HTTPS")
Rel(system, email, "Sends transactional emails", "SMTP")
Rel(system, payment, "Submits payment requests", "HTTPS/REST")
Rel(system, analytics, "Sends events", "HTTPS")

LAYOUT_WITH_LEGEND()
@enduml
```

### Container Diagram (Level 2)

```plantuml
@startuml C4_Container
!include <C4/C4_Container>

title Container Diagram — [System Name]

Person(user, "User", "End user")

System_Boundary(boundary, "System Name") {
    Container(spa, "Single-Page App", "React, TypeScript", "Delivers the UI experience")
    Container(api, "API Application", "Java, Spring Boot", "Handles all business logic via REST API")
    Container(worker, "Background Worker", "Java, Spring Boot", "Processes async tasks from queue")
    ContainerDb(db, "Database", "PostgreSQL 15", "Stores users, orders, products")
    ContainerDb(cache, "Cache", "Redis 7", "Session storage and query caching")
    ContainerQueue(mq, "Message Broker", "RabbitMQ", "Routes async commands and events")
}

System_Ext(idp, "Identity Provider", "Auth0 / Okta")
System_Ext(cdn, "CDN", "CloudFront")

Rel(user, cdn, "Loads app from", "HTTPS")
Rel(cdn, spa, "Serves", "HTTPS")
Rel(spa, api, "Calls", "HTTPS/JSON")
Rel(api, db, "Reads/Writes", "JDBC")
Rel(api, cache, "Caches queries", "Redis protocol")
Rel(api, mq, "Publishes commands", "AMQP")
Rel(mq, worker, "Delivers tasks", "AMQP")
Rel(api, idp, "Validates tokens", "HTTPS/OIDC")
Rel(worker, db, "Updates", "JDBC")

LAYOUT_WITH_LEGEND()
@enduml
```

### Component Diagram (Level 3)

```plantuml
@startuml C4_Component
!include <C4/C4_Component>

title Component Diagram — API Application

Container_Boundary(api, "API Application") {
    Component(authCtrl, "Auth Controller", "Spring @RestController", "Handles login, signup, token refresh")
    Component(orderCtrl, "Order Controller", "Spring @RestController", "CRUD operations for orders")
    Component(authSvc, "Auth Service", "Spring @Service", "Authentication and authorization logic")
    Component(orderSvc, "Order Service", "Spring @Service", "Order processing business rules")
    Component(userRepo, "User Repository", "Spring @Repository", "User data access")
    Component(orderRepo, "Order Repository", "Spring @Repository", "Order data access")
    Component(eventPub, "Event Publisher", "Spring @Component", "Publishes domain events to queue")
}

ContainerDb(db, "Database", "PostgreSQL")
ContainerQueue(mq, "Message Broker", "RabbitMQ")
System_Ext(idp, "Identity Provider", "Auth0")

Rel(authCtrl, authSvc, "Delegates to")
Rel(orderCtrl, orderSvc, "Delegates to")
Rel(authSvc, userRepo, "Reads/writes users")
Rel(authSvc, idp, "Validates tokens with")
Rel(orderSvc, orderRepo, "Reads/writes orders")
Rel(orderSvc, eventPub, "Publishes order events")
Rel(userRepo, db, "SQL queries")
Rel(orderRepo, db, "SQL queries")
Rel(eventPub, mq, "Sends events")

LAYOUT_WITH_LEGEND()
@enduml
```

### Available PlantUML C4 Macros

| Macro | Include File | Purpose |
|---|---|---|
| `Person(id, name, desc)` | C4_Context | Human user |
| `Person_Ext(id, name, desc)` | C4_Context | External human |
| `System(id, name, desc)` | C4_Context | Internal system |
| `System_Ext(id, name, desc)` | C4_Context | External system |
| `SystemDb(id, name, desc)` | C4_Context | Internal database system |
| `SystemDb_Ext(id, name, desc)` | C4_Context | External database system |
| `System_Boundary(id, name)` | C4_Context | Boundary grouping |
| `Container(id, name, tech, desc)` | C4_Container | Deployable container |
| `ContainerDb(id, name, tech, desc)` | C4_Container | Database container |
| `ContainerQueue(id, name, tech, desc)` | C4_Container | Message queue |
| `Container_Boundary(id, name)` | C4_Container | Container boundary |
| `Component(id, name, tech, desc)` | C4_Component | Internal component |
| `Rel(from, to, label, tech?)` | All | Relationship |
| `Rel_Back(from, to, label)` | All | Reverse relationship |
| `Rel_Neighbor(from, to, label)` | All | Side-by-side layout hint |
| `Rel_D(from, to, label)` | All | Downward relationship |
| `Rel_U(from, to, label)` | All | Upward relationship |
| `Rel_L(from, to, label)` | All | Leftward relationship |
| `Rel_R(from, to, label)` | All | Rightward relationship |
| `LAYOUT_WITH_LEGEND()` | All | Adds color legend |
| `LAYOUT_TOP_DOWN()` | All | Forces top-down layout |
| `LAYOUT_LEFT_RIGHT()` | All | Forces left-right layout |

---

## Syntax Pitfalls and Fixes

### Mermaid C4 Pitfalls
1. `UpdateLayoutConfig` parameters must use `$` prefix: `$c4ShapeInRow="3"`
2. Descriptions in quotes must not contain unescaped quotes
3. Container types (`ContainerDb`, `ContainerQueue`) are case-sensitive
4. Boundary blocks must use `{ }` braces
5. `Rel` requires at minimum `(from, to, "label")` — tech is optional

### PlantUML C4 Pitfalls
1. Include paths are case-sensitive: `!include <C4/C4_Container>` not `c4/c4_container`
2. Must wrap in `@startuml` / `@enduml`
3. Boundary blocks use `{ }` and children must be indented
4. Long descriptions should use `\n` for line breaks within the macro
5. `LAYOUT_WITH_LEGEND()` must be OUTSIDE any boundary block

---

## Choosing Between Mermaid and PlantUML for C4

| Factor | Mermaid | PlantUML |
|---|---|---|
| Token cost | Lower (~40% fewer) | Higher |
| GitHub rendering | Native ✓ | Requires server/extension |
| C4 maturity | Experimental | Production-ready |
| Max comfortable nodes | ~15 | ~50 |
| Layout control | Limited | Extensive |
| Participant types | Basic | Rich (boundary, control, entity, database, queue) |
| Legend support | None | `LAYOUT_WITH_LEGEND()` |
| Deployment diagrams | Basic | Full C4_Deployment support |

**Rule of thumb**: Use Mermaid for L1-L2 with ≤15 nodes; use PlantUML for L3+ or >15 nodes.
