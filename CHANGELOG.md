# Changelog

All notable changes to ARCKnowledge will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed - Repository Restructure
- **Renamed** from ARCAgentsDocs to ARCKnowledge
- **Removed** Swift Package Manager support - now documentation-only repository
- **Removed** all Swift source code (Sources/ and Tests/ directories)
- **Removed** Package.swift manifest
- **Changed** integration method from SPM to git submodule
- **Updated** README.md with git submodule installation instructions
- **Moved** all documentation to repository root for direct access

### Documentation Structure
Documentation files are now directly in the repository root:

- **CLAUDE.md** - Main entry point for AI agents
- **Architecture/** - Architectural patterns and principles
  - clean-architecture.md - Clean Architecture layers and dependency rules
  - mvvm-c.md - MVVM+Coordinator pattern with Router
  - solid-principles.md - SOLID principles applied to Swift
  - protocol-oriented.md - Protocol-oriented programming guidelines
- **Layers/** - Implementation layer guidelines
  - presentation.md - Views, ViewModels, Routers/Coordinators
  - domain.md - Entities, Use Cases, business logic
  - data.md - Repositories, Data Sources, persistence
- **Projects/** - Project type guidelines
  - apps.md - iOS App development standards
  - packages.md - Swift Package development standards
- **Quality/** - Quality assurance standards
  - code-review.md - Code review checklist and AI-generated code standards
  - code-style.md - SwiftLint, SwiftFormat, naming conventions
  - documentation.md - DocC, README standards, inline comments
  - readme-standards.md - Standardized README template
  - testing.md - Swift Testing framework and coverage requirements
- **Tools/** - Development tools integration
  - arcdevtools.md - ARCDevTools package setup and usage
  - spm.md - Swift Package Manager best practices
  - xcode.md - Xcode project configuration and schemes
- **Workflow/** - Development workflow
  - git-branches.md - Branch naming conventions and Git flow
  - git-commits.md - Conventional Commits specification
  - plan-mode.md - When and how AI agents enter Plan Mode

### Philosophy
ARCKnowledge is now a pure documentation repository:
- No code, just comprehensive development guidelines
- Integrated via git submodule for easy access across all ARC Labs projects
- Direct file access for AI agents (no programmatic API needed)
- Single source of truth for development standards

## [1.0.0] - 2025-12-11

### Added - Initial Release
- **CLAUDE.md** - Main entry point for AI agents with ARC Labs philosophy
- **Complete Documentation Set** covering:
  - Clean Architecture and MVVM+C patterns
  - SOLID and Protocol-Oriented programming
  - Quality standards (testing, code review, documentation)
  - Git workflow and commit conventions
  - Development tools integration
- **README.md** - Comprehensive project documentation
- **.gitignore** and **.gitattributes** - Repository configuration
- **CHANGELOG.md** - Version history tracking

[Unreleased]: https://github.com/ARCLabsStudio/ARCKnowledge/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/ARCLabsStudio/ARCKnowledge/releases/tag/v1.0.0
