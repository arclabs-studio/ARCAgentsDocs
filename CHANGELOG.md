# Changelog

All notable changes to ARCKnowledge will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-12-16

### Added - Initial Release

ARCKnowledge is a comprehensive documentation repository that serves as the single source of truth for ARC Labs Studio's development guidelines, architectural standards, and best practices.

#### Core Documentation

- **CLAUDE.md** - Main entry point for AI agents with ARC Labs Studio philosophy and core values
- **README.md** - Comprehensive project documentation with git submodule integration guide
- **CHANGELOG.md** - Version history tracking
- **LICENSE** - MIT License
- **.gitignore** - Repository ignore rules
- **.gitattributes** - Git attributes optimized for submodule usage
- **.swift-version** - Swift 6.0 specification

#### Architecture Documentation

- **Architecture/clean-architecture.md** - Clean Architecture layers, dependency rules, and data flow
- **Architecture/mvvm-c.md** - MVVM+Coordinator pattern with Router implementation
- **Architecture/solid-principles.md** - SOLID principles applied to Swift development
- **Architecture/protocol-oriented.md** - Protocol-oriented programming guidelines

#### Implementation Layer Documentation

- **Layers/presentation.md** - Views, ViewModels, Routers/Coordinators guidelines
- **Layers/domain.md** - Entities, Use Cases, and business logic standards
- **Layers/data.md** - Repositories, Data Sources, and persistence patterns

#### Project Type Documentation

- **Projects/apps.md** - iOS App development standards and guidelines
- **Projects/packages.md** - Swift Package development standards and guidelines

#### Quality Assurance Documentation

- **Quality/code-review.md** - Code review checklist and AI-generated code standards
- **Quality/code-style.md** - SwiftLint, SwiftFormat, and naming conventions
- **Quality/documentation.md** - DocC, README standards, and inline comments guidelines
- **Quality/readme-standards.md** - Standardized README template with visual format
- **Quality/testing.md** - Swift Testing framework and coverage requirements

#### Development Tools Documentation

- **Tools/arcdevtools.md** - ARCDevTools package integration and usage
- **Tools/spm.md** - Swift Package Manager best practices
- **Tools/xcode.md** - Xcode project configuration, schemes, and build settings

#### Workflow Documentation

- **Workflow/git-branches.md** - Branch naming conventions and Git flow
- **Workflow/git-commits.md** - Conventional Commits specification
- **Workflow/plan-mode.md** - When and how AI agents should enter Plan Mode

### Features

- 📖 **Centralized Documentation** - Single source of truth for all development standards
- 🔌 **Git Submodule Integration** - Easy to add to any ARC Labs project
- 🏷️ **Version Control** - Track documentation evolution alongside code
- 📦 **Direct Access** - Files directly accessible in repository root
- ✅ **Comprehensive Coverage** - Architecture, quality, workflow, and tooling standards
- 🎯 **AI Agent Optimized** - Designed for Claude Code and similar AI development tools

### Philosophy

ARCKnowledge embodies ARC Labs Studio's core values:

1. **Simple, Lovable, Complete** - Every feature intuitive, delightful, and fully realized
2. **Quality Over Speed** - Write code that lasts, not code that works once
3. **Modular by Design** - Build reusable components that serve multiple projects
4. **Professional Standards** - Indie doesn't mean amateur; maintain enterprise-level quality
5. **Native First** - Leverage Apple frameworks before external dependencies

[Unreleased]: https://github.com/ARCLabsStudio/ARCKnowledge/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/ARCLabsStudio/ARCKnowledge/releases/tag/v1.0.0
