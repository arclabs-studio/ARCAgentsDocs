# ARCAgentsDocs

**Repositorio central de documentación para guiar a la IA en proyectos**

## 📋 Propósito

Este repositorio es un centro de documentación diseñado para proporcionar contexto y guías a sistemas de IA (como Claude, GPT, etc.) en diversos proyectos. Aquí se almacenan documentos que ayudan a la IA a entender:

- Estándares de código y convenciones
- Arquitecturas de proyectos
- Contexto de negocio y dominio
- Mejores prácticas específicas del equipo
- Plantillas y ejemplos reutilizables

## 🗂️ Estructura Propuesta

```
ARCDocuments/
├── README.md                          # Este archivo
├── templates/                         # Plantillas reutilizables
│   ├── project-context.md            # Contexto general de proyecto
│   ├── api-documentation.md          # Documentación de APIs
│   └── coding-standards.md           # Estándares de código
├── standards/                         # Estándares y convenciones
│   ├── naming-conventions.md         # Convenciones de nomenclatura
│   ├── git-workflow.md               # Flujo de trabajo Git
│   └── code-review-checklist.md      # Checklist de revisión de código
├── architectures/                     # Arquitecturas de referencia
│   ├── microservices-pattern.md      # Patrón de microservicios
│   ├── frontend-structure.md         # Estructura de frontend
│   └── database-design.md            # Diseño de bases de datos
├── projects/                          # Documentación específica por proyecto
│   ├── proyecto-1/
│   │   ├── context.md                # Contexto del proyecto
│   │   ├── technical-specs.md        # Especificaciones técnicas
│   │   └── domain-knowledge.md       # Conocimiento del dominio
│   └── proyecto-2/
│       └── ...
└── guides/                            # Guías generales
    ├── working-with-ai.md            # Cómo trabajar con IA
    ├── prompt-engineering.md         # Ingeniería de prompts
    └── best-practices.md             # Mejores prácticas

```

## 🎯 Cómo Usar Este Repositorio

### Para Proyectos Nuevos

1. **Crea una carpeta** en `projects/` con el nombre de tu proyecto
2. **Copia las plantillas** necesarias desde `templates/`
3. **Personaliza** la documentación con el contexto específico
4. **Referencia** estándares y arquitecturas aplicables

### Para Consultas de IA

Cuando trabajes con una IA en un proyecto:

1. **Proporciona el contexto** relevante desde `projects/[tu-proyecto]/`
2. **Referencia estándares** aplicables desde `standards/`
3. **Incluye arquitecturas** de referencia si es necesario
4. **Usa plantillas** para mantener consistencia

### Ejemplo de Prompt

```
Estoy trabajando en [nombre-proyecto]. Por favor, revisa primero:
- ARCDocuments/projects/[proyecto]/context.md
- ARCDocuments/standards/naming-conventions.md
- ARCDocuments/architectures/frontend-structure.md

Luego, ayúdame a implementar [funcionalidad específica]
```

## 📝 Mejores Prácticas para Documentación

### 1. Claridad y Concisión
- Usa lenguaje claro y directo
- Evita ambigüedades
- Proporciona ejemplos concretos

### 2. Estructura Consistente
- Usa títulos jerárquicos
- Mantén formato similar entre documentos
- Incluye tabla de contenidos para docs largos

### 3. Contexto Suficiente
- Explica el "por qué" además del "qué"
- Incluye decisiones arquitectónicas
- Documenta restricciones y limitaciones

### 4. Mantenimiento
- Actualiza regularmente
- Marca información obsoleta
- Incluye fechas de última actualización

### 5. Ejemplos de Código
- Usa bloques de código con sintaxis resaltada
- Proporciona casos de uso reales
- Comenta código complejo

## 🔧 Plantillas Disponibles

### Contexto de Proyecto
```markdown
# Proyecto: [Nombre]

## Descripción
[Descripción breve del proyecto]

## Tecnologías
- Frontend: [...]
- Backend: [...]
- Base de datos: [...]

## Arquitectura
[Descripción de la arquitectura]

## Reglas de Negocio
[Reglas importantes del dominio]

## Convenciones Específicas
[Convenciones particulares de este proyecto]
```

### Documentación de API
```markdown
# API: [Nombre]

## Base URL
`https://api.ejemplo.com/v1`

## Endpoints

### GET /recurso
**Descripción:** [...]
**Parámetros:** [...]
**Respuesta:** [...]
**Ejemplo:** [...]
```

## 🤖 Trabajando con IA

### Consejos para Mejores Resultados

1. **Sé Específico**: Proporciona exactamente qué documentos revisar
2. **Contexto Primero**: Haz que la IA lea la documentación antes de codificar
3. **Valida**: Revisa que la IA siga los estándares documentados
4. **Itera**: Mejora la documentación basándote en interacciones con IA

### Formato Recomendado de Documentos

- **Markdown** para máxima compatibilidad
- **Diagramas** en Mermaid cuando sea posible
- **Código** con sintaxis resaltada
- **Tablas** para información estructurada

## 📚 Recursos Adicionales

- [Documentación de Claude](https://docs.anthropic.com)
- [Markdown Guide](https://www.markdownguide.org/)
- [Mermaid Diagrams](https://mermaid.js.org/)

## 🤝 Contribuir

Para agregar o actualizar documentación:

1. Crea una rama con prefijo descriptivo
2. Agrega o modifica documentos
3. Asegúrate de seguir el formato establecido
4. Crea un PR con descripción clara

## 📄 Licencia

Ver archivo [LICENSE](LICENSE) para más detalles.

---

**Última actualización:** 2025-12-07
**Mantenedor:** ARCLabs Studio

