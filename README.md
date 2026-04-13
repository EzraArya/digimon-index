# NDS iOS Assignment

## 🏛 Architecture
This project follows a strict **Clean Architecture + MVVM** pattern to ensure the codebase remains maintainable, testable, and scalable.

### Layers:
1. **Presentation (UI)**: ViewControllers handle zero business logic, focusing entirely on layout and state observation.
2. **ViewModel**: Manages the state and maps Domain models to View identifiers using Diffable Data Source snapshots.
3. **Domain (UseCases/Entities)**: Contains the pure business logic and repository protocols.
4. **Data (Repository/Network)**: Handles data fetching, JSON mapping, and physical connectivity error catching.

---

