# 📚 MisMangas

Aplicación iOS nativa para gestionar tu colección personal de mangas.

![Swift](https://img.shields.io/badge/Swift-6.2-orange.svg)
![iOS](https://img.shields.io/badge/iOS-26.0+-blue.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Native-green.svg)

<img width="660" height="1434" alt="IMG_0420" src="https://github.com/user-attachments/assets/6b83462b-a4b0-42f8-808f-cf80336cd891" />

## 📖 Descripción

App que permite explorar más de 64.000 mangas, filtrar por género/demografía/temática, guardar tu colección personal y hacer seguimiento de tu progreso de lectura.

## ✨ Características

- 📱 Catálogo completo de mangas
- 🔍 Filtros por género, demografía y temática
- 📚 Gestión de colección personal
- 📊 Control de tomos comprados y progreso de lectura
- 💾 Persistencia local con SwiftData
- 📲 Compatible con iPhone y iPad

## 🛠 Tecnologías

- **Lenguaje:** Swift 6.2
- **UI:** SwiftUI (100% nativo)
- **Persistencia:** SwiftData
- **Networking:** URLSession + async/await
- **Arquitectura:** MVVM + Repository Pattern
- **Plataformas:** iOS 26.0+, iPadOS 26.0+

## 📁 Estructura

```
MisMangas/
├── Helppers/
├── Managers/
├── Network/
├── Model/
├── DataModel/
├── ViewModel/
├── Views/
└── Components/
```

## 📡 API

**Base URL:** `https://mymanga-acacademy-5607149ebe3d.herokuapp.com/`

**Endpoints principales:**
- `/list/mangas` - Listado paginado de mangas
- `/list/mangaByGenre/{genre}` - Filtrar por género
- `/search/mangasContains/{text}` - Búsqueda por título
- `/collection/manga` - Gestión de colección (requiere auth)

## 🚀 Instalación

```bash
git clone https://github.com/tu-usuario/MisMangas.git
cd MisMangas
open MisMangas.xcodeproj
```

**Requisitos:**
- Xcode 26.0+
- iOS 26.0+

## ⚙️ Configuración Swift 6.2

```
Strict Concurrency Checking: Complete
Default Actor Isolation: MainActor
Approachable Concurrency: Yes
```

## 👨‍💻 Autor

**Juan** - Desarrollador iOS Junior  
Swift Developer Program 2025

## 📄 Licencia

Proyecto académico - Swift Developer Program 2025

---
