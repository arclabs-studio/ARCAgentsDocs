# Karpathy Guidelines — Swift/iOS Examples

Extended examples adapted for iOS/Swift development. Each shows what Claude commonly does wrong and what should happen instead.

---

## 1. Think Before Coding

### Example: Ambiguous Data Model Request

**User:** "Add a notes field to restaurants."

**❌ Wrong — silent assumptions:**
```swift
// Added 'notes: String?' to RestaurantModel, RestaurantDTO,
// RestaurantEntity, RestaurantToVisitDTO, and the JSON migration.
// Also added a NoteView + NoteViewModel.
```

**✅ Right — surface assumptions:**
```
Before implementing, I need to clarify:
1. **Scope** — notes per restaurant or per visit?
2. **Persistence** — SwiftData only, or also export to JSON?
3. **UI** — edit inline in detail view, or separate screen?
4. **Length** — short (1–2 lines) or long-form (markdown)?

Minimal approach: add `notes: String?` to RestaurantModel + expose it in RestaurantDetailView.
Would that cover the use case?
```

### Example: Performance Request

**User:** "Make the restaurant list faster."

**❌ Wrong — picks one interpretation silently:**
```swift
// Added LazyVStack, image caching, pagination, prefetching,
// background context, and Instruments-guided frame budget.
```

**✅ Right — clarify what "faster" means:**
```
"Faster" could mean:
1. **Scroll frame rate** — LazyVStack + image caching (2–3 hours)
2. **Initial load** — paginate or stream from SwiftData (4+ hours)
3. **Search response** — index on name field (30 min)

Which bottleneck are you seeing?
```

---

## 2. Simplicity First

### Example: ViewModel State

**User:** "Add a loading indicator."

**❌ Wrong — over-engineered:**
```swift
enum RequestState<T: Sendable>: Sendable {
    case idle, loading(progress: Double?), success(T), failure(Error), cancelled
}

actor LoadingCoordinator<T: Sendable> { ... }
```

**✅ Right — minimum viable:**
```swift
var isLoading = false

func loadRestaurants() async {
    isLoading = true
    defer { isLoading = false }
    restaurants = (try? await getRestaurantsUseCase.execute()) ?? []
}
```
(Use `LoadingState<T>` only if the existing codebase already uses it everywhere — match existing style.)

### Example: Protocol Extraction

**User:** "Add a geocoding call when saving a restaurant."

**❌ Wrong — premature abstraction:**
```swift
protocol GeocodingClientProtocol: Sendable { ... }
protocol GeocodingCacheProtocol { ... }
struct GeocodingConfiguration { ... }
class GeocodingRepository: GeocodingRepositoryProtocol { ... }
```

**✅ Right — only what's needed:**
```swift
// If GeocodingService already exists and only one impl is planned:
final class AddRestaurantUseCase: AddRestaurantUseCaseProtocol {
    private let geocodingService: GeocodingServiceProtocol // existing protocol
    ...
}
```

---

## 3. Surgical Changes

### Example: Fixing a Crash in One View

**User:** "Fix the crash in RestaurantDetailView when restaurant is nil."

**❌ Wrong — touches adjacent code:**
```swift
// Fixed nil crash.
// Also: renamed 'restaurantView' → 'contentView',
// converted 'onTappedFavorite' to async/await,
// updated MARK sections, added missing .accessibilityLabel.
```

**✅ Right — only the crash:**
```swift
// Guard added; everything else unchanged.
guard let restaurant else {
    return EmptyView()
}
```

(Note adjacent issues in the PR description, not as code changes.)

### Example: ARCDesignSystem Token Update

**User:** "Change the card corner radius to 16."

**❌ Wrong — reformats unrelated views:**
```swift
// Updated RestaurantCard corner radius.
// Also: fixed spacing in FavoriteRow (was using .arcSpacingSmall, now .arcSpacingMedium),
// added arcWithAnimation() to all list animations.
```

**✅ Right — one change, one line:**
```swift
.clipShape(.rect(cornerRadius: 16)) // was: .arcCornerRadiusSmall
```

---

## 4. Goal-Driven Execution

### Example: Bug Fix → Test-First

**User:** "Fix the toggle favorite bug — it's not persisting."

**❌ Wrong — guess at fix, no verification:**
```swift
// Changed 'updateFavoriteStatus' call in ViewModel. Seems to work now.
```

**✅ Right — define success criterion first:**
```
Plan:
1. Write @Test reproducing the bug:
   - call ToggleFavoriteUseCase.execute
   - re-fetch restaurant
   - #expect(restaurant.isFavorite == true)
   → verify: test fails (red)
2. Fix the persistence call in RestaurantRepository.updateFavoriteStatus
   → verify: test passes (green)
3. Run full test suite
   → verify: zero regressions
```

### Example: Refactor → Safe Criteria

**User:** "Refactor SearchViewModel to use the new SearchRestaurantsUseCase."

```
Plan:
1. Ensure existing SearchViewModelTests pass → baseline green
2. Replace inline filter logic with SearchRestaurantsUseCase call
   → verify: same tests still pass
3. Delete dead filter code → #expect(viewModel.results == expectedResults) still passes
4. Grep for removed method names → no lingering callers
```
