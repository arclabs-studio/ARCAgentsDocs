# 🧩 Domain Use Case Patterns

**Reusable structural patterns for domain use cases across ARC Labs Studio apps. These are patterns to follow, not code to share — each app implements its own version with domain-specific types.**

> **Philosophy**: Share mechanisms (ARCStorage, ARCNetworking), not business rules. Duplicate 20 lines of domain-specific logic rather than couple independent apps via shared abstractions.

---

## 📋 Decision Guide

Before extracting shared code, ask:

1. **Is the pattern identical or just structurally similar?** If types differ (CuisineType vs Genre), it's structural similarity — document the pattern, don't share the code.
2. **Is the logic >50 lines and truly identical across 3+ apps?** Only then consider extraction — and even then, prefer Collection extensions over use case abstractions.
3. **Would a generic version be simpler than the domain-specific version?** If the generic type constraints are more complex than the logic they replace, don't generalize.

**Rule of Three**: Duplicate once, extract on the third occurrence. Two apps with similar patterns is not enough.

---

## 1️⃣ Stateless Collection Use Case

**What**: Pure function that transforms a collection without side effects or dependencies.

**When**: Filtering, sorting, searching, or transforming arrays of domain entities.

**Characteristics**:
- No dependencies (no repository, no service injection)
- `Sendable` conformance (thread-safe by design)
- Synchronous execution (no `async throws`)
- Input → Output, no state mutation

### Structure

```swift
// Protocol
protocol Filter[Entity]UseCaseProtocol: Sendable {
    func execute(items: [Entity], criteria: FilterCriteria) -> [Entity]
}

// Implementation
final class Filter[Entity]UseCase: Filter[Entity]UseCaseProtocol, Sendable {
    init() {}

    func execute(items: [Entity], criteria: FilterCriteria) -> [Entity] {
        var result = items

        if !criteria.categories.isEmpty {
            result = result.filter { criteria.categories.contains($0.category) }
        }

        if !criteria.priceRanges.isEmpty {
            result = result.filter { criteria.priceRanges.contains($0.priceRange) }
        }

        return result
    }
}
```

### Key Decisions

| Decision | Guideline |
|----------|-----------|
| Overloaded `execute()` methods | Provide convenience overloads that delegate to the most complete version (see FavRes `FilterRestaurantsUseCase`) |
| Empty criteria = no filter | `guard !criteria.isEmpty else { return items }` — empty set means "include all" |
| Sorting direction | Use enum with paired cases: `.ratingHighToLow` / `.ratingLowToHigh` |
| Text search | Trim + lowercase query first, then match against domain-specific fields |

### Reference Implementation

- **FavRes**: `FilterRestaurantsUseCase`, `SortRestaurantsUseCase`, `SearchRestaurantsUseCase`
- Pattern: each is `final class`, `Sendable`, zero dependencies, `init() {}`

---

## 2️⃣ Available Options Extraction

**What**: Extracts distinct values from a collection to populate filter UI (chips, pickers, etc.).

**When**: Building filter/facet UI that shows only options present in the current dataset.

**Characteristics**:
- Pure function (stateless, `Sendable`)
- Returns a dedicated result struct (not a tuple)
- Some options show all possible values (e.g., all cuisine types), others show only present values (e.g., only price ranges in the data)

### Structure

```swift
// Result type
struct AvailableFilters: Sendable, Equatable {
    let categories: [Category]      // All possible (from enum)
    let priceRanges: [PriceRange]   // Only present in data
    let locations: [String]          // Distinct, sorted alphabetically

    static let empty = AvailableFilters(categories: [], priceRanges: [], locations: [])
}

// Protocol
protocol GetAvailableFiltersUseCaseProtocol: Sendable {
    func execute(items: [Entity]) -> AvailableFilters
}

// Implementation
final class GetAvailableFiltersUseCase: GetAvailableFiltersUseCaseProtocol, Sendable {
    init() {}

    func execute(items: [Entity]) -> AvailableFilters {
        let categories = Category.allCases.sorted { $0.name < $1.name }
        let presentRanges = Set(items.map(\.priceRange))
        let priceRanges = PriceRange.allCases.filter { presentRanges.contains($0) }
        let locations = Set(items.map(\.location.city)).sorted()

        return AvailableFilters(categories: categories,
                                priceRanges: priceRanges,
                                locations: locations)
    }
}
```

### Key Decisions

| Decision | Guideline |
|----------|-----------|
| All vs present values | Enum-based options (CuisineType) → show all. Data-derived (cities) → show only present. |
| Result struct vs tuple | Always use a named struct with `.empty` static property. |
| Sorting | Alphabetical for strings, natural order for enums (by `rawValue` or display name). |

### Reference Implementation

- **FavRes**: `GetAvailableFiltersUseCase` + `AvailableFilters` struct

---

## 3️⃣ Boolean Toggle with Existence Check

**What**: Reads an entity, toggles a boolean property, persists the change.

**When**: Favorite/bookmark/pin toggles, read/unread status, any binary state flip.

**Characteristics**:
- Depends on Reader + Writer protocols (ISP)
- `async throws` (I/O involved)
- Validates entity exists before mutating
- Single responsibility: toggle only, no side effects

### Structure

```swift
// Protocol
protocol Toggle[Property]UseCaseProtocol: Sendable {
    func execute(entityID: UUID) async throws
}

// Implementation
final class Toggle[Property]UseCase: Toggle[Property]UseCaseProtocol {
    private let reader: EntityReaderProtocol
    private let writer: EntityWriterProtocol

    init(reader: EntityReaderProtocol, writer: EntityWriterProtocol) {
        self.reader = reader
        self.writer = writer
    }

    func execute(entityID: UUID) async throws {
        guard let entity = try await reader.fetch(by: entityID) else {
            throw DomainError.notFound
        }

        let newStatus = !entity.isFavorite
        try await writer.updateFavoriteStatus(id: entityID, isFavorite: newStatus)
    }
}
```

### Key Decisions

| Decision | Guideline |
|----------|-----------|
| Read before write | Always verify entity exists. Throw `DomainError.notFound` if missing. |
| ISP compliance | Inject `ReaderProtocol` + `WriterProtocol` separately, not a combined protocol. |
| No return value | Toggle is fire-and-forget. The caller re-fetches if needed. |
| Error propagation | Throw domain errors, never catch silently. |

### Reference Implementation

- **FavRes**: `ToggleFavoriteUseCase` (Reader + Writer injection, existence check)

---

## 4️⃣ Aggregation / Statistics

**What**: Computes metrics, groupings, and derived data from a collection of entities.

**When**: Dashboard screens, analytics views, summary cards, insights features.

**Characteristics**:
- Depends on Reader protocol (fetches data)
- `async throws` (I/O for data fetch)
- Pure computation after fetch (deterministic given same input)
- Returns a dedicated statistics struct
- **Inherently domain-specific** — this pattern is the least generalizable

### Structure

```swift
// Result type (domain-specific, NOT generic)
struct EntityStatistics: Sendable, Equatable {
    let totalCount: Int
    let averageRating: Double
    let topCategory: Category?
    let breakdownByCategory: [(category: Category, count: Int)]
    // ... more domain-specific metrics
}

// Protocol
protocol GetStatisticsUseCaseProtocol: Sendable {
    func execute() async throws -> EntityStatistics
}

// Implementation
final class GetStatisticsUseCase: GetStatisticsUseCaseProtocol {
    private let reader: EntityReaderProtocol

    init(reader: EntityReaderProtocol) {
        self.reader = reader
    }

    func execute() async throws -> EntityStatistics {
        let all = try await reader.fetchAll()

        // Partition
        let active = all.filter(\.isActive)

        // Compute
        let avgRating = computeAverage(active, keyPath: \.rating)
        let topCategory = computeTopCategory(active)
        let breakdown = computeBreakdown(active)

        return EntityStatistics(
            totalCount: active.count,
            averageRating: avgRating,
            topCategory: topCategory,
            breakdownByCategory: breakdown
        )
    }
}

// MARK: - Private Helpers

extension GetStatisticsUseCase {
    private func computeAverage(_ items: [Entity],
                                keyPath: KeyPath<Entity, Double>) -> Double {
        guard !items.isEmpty else { return 0 }
        return items.reduce(0.0) { $0 + $1[keyPath: keyPath] } / Double(items.count)
    }

    private func computeTopCategory(_ items: [Entity]) -> Category? {
        Dictionary(grouping: items, by: \.category)
            .max(by: { $0.value.count < $1.value.count })?
            .key
    }

    private func computeBreakdown(_ items: [Entity]) -> [(Category, Int)] {
        Dictionary(grouping: items, by: \.category)
            .map { ($0.key, $0.value.count) }
            .sorted { $0.1 > $1.1 }
    }
}
```

### Key Decisions

| Decision | Guideline |
|----------|-----------|
| Single fetch | Fetch all data once, compute in memory. Don't make multiple repository calls. |
| Private helpers | Extract computation into private methods with clear names. |
| Result struct | Always a dedicated struct, never a dictionary or tuple. |
| Don't generalize | Statistics are inherently domain-coupled. Each app's metrics are different. |

### Reference Implementation

- **FavRes**: `GetStatisticsUseCase` (~270 lines, 21 metrics — all Restaurant-specific)

---

## ⚠️ Anti-Patterns

### Don't Create "Generic" Use Cases

```swift
// ❌ WRONG: Over-abstracted, more complex than the logic it replaces
protocol FilterableEntity {
    associatedtype FilterAttribute: Hashable
    var filterAttributes: [PartialKeyPath<Self>: FilterAttribute] { get }
}

final class GenericFilterUseCase<T: FilterableEntity> { ... }
```

```swift
// ✅ CORRECT: Domain-specific, clear, 20 lines
final class FilterRestaurantsUseCase {
    func execute(restaurants: [Restaurant],
                 cuisineTypes: Set<CuisineType>) -> [Restaurant] {
        guard !cuisineTypes.isEmpty else { return restaurants }
        return restaurants.filter { cuisineTypes.contains($0.cuisineType) }
    }
}
```

### Don't Create Protocol Graveyards

```swift
// ❌ WRONG: Protocols that add ceremony without abstraction
protocol Filterable { }
protocol Searchable { }
protocol Sortable { }
protocol Favoritable { }

// Swift already has: Collection.filter(where:), sorted(by:), contains(where:)
```

### Don't Share Domain Entities Between Apps

```swift
// ❌ WRONG: Shared entity coupling independent apps
// In a hypothetical ARCDomain package:
struct CatalogItem: Identifiable, Sendable { ... }

// ✅ CORRECT: Each app owns its domain
// FavRes: Restaurant
// FavBook: Book
// FavMusic: Album
```

---

## 🔄 When to Revisit This Decision

Re-evaluate extraction if:

1. **Three or more apps** independently implement the same Collection extensions (e.g., `filtered(by:in:)`)
2. **A use case exceeds 100 lines** of truly identical logic across apps (not just structurally similar)
3. **The team grows** and onboarding consistency outweighs duplication cost

When extracting, add to **ARCStorage** as Collection extensions (algorithm level), never as use case abstractions (domain level).
