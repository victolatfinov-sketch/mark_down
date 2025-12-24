# Welcome to Markdown Reader MVP

This is a sample Markdown file demonstrating the capabilities of our Flutter Markdown Reader with **Mermaid diagram support**.

## Features

- **Markdown Rendering**: Full support for standard Markdown syntax
- **Mermaid Diagrams**: Beautiful flowcharts, sequence diagrams, and more
- **File Selection**: Open local Markdown files from your device
- **Dark Mode**: Automatic theme support based on system settings
- **Adjustable Font Size**: Customize your reading experience

---

## Text Formatting

You can use various text formatting options:

- **Bold text** using double asterisks
- *Italic text* using single asterisks
- `Inline code` using backticks
- ~~Strikethrough~~ using double tildes

## Lists

### Unordered List
- Item one
- Item two
  - Nested item
  - Another nested item
- Item three

### Ordered List
1. First item
2. Second item
3. Third item

## Code Blocks

```dart
void main() {
  print('Hello, World!');
}
```

```python
def greet(name):
    return f"Hello, {name}!"
```

## Blockquote

> "The only way to do great work is to love what you do." - Steve Jobs

---

## Mermaid Diagrams

### Flowchart

```mermaid
graph TD
    A[Start] --> B{Is it working?}
    B -->|Yes| C[Great!]
    B -->|No| D[Debug]
    D --> B
    C --> E[End]
```

### Sequence Diagram

```mermaid
sequenceDiagram
    participant User
    participant App
    participant Server
    
    User->>App: Open File
    App->>App: Parse Markdown
    App->>App: Render Content
    App-->>User: Display View
```

### Class Diagram

```mermaid
classDiagram
    class Document {
        +String title
        +String content
        +Date created
        +save()
        +load()
    }
    class MarkdownDocument {
        +List~String~ headings
        +List~String~ paragraphs
        +parse()
    }
    class MermaidDiagram {
        +String code
        +String type
        +render()
    }
    
    Document <|-- MarkdownDocument
    MarkdownDocument "1" *-- "*" MermaidDiagram : contains
```

### State Diagram

```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Loading: Open File
    Loading --> Displaying: Parse Success
    Loading --> Error: Parse Error
    Displaying --> Idle: Close File
    Error --> Idle: Retry
```

### Gantt Chart

```mermaid
gantt
    title Project Timeline
    dateFormat  YYYY-MM-DD
    section Planning
    Requirements    :a1, 2024-01-01, 14d
    Design          :a2, after a1, 14d
    section Development
    Implementation  :b1, after a2, 30d
    Testing         :b2, after b1, 14d
    section Deployment
    Release         :c1, after b2, 7d
```

### Pie Chart

```mermaid
pie title Project Budget Allocation
    "Development" : 45
    "Design" : 20
    "Testing" : 15
    "Deployment" : 10
    "Documentation" : 10
```

### User Journey

```mermaid
journey
    title My Working Day
    section Morning
      Work on thesis: 5: Me
      Coffee break: 3: Me, Cat
    section Afternoon
      Code review: 2: Me, Team
      Bug fixing: 4: Me, Cat
```

---

## Tables

| Feature | Status | Priority |
|---------|--------|----------|
| Markdown Render | ✅ Done | High |
| Mermaid Support | ✅ Done | High |
| File Picker | ✅ Done | Medium |
| Dark Mode | ✅ Done | Medium |
| Font Size | ✅ Done | Low |

---

## Links

- [Flutter Official Website](https://flutter.dev)
- [Mermaid Documentation](https://mermaid.js.org)
- [Markdown Guide](https://www.markdownguide.org)

---

## Conclusion

This Markdown Reader MVP demonstrates how to build a Flutter application that can render Markdown files with embedded Mermaid diagrams. The implementation uses `webview_flutter` to leverage Mermaid.js for diagram rendering while providing a native-like experience.

**Happy reading! 📚**
