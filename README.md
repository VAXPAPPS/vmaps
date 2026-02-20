<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"> <img src="https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black" alt="Linux"> <img src="https://img.shields.io/badge/OpenStreetMap-7EBC6F?style=for-the-badge&logo=openstreetmap&logoColor=white" alt="OSM">

# 🗺️ VMaps

**VMaps** is a professional, open-source maps application for Linux desktop built with Flutter. It features a stunning glassmorphic dark UI, real-time place search, route planning, and favorites management — all powered by free and open-source map services.

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🗺️ **Interactive Map** | Smooth pan, zoom, and tap interactions powered by OpenStreetMap |
| 🔍 **Place Search** | Search any location worldwide with live results via Nominatim API |
| 🛣️ **Route Planning** | Calculate driving routes between two points with distance & time estimates (OSRM) |
| ⭐ **Favorites** | Save and manage your favorite places with local persistent storage |
| 🎨 **4 Map Layers** | Switch between Standard, Dark, Topographic, and Humanitarian tile styles |
| 📍 **Custom Markers** | Animated markers with glow effects and glassmorphic labels |
| 🔄 **Reverse Geocoding** | Tap anywhere on the map to get the address of that location |
| 🏙️ **Quick Jump** | Instantly navigate to major cities from the settings panel |
| 🖥️ **Desktop Optimized** | Designed specifically for Linux desktop with proper window controls |

---

## 📸 Design

VMaps uses a **glassmorphic dark theme** with:
- Frosted glass panels with backdrop blur
- Subtle hover animations and micro-interactions
- A clean sidebar navigation system
- Responsive layout optimized for desktop screens

---

## 🏗️ Architecture

VMaps follows **Clean Architecture** principles with the **BLoC** pattern for state management:

```
lib/
├── domain/              # Business logic layer
│   ├── entities/        # PlaceEntity, RouteEntity
│   └── repositories/    # MapRepository interface
├── data/                # Data access layer
│   ├── models/          # PlaceModel, RouteModel
│   ├── datasources/     # Nominatim, OSRM, LocalStorage
│   └── repositories/    # MapRepositoryImpl
├── application/         # State management layer
│   ├── map/             # MapBloc (camera, zoom, markers, layers)
│   ├── search/          # SearchBloc (live search with debounce)
│   ├── route/           # RouteBloc (route calculation)
│   └── favorites/       # FavoritesBloc (saved places)
├── presentation/        # UI layer
│   ├── pages/           # MapsPage
│   └── widgets/         # MapView, SearchPanel, RoutePanel, etc.
└── core/                # Shared utilities
    ├── consts/           # MapConstants (tile URLs, defaults)
    └── theme/            # MapStyles, VaxpTheme
```

---

## 🛠️ Tech Stack

| Technology | Purpose |
|-----------|---------|
| **Flutter** | Cross-platform UI framework |
| **flutter_map** | Map rendering (vendor-free, pure Flutter) |
| **flutter_bloc** | State management (BLoC pattern) |
| **OpenStreetMap** | Map tiles |
| **Nominatim API** | Place search & reverse geocoding |
| **OSRM API** | Route calculation |
| **SharedPreferences** | Local favorites storage |
| **latlong2** | Geographic coordinate handling |

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** 3.7.0 or later
- **Linux** development dependencies:
  ```bash
  sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev
  ```

### Build & Run

```bash
# Clone the repository
git clone https://github.com/vaxpapps/vmaps.git
cd vmaps

# Get dependencies
flutter pub get

# Run in development mode
flutter run -d linux

# Build release binary
flutter build linux --release
```

The release binary will be at: `build/linux/x64/release/bundle/vmaps`

---

## 🗂️ Usage Guide

### 🔍 Search
1. Click the **Search** icon in the sidebar
2. Type a place name — results appear automatically after 500ms
3. Click a result to navigate the map to that location

### 🛣️ Route Planning
1. Click the **Routes** icon in the sidebar
2. Click on the map to set the **origin** point
3. Click again to set the **destination** point
4. Press **"Calculate Route"** to see the path, distance, and estimated time

### ⭐ Favorites
1. Tap on the map or search for a place
2. Click **"Save"** on the place info card
3. Access saved places anytime from the **Favorites** icon in the sidebar
4. Swipe left on a favorite to remove it

### 🎨 Map Layers
1. Click the **layers button** (bottom-right controls)
2. Choose from: Standard, Dark, Topographic, or Humanitarian

### ⚙️ Settings
- **Quick Jump** — Navigate instantly to major cities
- **Reset Map** — Return to the default view

---



## 🙏 Credits

- Map data © [OpenStreetMap](https://www.openstreetmap.org/) contributors
- Search powered by [Nominatim](https://nominatim.org/)
- Routing powered by [OSRM](https://project-osrm.org/)
- Built with the [VAXP](https://github.com/vaxp) template

---

