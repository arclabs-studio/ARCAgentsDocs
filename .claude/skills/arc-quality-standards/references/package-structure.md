# 📁 Package Structure

**Esta guía define la organización de carpetas y archivos para los Swift Packages de ARC Labs, basada en las mejores prácticas de la industria y los estándares de Apple, Alamofire, Vapor y otros proyectos de referencia.**

> **📚 Related Documentation**
> - For package standards and philosophy, see [`packages.md`](https://github.com/arclabs-studio/ARCKnowledge/blob/main/Projects/packages.md)
> - For SPM technical details, see [`spm.md`](https://github.com/arclabs-studio/ARCKnowledge/blob/main/Tools/spm.md)
> - For README formatting, see [`readme-standards.md`](readme-standards.md)

---

## 🎯 Principio General

> **La estructura debe facilitar encontrar código, no complicarlo.**
> Si dudas, empieza plano y refactoriza cuando el paquete crezca.

La organización interna depende del **tamaño y complejidad** del paquete:

| Tamaño | Archivos | Organización Recomendada |
|--------|----------|-------------------------|
| Pequeño | < 10 | Estructura plana (sin subcarpetas) |
| Mediano | 10-30 | Por tipo de componente |
| Grande | > 30 | Por tipo + por funcionalidad |

---

## 📦 Estructura Raíz del Paquete

### Estructura Mínima (Obligatoria SPM)

```
ARCPackageName/
├── Package.swift              # Manifiesto del paquete (OBLIGATORIO)
├── Sources/
│   └── ARCPackageName/
│       └── ARCPackageName.swift
└── Tests/
    └── ARCPackageNameTests/
        └── ARCPackageNameTests.swift
```

### Estructura Completa (Recomendada ARC Labs)

```
ARCPackageName/
├── Package.swift              # Manifiesto del paquete
├── README.md                  # Documentación principal
├── LICENSE                    # Licencia (MIT)
├── CHANGELOG.md               # Historial de cambios
├── .swiftlint.yml             # Configuración SwiftLint (vía ARCDevTools)
├── .swiftformat               # Configuración SwiftFormat (vía ARCDevTools)
├── .gitignore
├── .github/
│   └── workflows/
│       └── ci.yml             # GitHub Actions CI/CD
├── Sources/
│   └── ARCPackageName/
│       └── [código fuente]
├── Tests/
│   └── ARCPackageNameTests/
│       └── [tests]
├── Example/                   # Demo app (Xcode project independiente, ver packages.md)
│   └── ARCPackageNameDemoApp/
│       └── ARCPackageNameDemoApp.xcodeproj
└── Documentation.docc/        # Documentación DocC
    ├── ARCPackageName.md
    └── Articles/
        └── GettingStarted.md
```

---

## 📂 Paquete Pequeño (< 10 archivos)

**Ejemplo: ARCLogger**

Usa estructura plana como Apple (swift-algorithms) y Alamofire:

```
Sources/
└── ARCLogger/
    ├── Logger.swift           # Punto de entrada / API principal
    ├── LogLevel.swift         # Enum de niveles
    ├── LogDestination.swift   # Protocolo de destinos
    ├── ConsoleDestination.swift
    ├── OSLogDestination.swift
    └── LogMessage.swift
```

**Justificación**: Paquetes pequeños no necesitan subcarpetas. La navegación es directa y el overhead de carpetas añade complejidad innecesaria.

---

## 📂 Paquete Mediano (10-30 archivos)

**Ejemplo: ARCStorage**

Organiza por tipo de componente:

```
Sources/
└── ARCStorage/
    ├── ARCStorage.swift           # Punto de entrada / Exports
    │
    ├── Protocols/                 # Abstracciones públicas
    │   ├── StorageProvider.swift
    │   ├── Repository.swift
    │   └── CacheProvider.swift
    │
    ├── Implementations/           # Implementaciones concretas
    │   ├── SwiftDataProvider.swift
    │   ├── CloudKitProvider.swift
    │   ├── UserDefaultsProvider.swift
    │   └── KeychainProvider.swift
    │
    ├── Models/                    # Tipos de datos
    │   ├── StorageConfiguration.swift
    │   └── CachePolicy.swift
    │
    ├── Errors/                    # Tipos de error
    │   └── StorageError.swift
    │
    ├── Extensions/                # Extensiones de tipos externos
    │   └── Data+Compression.swift
    │
    └── Internal/                  # Código interno (no público)
        └── StorageQueue.swift
```

---

## 📂 Paquete Grande (> 30 archivos)

**Ejemplo: ARCUIComponents**

Combina organización por tipo y por funcionalidad:

```
Sources/
└── ARCUIComponents/
    ├── ARCUIComponents.swift      # Exports públicos
    │
    ├── Core/                      # Infraestructura base
    │   ├── Protocols/
    │   │   └── Themeable.swift
    │   ├── Extensions/
    │   │   ├── View+Styling.swift
    │   │   └── Color+Hex.swift
    │   └── Utilities/
    │       └── LayoutCalculator.swift
    │
    ├── Components/                # Componentes UI reutilizables
    │   ├── Buttons/
    │   │   ├── PrimaryButton.swift
    │   │   ├── SecondaryButton.swift
    │   │   └── IconButton.swift
    │   ├── Cards/
    │   │   ├── ContentCard.swift
    │   │   └── ActionCard.swift
    │   ├── Lists/
    │   │   ├── ListRow.swift
    │   │   └── SectionHeader.swift
    │   └── Inputs/
    │       ├── TextField.swift
    │       └── SearchBar.swift
    │
    ├── Modifiers/                 # ViewModifiers de SwiftUI
    │   ├── ShadowModifier.swift
    │   ├── ShimmerModifier.swift
    │   └── RoundedCornerModifier.swift
    │
    ├── Styles/                    # ButtonStyles, TextFieldStyles, etc.
    │   ├── PrimaryButtonStyle.swift
    │   └── RoundedTextFieldStyle.swift
    │
    └── Resources/                 # Assets y recursos
        ├── Colors.xcassets
        └── Fonts/
```

---

## 🧪 Organización de Tests

### Estructura Recomendada

```
Tests/
└── ARCPackageNameTests/
    ├── Unit/                      # Tests unitarios (aislados, rápidos)
    │   ├── LoggerTests.swift
    │   ├── LogLevelTests.swift
    │   └── LogMessageTests.swift
    │
    ├── Integration/               # Tests de integración (múltiples componentes)
    │   └── LoggerIntegrationTests.swift
    │
    └── Helpers/                   # Utilidades de test
        ├── Mocks/
        │   ├── MockLogDestination.swift
        │   └── MockStorageProvider.swift
        ├── Fixtures/
        │   └── TestData.swift
        └── Extensions/
            └── XCTestCase+Helpers.swift
```

### Convenciones de Nomenclatura

| Tipo | Sufijo | Ejemplo |
|------|--------|---------|
| Tests unitarios | `Tests` | `LoggerTests.swift` |
| Tests de integración | `IntegrationTests` | `LoggerIntegrationTests.swift` |
| Tests de rendimiento | `PerformanceTests` | `LoggerPerformanceTests.swift` |
| Mocks | `Mock` + nombre | `MockLogDestination.swift` |
| Stubs | `Stub` + nombre | `StubNetworkClient.swift` |
| Fakes | `Fake` + nombre | `FakeDatabase.swift` |

---

## 📚 Documentación (Documentation.docc/)

### Estructura DocC

```
Documentation.docc/
├── ARCPackageName.md              # Landing page principal
├── Articles/                      # Guías y tutoriales
│   ├── GettingStarted.md
│   ├── Configuration.md
│   └── Migration.md
├── Tutorials/                     # Tutoriales interactivos (opcional)
│   └── BasicUsage.tutorial
└── Resources/                     # Imágenes para documentación
    └── diagram.png
```

---

## 🏗️ Estructuras por Tipo de Paquete

### Paquete de Infraestructura (Logger, Metrics)

```
Sources/ARCLogger/
├── Protocols/       # LogDestination, LogFormatter
├── Implementations/ # ConsoleLogger, OSLogLogger, FileLogger
├── Models/          # LogLevel, LogMessage, LogMetadata
├── Errors/          # LoggerError
└── Configuration/   # LoggerConfiguration
```

### Paquete de Networking

```
Sources/ARCNetworking/
├── Protocols/       # HTTPClient, RequestInterceptor
├── Clients/         # URLSessionClient, MockClient
├── Models/
│   ├── Request/     # HTTPRequest, HTTPMethod, HTTPHeaders
│   └── Response/    # HTTPResponse, NetworkError
├── Interceptors/    # AuthInterceptor, LoggingInterceptor
├── Encoding/        # JSONEncoder, FormEncoder
└── Extensions/      # URLRequest+Helpers
```

### Paquete de UI Components

```
Sources/ARCUIComponents/
├── Core/            # Protocolos base, extensiones comunes
├── Components/      # Vistas reutilizables (agrupadas por tipo)
├── Modifiers/       # ViewModifiers de SwiftUI
├── Styles/          # ButtonStyle, TextFieldStyle, etc.
├── Tokens/          # Design tokens (spacing, corners, shadows)
└── Resources/       # Assets, fonts, colores
```

### Paquete de Persistencia

```
Sources/ARCStorage/
├── Protocols/       # StorageProvider, Repository, CacheProvider
├── Providers/       # SwiftDataProvider, CloudKitProvider
├── Repositories/    # GenericRepository, CachedRepository
├── Models/          # StorageConfiguration, CachePolicy
├── Migrations/      # Migraciones de datos (si aplica)
└── Errors/          # StorageError
```

### Paquete de Navegación

```
Sources/ARCNavigation/
├── Protocols/       # Router, Coordinator, Destination
├── Core/            # NavigationStack, DeepLinkHandler
├── Coordinators/    # AppCoordinator, FeatureCoordinator
├── Routes/          # Route definitions
└── Extensions/      # NavigationPath+Helpers
```

---

## 🚫 Carpetas que NO Usar

| Carpeta | Problema | Alternativa |
|---------|----------|-------------|
| `Utils/` o `Utilities/` | Demasiado genérico, se convierte en cajón de sastre | `Extensions/`, `Helpers/` específicos |
| `Common/` | Vago, no describe contenido | Nombre específico según funcionalidad |
| `Misc/` | Indefinido | Distribuir en carpetas apropiadas |
| `Base/` | Ambiguo | `Core/`, `Protocols/` |
| `Shared/` | En paquetes todo es compartido | Eliminar o usar nombre específico |

---

## ✅ Checklist de Estructura

### Archivos Raíz
- [ ] `Package.swift` configurado correctamente
- [ ] `README.md` con badge, instalación y uso básico
- [ ] `LICENSE` (MIT)
- [ ] `CHANGELOG.md` con formato Keep a Changelog
- [ ] `.gitignore` apropiado
- [ ] Configuración de CI/CD en `.github/workflows/`

### Sources/
- [ ] Archivo de entrada con exports públicos (`ARCPackageName.swift`)
- [ ] Organización coherente (plana para pequeños, por tipo para medianos+)
- [ ] Protocolos separados de implementaciones
- [ ] Código interno marcado como `internal` o en carpeta `Internal/`
- [ ] Recursos en carpeta `Resources/` si aplica

### Tests/
- [ ] Tests unitarios en `Unit/`
- [ ] Tests de integración en `Integration/` (si aplica)
- [ ] Mocks y helpers en `Helpers/`
- [ ] Cobertura mínima 80%, objetivo 100%

### Documentation.docc/
- [ ] Landing page principal
- [ ] Artículo de Getting Started
- [ ] Todos los tipos públicos documentados

---

## 📖 Referencias de la Industria

### Paquetes de Apple
- [swift-algorithms](https://github.com/apple/swift-algorithms): Estructura plana, algoritmos individuales como archivos
- [swift-collections](https://github.com/apple/swift-collections): Organización por tipo de colección
- [swift-async-algorithms](https://github.com/apple/swift-async-algorithms): Similar a swift-algorithms

### Paquetes de Terceros
- [Alamofire](https://github.com/Alamofire/Alamofire): Estructura plana, ~20 archivos en raíz de Sources
- [Vapor](https://github.com/vapor/vapor): Múltiples módulos, organización por responsabilidad
- [swift-composable-architecture](https://github.com/pointfreeco/swift-composable-architecture): Organización por feature/responsabilidad
- [Kingfisher](https://github.com/onevcat/Kingfisher): Por tipo (Cache, Networking, Image, Views)

### Observación Clave

> **Los paquetes exitosos priorizan la claridad sobre la estructura rígida.** Alamofire y swift-algorithms usan estructuras planas porque funcionan para su tamaño. Vapor usa múltiples módulos porque su complejidad lo requiere. **Adapta la estructura al tamaño y naturaleza del paquete.**

---

## 📝 Resumen Ejecutivo

1. **Estructura raíz**: Siempre incluir `Package.swift`, `README.md`, `LICENSE`, `CHANGELOG.md`
2. **Paquetes pequeños (< 10 archivos)**: Estructura plana, sin subcarpetas
3. **Paquetes medianos (10-30 archivos)**: Organizar por tipo (`Protocols/`, `Implementations/`, `Models/`, `Errors/`)
4. **Paquetes grandes (> 30 archivos)**: Combinar organización por tipo y por funcionalidad
5. **Tests**: Separar en `Unit/`, `Integration/`, `Helpers/`
6. **Documentación**: DocC con landing page y artículos de Getting Started
7. **Recursos**: Siempre en carpeta `Resources/` dentro de `Sources/`

---

**Regla de oro**: La estructura debe facilitar encontrar código, no complicarlo. Si dudas, empieza plano y refactoriza cuando el paquete crezca.
