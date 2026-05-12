# 🎨 Code Style & Standards

**Consistent code style ensures readability, maintainability, and professional quality across all ARC Labs projects.**

---

## 🎯 Style Philosophy

### Core Principles

1. **Readability First** - Code is read far more than written
2. **Consistency Matters** - Same patterns throughout codebase
3. **Auto-Formatted** - Use tools, not manual formatting
4. **Swift-Idiomatic** - Follow Swift community conventions
5. **Self-Documenting** - Names and structure explain intent

---

## 🛠️ Tooling

### SwiftLint

**Purpose**: Enforce style rules and catch common mistakes

**Installation** (via ARCDevTools):
```bash
# ARCDevTools includes SwiftLint configuration
swift package resolve
```

**Configuration** (`.swiftlint.yml`):
```yaml
# SwiftLint Configuration for ARC Labs

disabled_rules:
  - trailing_whitespace  # SwiftFormat handles this
  - vertical_whitespace  # SwiftFormat handles this

opt_in_rules:
  - array_init
  - attributes
  - closure_end_indentation
  - closure_spacing
  - contains_over_filter_count
  - contains_over_filter_is_empty
  - contains_over_first_not_nil
  - discouraged_object_literal
  - empty_count
  - empty_string
  - explicit_init
  - fatal_error_message
  - first_where
  - flatmap_over_map_reduce
  - force_unwrapping
  - implicit_return
  - joined_default_parameter
  - last_where
  - literal_expression_end_indentation
  - multiline_arguments
  - multiline_function_chains
  - multiline_literal_brackets
  - multiline_parameters
  - operator_usage_whitespace
  - overridden_super_call
  - prefer_self_type_over_type_of_self
  - redundant_nil_coalescing
  - redundant_type_annotation
  - sorted_first_last
  - toggle_bool
  - unneeded_parentheses_in_closure_argument
  - vertical_whitespace_closing_braces
  - vertical_whitespace_opening_braces
  - yoda_condition

# Metrics
line_length:
  warning: 120
  error: 150
  ignores_function_declarations: true
  ignores_comments: true
  ignores_urls: true

file_length:
  warning: 400
  error: 500

type_body_length:
  warning: 300
  error: 400

function_body_length:
  warning: 40
  error: 60

function_parameter_count:
  warning: 5
  error: 8

cyclomatic_complexity:
  warning: 10
  error: 20

nesting:
  type_level: 2
  statement_level: 5

# Naming
identifier_name:
  min_length:
    warning: 2
    error: 1
  max_length:
    warning: 40
    error: 60
  excluded:
    - id
    - x
    - y
    - z

type_name:
  min_length: 3
  max_length: 40
  excluded:
    - ID
    - URL

# Custom Rules
custom_rules:
  no_print:
    name: "No Print Statements"
    regex: '\bprint\('
    message: "Use ARCLogger instead of print()"
    severity: warning
    
  no_force_cast:
    name: "No Force Cast"
    regex: 'as!'
    message: "Avoid force casting. Use conditional cast (as?) instead"
    severity: error
    
  no_force_try:
    name: "No Force Try"
    regex: 'try!'
    message: "Avoid force try. Use proper error handling"
    severity: error

excluded:
  - .build
  - DerivedData
  - Carthage
  - Pods
  - vendor
```

**Usage**:
```bash
# Lint all files
swiftlint

# Lint specific file
swiftlint lint --path Sources/MyFile.swift

# Auto-fix (where possible)
swiftlint --fix

# Check configuration
swiftlint rules
```

---

### Zero Warnings Policy

Warnings = errors. Never compile or commit code that has warnings.

| Warning type | Fix |
|---|---|
| Unused variable | Rename to `_` |
| Unused result | Assign to `_ =` |
| Non-Sendable closure capture | Make type `Sendable` |
| Any other compiler warning | Fix root cause |

---

### SwiftFormat

**Purpose**: Automatic code formatting

**Installation** (via ARCDevTools):
```bash
# ARCDevTools includes SwiftFormat configuration
swift package resolve
```

**Configuration** (`.swiftformat`):
```
# Indentation
--indent 4
--tabwidth 4
--xcodeindentation enabled

# Line width
--maxwidth 120

# Brace style
--allman false
--wraparguments after-first
--wrapparameters after-first
--wrapcollections after-first
--closingparen balanced

# Imports
--importgrouping testable-bottom
--stripunusedargs always

# Spacing
--trimwhitespace always
--commas never
--semicolons inline
--linebreaks lf

# Self
--self remove

# Wrapping
--wrapternary before-operators

# Attributes - Always on same line (ARC Labs style)
--type-attributes same-line
--func-attributes same-line
--stored-var-attributes same-line
--computed-var-attributes same-line
--complex-attributes same-line

# Organization
--organizetypes actor,class,enum,struct
--marktypes always
--extensionacl on-declarations

# Exclude
--exclude .build,DerivedData,Pods,Carthage,Generated
```

**Usage**:
```bash
# Format all files
swiftformat .

# Format specific file
swiftformat Sources/MyFile.swift

# Check without modifying
swiftformat --lint .
```

---

## 📏 Code Organization

### File Header

Every Swift file **MUST** have this header:

```swift
//
//  FileName.swift
//  ProjectName
//
//  Created by ARC Labs Studio on DD/MM/YYYY.
//
```

### Import Organization

```swift
// System frameworks first (alphabetically)
import Foundation
import SwiftUI
import UIKit

// Third-party dependencies (alphabetically)
import ARCLogger
import ARCNavigation

// Testable imports last
@testable import FavRes
```

### Type Organization

```swift

// MARK: - Type Declaration

struct UserProfile {
    
    // MARK: Private Properties
    
    private(set) var email: String
    
    // MARK: Public Properties
    
    let id: UUID
    let name: String
    var displayName: String {
        name.isEmpty ? "Anonymous" : name
    }
    
    // MARK: Initialization
    
    init(id: UUID, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
    
    // MARK: Public Functions
    
    func validate() -> Bool {
        // Implementation
    }
}

// MARK: - Private Functions

private extension UserProfile {
    func formatEmail() -> String {
        // Implementation
    }
}

// MARK: - Identifiable

extension UserProfile: Identifiable {
    // Identifiable conformance
}

// MARK: - Equatable

extension UserProfile: Equatable {
    // Equatable conformance
}

// MARK: - String

private extension String {
    var isValidEmail: Bool {
        // Implementation
    }
}
```

---

## 📝 Naming Conventions

### Types

```swift
// ✅ Good: PascalCase for types
struct UserProfile { }
class NetworkManager { }
enum LoadingState { }
protocol DataSource { }

// ❌ Bad
struct user_profile { }  // Not PascalCase
class networkManager { }  // Not PascalCase
```

### Variables & Constants

```swift
// ✅ Good: camelCase
let userName = "John"
var isLoading = false
private let apiClient: APIClient

// ❌ Bad
let UserName = "John"  // PascalCase
var is_loading = false  // snake_case
```

### Functions

```swift
// ✅ Good: camelCase, descriptive verbs
func loadUser() { }
func validateEmail(_ email: String) -> Bool { }
func didTapButton() { }

// ❌ Bad
func LoadUser() { }  // PascalCase
func validate(_ email: String) -> Bool { }  // Not descriptive
```

### Protocols

```swift
// ✅ Good: Descriptive, often ends with Protocol
protocol UserRepositoryProtocol { }
protocol Loggable { }
protocol DataSource { }

// ❌ Bad
protocol IUserRepository { }  // Hungarian notation
protocol User { }  // Too generic
```

### Enums

```swift
// ✅ Good: Singular noun, camelCase cases
enum LoadingState {
    case idle
    case loading
    case loaded(User)
    case failed(Error)
}

// ❌ Bad
enum LoadingStates {  // Plural
    case Idle  // PascalCase
    case isLoading  // Prefix
}
```

### Boolean Properties

```swift
// ✅ Good: is/has/should prefix
var isLoading: Bool
var hasPermission: Bool
var shouldRetry: Bool

// ❌ Bad
var loading: Bool  // Not clear it's Bool
var permission: Bool  // Not clear
```

---

## 🔤 Code Formatting

### Line Length

**Maximum**: 120 characters (warning at 120, error at 150)

```swift
// ✅ Good: Under 120 characters
func fetchUser(by id: UUID) async throws -> User {
    try await repository.getUser(by: id)
}

// ❌ Bad: Over 120 characters
func fetchUserProfileWithAllRelatedDataIncludingPostsCommentsAndFriends(by id: UUID) async throws -> CompleteUserProfile {
    // Too long!
}
```

### Indentation

**4 spaces** (no tabs)

```swift
// ✅ Good
func example() {
    if condition {
        doSomething()
    }
}

// ❌ Bad (2 spaces or tabs)
func example() {
  if condition {
      doSomething()
  }
}
```

### Braces

Opening brace on **same line**, closing brace on **new line**:

```swift
// ✅ Good
if condition {
    doSomething()
}

// ❌ Bad
if condition
{
    doSomething()
}
```

### Spacing

```swift
// ✅ Good: Space after operators
let sum = 1 + 2
let result = value ?? defaultValue

// ❌ Bad: No space
let sum=1+2
let result=value??defaultValue

// ✅ Good: Space after colon in type annotations
let name: String
func test(value: Int) -> Bool

// ❌ Bad: Space before colon
let name : String
func test(value : Int) -> Bool
```

### Trailing Commas

```swift
// ✅ Good: Always use trailing comma in multiline
let array = [
    "first",
    "second",
    "third",  // ← Trailing comma
]

// ❌ Bad: No trailing comma
let array = [
    "first",
    "second",
    "third"
]
```

---

## 🎯 Swift Best Practices

### Optionals

```swift
// ✅ Good: Use optional binding
if let user = optionalUser {
    print(user.name)
}

// ✅ Good: Guard for early exit
guard let user = optionalUser else {
    return
}

// ❌ Bad: Force unwrapping
let user = optionalUser!  // Never in production!
```

### Type Inference

```swift
// ✅ Good: Let Swift infer when obvious
let name = "John"
let count = items.count
let view = UserProfileView()

// ❌ Bad: Redundant type annotation
let name: String = "John"
let count: Int = items.count
```

### Self

```swift
// ✅ Good: Omit self when not required
struct User {
    let name: String
    
    func greet() {
        print("Hello, \(name)")  // No self needed
    }
}

// ✅ Good: Use self only when required
struct User {
    let name: String
    
    init(name: String) {
        self.name = name  // Required to disambiguate
    }
}
```

### Access Control

```swift
// ✅ Good: Explicit access control
public struct User {
    public let id: UUID
    private(set) var name: String
    
    private func validate() { }
}

// ❌ Bad: No access control (defaults to internal)
struct User {
    let id: UUID
    var name: String
}
```

### Empty Collections

```swift
// ✅ Good: Use isEmpty
if array.isEmpty {
    print("No items")
}

// ❌ Bad: Compare count
if array.count == 0 {
    print("No items")
}
```

---

## 📋 Documentation

### DocC Comments

All **public APIs** must have DocC documentation:

```swift
/// Fetches a user profile from the repository.
///
/// This method first checks the local cache before making a network request.
/// If the user is not found, it throws `RepositoryError.notFound`.
///
/// - Parameter id: The unique identifier of the user
/// - Returns: The user profile
/// - Throws: `RepositoryError` if the user cannot be fetched
///
/// ## Example
///
/// ```swift
/// do {
///     let user = try await repository.fetchUser(by: userId)
///     print(user.name)
/// } catch {
///     print("Failed to fetch user: \(error)")
/// }
/// ```
public func fetchUser(by id: UUID) async throws -> User {
    // Implementation
}
```

### Inline Comments

```swift
// ✅ Good: Explain why, not what
// Cache result to avoid repeated network calls
let cachedUser = try await cache.get(userId)

// ❌ Bad: Obvious what
// Get user from cache
let cachedUser = try await cache.get(userId)
```

---

## 🚫 Anti-Patterns to Avoid

### Force Unwrapping

```swift
// ❌ Never do this in production
let user = optionalUser!
let value = try! riskyOperation()
let casted = object as! SpecificType
```

### Stringly-Typed Code

```swift
// ❌ Bad: String-based keys
let value = dictionary["userEmail"] as? String

// ✅ Good: Strongly-typed
struct Keys {
    static let userEmail = "userEmail"
}
let value = dictionary[Keys.userEmail] as? String

// ✅ Better: Use Codable
struct User: Codable {
    let email: String
}
```

### Magic Numbers

```swift
// ❌ Bad: Magic numbers
if count > 100 {
    performAction()
}

// ✅ Good: Named constants
private let maxItemCount = 100

if count > maxItemCount {
    performAction()
}
```

### Massive Types

```swift
// ❌ Bad: 500-line ViewModel
class MassiveViewModel {
    // 500+ lines of code
}

// ✅ Good: Split responsibilities
class UserProfileViewModel { }
class UserSettingsViewModel { }
class UserActivityViewModel { }
```

---

## ✅ Code Style Checklist

Before committing code:

- [ ] SwiftFormat applied (`swiftformat .`)
- [ ] SwiftLint passes (`swiftlint`)
- [ ] No force unwrapping in production code
- [ ] All public APIs documented
- [ ] File headers present
- [ ] Imports organized
- [ ] Access control explicit
- [ ] No magic numbers
- [ ] Meaningful variable names
- [ ] Functions under 40 lines
- [ ] Types under 300 lines

---

## 🔧 Pre-commit Hook

**Setup** (via ARCDevTools):

```bash
# ARCDevTools installs pre-commit hooks automatically
```

**Manual Hook** (`.git/hooks/pre-commit`):

```bash
#!/bin/sh

echo "🏃🏽‍♂️ Running SwiftFormat..."
swiftformat . --lint
if [ $? -ne 0 ]; then
    echo "❌ SwiftFormat check failed. Run 'swiftformat .' to fix."
    exit 1
fi

echo "🏃🏽‍♂️ Running SwiftLint..."
swiftlint
if [ $? -ne 0 ]; then
    echo "❌ SwiftLint check failed. Fix errors before committing."
    exit 1
fi

echo "✅ All checks passed!"
```

---

## 🚫 Forbidden APIs → Modern Equivalents

These APIs are banned across all ARC Labs projects. Using them fails code review.

| ✘ Forbidden | ✓ Use instead | Why |
|---|---|---|
| `DateFormatter`, `.stringFromDate(...)` | `.formatted()` / `.formatted(.dateTime…)` | Locale-aware, concise |
| `withAnimation()` | `arcWithAnimation()` (ARC apps) | Respects Reduce Motion |
| Raw UIKit (`UIView`, `UIViewRepresentable`) for tasks SwiftUI handles natively | SwiftUI-native API | Avoids bridging overhead |
| `NotificationCenter.addObserver(_:selector:name:object:)` | `.onReceive(NotificationCenter.default.publisher(for:))` | Swift 6 safe |
| Completion handlers where `async` equivalent exists | `async/await` | Structured concurrency |
| `nonisolated(unsafe)` | Proper actor isolation | Masks real data-race bugs |
| Force unwrap `!`, force try `try!`, force cast `as!` | `guard let` / `if let` / `??` | SwiftLint error |
| `DispatchQueue.main.async` | `@MainActor` / `Task { @MainActor in }` | Swift 6 concurrency |
| `ObservableObject` + `@Published` | `@Observable` | Modern Observation framework |

---

## 📚 Further Reading

- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [SwiftFormat Documentation](https://github.com/nicklockwood/SwiftFormat)
- [SwiftLint Documentation](https://github.com/realm/SwiftLint)
- [Ray Wenderlich Swift Style Guide](https://github.com/raywenderlich/swift-style-guide)

---

**Remember**: Consistent style is not about personal preference—it's about **team efficiency** and **code quality**. Let tools do the work. 🎨
