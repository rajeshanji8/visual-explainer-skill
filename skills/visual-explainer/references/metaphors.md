# Technical-to-Layman Translation Dictionary

Use these metaphors and translations when explaining architecture
to non-technical audiences (PMs, executives, stakeholders).

---

## Core Infrastructure Metaphors

| Technical Term | Layman Metaphor | Expanded Explanation |
|---|---|---|
| API | **Restaurant waiter** | Takes your order (request), brings it to the kitchen (server), and delivers your food (response). You never need to enter the kitchen yourself. |
| REST API | **A menu with numbered items** | Each item on the menu (endpoint) gives you a specific thing. You just say the number and what you want (GET, POST). |
| Microservices | **Specialist team members** | Instead of one person doing everything, you have a payment specialist, an inventory specialist, a shipping specialist. You can replace one without retraining everyone. |
| Monolith | **Swiss Army knife** | One tool that does everything. Convenient to carry, but if the scissors break, you lose the whole knife. |
| Database | **Library with a card catalog** | Books (data) organized on shelves, with an index (indexes) so you can find things quickly without searching every shelf. |
| Relational Database | **Spreadsheet collection** | Multiple connected spreadsheets where customer info in one sheet links to their orders in another sheet via a shared ID number. |
| NoSQL Database | **Filing cabinet** | Each folder (document) contains everything about one topic, stored however makes sense. No strict column rules like a spreadsheet. |
| Message Queue | **Postal service** | Drop a letter (message) in the mailbox, go about your business. It gets delivered when the recipient is ready — you don't have to wait by their door. |
| Cache | **Quick-access notepad** | Instead of walking to the filing cabinet every time someone asks the same question, you write the answer on a sticky note on your desk. |
| Load Balancer | **Traffic director** | Stands at the intersection and directs cars (requests) to different roads (servers) so no single road gets gridlocked. |
| CDN | **Local convenience stores** | Instead of everyone driving to the warehouse (origin server), copies of popular items are stocked at corner stores (edge servers) near you. |
| Container (Docker) | **Standardized shipping box** | Your software packed in a standardized box that works the same whether it's on a truck, ship, or plane (any server/cloud). |
| Kubernetes | **Shipping logistics manager** | Decides which trucks carry which containers, replaces damaged containers, and scales up deliveries during peak season — all automatically. |
| CI/CD Pipeline | **Assembly line with quality checks** | Code goes through an automated assembly line — built, tested, inspected — and only reaches customers if it passes every checkpoint. |
| Gateway | **Building reception desk** | Everyone enters through the lobby. The receptionist checks your ID (authentication), directs you to the right floor (routing), and logs your visit. |
| Webhook | **Automatic notification** | Like setting up a text alert — when something happens (a payment completes), you automatically get notified without having to keep checking. |

---

## Architecture Patterns

| Technical Pattern | Layman Explanation |
|---|---|
| Client-Server | Like a customer (your phone/browser) asking a shopkeeper (server) for products — the customer requests, the shop serves. |
| Event-Driven | Like a newsroom: when something happens (an event), relevant reporters (services) are automatically notified and spring into action. |
| Pub/Sub | Like a magazine subscription: publishers create content, subscribers who opted in automatically receive it. You don't need to know who reads your magazine. |
| CQRS | Like having separate counters for placing orders (write) and picking up orders (read) — each optimized for its specific job. |
| Saga Pattern | Like a wedding planner coordinating multiple vendors — if the caterer cancels, the planner knows to also cancel the table rentals and notify the florist. |
| Circuit Breaker | Like an electrical circuit breaker in your house — if a service keeps failing, the system "trips the breaker" to prevent cascading damage, and periodically checks if it's safe to reconnect. |
| Service Mesh | Like an internal mail system between departments — instead of each department managing its own deliveries, a central mail room handles routing, tracking, and priority. |

---

## Security Concepts

| Technical Term | Layman Explanation |
|---|---|
| Authentication | **Checking your ID** — proving you are who you say you are (like showing your driver's license). |
| Authorization | **Checking your permissions** — you've proven your identity, but are you allowed in the VIP section? |
| OAuth / SSO | **Using your hotel key card everywhere** — you check in once (log in to Google), and that key card works at the pool, gym, and restaurant (other apps). |
| Encryption | **Writing in secret code** — even if someone intercepts the letter, they can't read it without the decoder ring (key). |
| TLS/HTTPS | **An armored envelope** — your data travels in a sealed, tamper-proof envelope that only the intended recipient can open. |
| Firewall | **A security guard at the door** — checks everyone coming in, only lets in people on the approved list, blocks suspicious visitors. |
| Rate Limiting | **A bouncer counting entries** — only lets a certain number of people in per hour to prevent overcrowding (system overload). |
| JWT Token | **A wristband at a festival** — once you show ID at the gate (login), you get a wristband (token) that lets you access areas without showing ID again. It expires at the end of the day. |

---

## Data Concepts

| Technical Term | Layman Explanation |
|---|---|
| Schema | **A blueprint/template** — defines what information goes where, like a form that specifies "Name goes here, Date goes there." |
| Migration | **Renovating the database** — changing the room layout (schema) while keeping all the furniture (data) intact. Like remodeling a kitchen without throwing away your dishes. |
| Index | **A book's index** — lets you jump directly to the page about "pandas" instead of reading the entire book to find it. |
| Replication | **Making photocopies** — keeping identical copies of your database on multiple servers, so if one breaks, others have the same information. |
| Sharding | **Splitting the phone book** — A-M in one book, N-Z in another. Each is smaller and faster to search. |
| Transaction | **An all-or-nothing deal** — either the entire bank transfer completes (money leaves your account AND arrives in theirs) or nothing happens. No halfway. |
| ORM | **A translator** — converts between how programmers think about data (objects) and how databases store it (tables). Speaks both languages. |

---

## DevOps / Infrastructure

| Technical Term | Layman Explanation |
|---|---|
| Scaling Horizontally | **Hiring more workers** — instead of making one worker faster, you add more workers to handle the extra load. |
| Scaling Vertically | **Giving your worker a bigger desk** — same person, but more powerful equipment to handle the workload. |
| Health Check | **Taking the system's pulse** — an automated "are you still alive and working?" ping sent every few seconds. |
| Blue-Green Deployment | **Building the new store next door** — the new version runs alongside the old one. Once ready, you redirect customers to the new store. If something's wrong, send them back to the old one. |
| Canary Release | **Taste-testing before serving** — give the new version to 5% of users first. If nobody complains, gradually serve it to everyone. |
| Rollback | **Ctrl+Z for deployments** — something went wrong, so we go back to the previous version that was working fine. |
| Observability / Monitoring | **Security cameras for your system** — you can watch what's happening inside in real-time, spot problems, and review what happened after an incident. |
| Logging | **Keeping a diary** — the system writes down everything it does, so if something goes wrong, you can trace back through the diary to find out what happened and when. |

---

## Usage Guidelines

1. **Lead with the metaphor**, then provide the technical term: "The API is like a restaurant waiter — it's the interface your app uses to request data."
2. **Annotate diagram elements** with the "so what?" test: not "PostgreSQL cluster with read replicas" but "This is where we keep all customer information safe, with backup copies in case of failure."
3. **Avoid mixing metaphors** — if you start with a "restaurant" metaphor for APIs, don't switch to a "library" metaphor for the same concept mid-explanation.
4. **Adjust depth to audience**: executives want outcomes ("keeps customer data safe"), PMs want capabilities ("supports 10,000 concurrent users"), developers want specifics ("PostgreSQL 15 with streaming replication").
5. **When in doubt, use the C4 Level 1 diagram** — it's specifically designed to be "the sort of diagram you could show to non-technical people" (Simon Brown).
