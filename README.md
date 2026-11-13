# ⚡ NeonDex // Pokédex Anime Cyberpunk

Aplicación móvil para Android construida en **Flutter** bajo **Clean Architecture** y **Material Design 3**, estilizada con una interfaz **Anime Cyberpunk** (*Cyberpunk: Edgerunners* / *Akira*). Integra el catálogo completo de la **PokéAPI**, geolocalización GPS con pronóstico climático en tiempo real mediante **Open-Meteo**, notificaciones locales programables con **Deep Linking**, favoritos persistentes y un panel de diagnóstico de permisos Android.

---

## 📦 Descarga del APK Verificado

El binario compilado y verificado para Android (`arm64-v8a`, `armeabi-v7a`, `x86_64`) se encuentra adjunto en la sección de Releases del repositorio:

- 🔗 **GitHub Release (`v1.0.0`):** [Descargar `neondex-v1.0.0-release.apk`](https://github.com/MauCastillo/neondex/releases/tag/v1.0.0)
- **Package ID:** `com.maucastillo.neondex`
- **Compatibilidad:** Android 7.0+ (`minSdk 24`, `targetSdk 36`, `compileSdk 37`)

---

## 🎨 Identidad Visual (Anime Cyberpunk + Material Design 3)

- **Paleta Neón:** Void Black (`#06070D`), Deep Space (`#0D101B`), Electric Cyan (`#00F0FF`), Neon Magenta (`#FF007F`), Cyber Yellow (`#FCEE09`) y Acid Green (`#39FF14`).
- **Componentes HUD Biselados:** Tarjetas personalizadas (`CyberHudCard`) con recortes octogonales y brackets de esquina iluminados, integradas sobre componentes nativos de **Material Design 3** (`NavigationBar`, `SegmentedButton`, `FilterChip`, `DraggableScrollableSheet`).
- **Tipografías Locales Empaquetadas:** `Orbitron`, `Rajdhani` y `ShareTechMono` incluidas en `assets/fonts/` para renderizado consistente sin dependencia de descarga en tiempo de ejecución.
- **Iconografía y Splash Personalizados:** Logotipo e iconos adaptativos Android (`mipmap-*` e `ic_stat_neondex`) diseñados con temática ciber-Pokédex.
- **Diseño Adaptativo:** Todos los módulos utilizan `SafeArea`, `LayoutBuilder`, `Wrap` y límites flexibles verificados sin desbordamientos (`overflow`) incluso en viewports móviles compactos (`320×568`).

---

## 📱 Funcionalidades Implementadas

### 1. Pokédex Principal en Mosaico y Carga Automática
- Carga inicial reactiva y automática al abrir la aplicación sin intervención manual (`PokedexListNotifier`).
- Cuadrícula adaptable (`2`, `3` o `4` columnas según el ancho de pantalla) con sprites oficiales, numeración nacional, búsqueda local/remota directa por nombre o ID y paginación infinita eficiente al desplazarse.

### 2. Ficha de Detalle y Modales Diferidos (Lazy Loading)
- Visualización automática de tipos elementales, toggle **Normal / Shiny**, altura, peso, experiencia base y barras de telemetría de estadísticas (`StatRadarBars`).
- **Tabla Interactiva de Fortalezas y Debilidades:** Cálculo defensivo (`2x / 4x`, `1/2x / 1/4x`, `0x`) y ofensivo (`STAB 2x`) combinado para tipos simples y duales (`CalculateTypeEffectiveness`).
- **Modales con Carga Diferida:**
  - **Habilidades:** Consulta bajo demanda a `/ability/{name}` al tocar cualquier chip (`showLazyAbilityModal`).
  - **Movimientos:** Hoja deslizante buscable que consulta `/move/{name}` al inspeccionar un ataque (`showLazyMovesSheet` -> `showLazyMoveDetailModal`).
  - **Inteligencia de Especie y Formas:** Modal ampliado con hábitat, tasa de captura, grupos huevo y salto entre formas alternativas (`showLazySpeciesIntelModal`).

### 3. Navegación Filtrada por Tipos Elementales
- Presionar cualquier tipo en el encabezado de detalle, la matriz de fortalezas/debilidades o las recomendaciones climáticas navega automáticamente a `TypePokemonListPage`, con listado paginado y carga automática de todos los Pokémon de ese tipo.

### 4. Línea Evolutiva Interactiva
- Renderizado automático de cadenas lineales y ramificadas (ej. *Pichu → Pikachu → Raichu* o ramas múltiples como *Eevee*), mostrando requisitos de evolución y permitiendo tocar cualquier fase para abrir su ficha completa.

### 5. Sistema de Favoritos Persistente
- Estrella interactiva neón (`CyberFavoriteStarButton`) disponible tanto en tarjetas del catálogo como en la ficha de detalle.
- Persistencia local inmediata mediante `SharedPreferences` (`FavoritesLocalDataSourceImpl`) y bóveda dedicada en la pestaña **FAVORITOS**.

### 6. Radar Climático GPS y Encuentros Pokémon (Geolocator + Open-Meteo)
- Detección automática de coordenadas actuales mediante `geolocator` y consulta en tiempo real a `https://api.open-meteo.com/v1/forecast` (clima actual y pronóstico por hora).
- Motor de inferencia (`EvaluateWeatherEncounters`) que evalúa códigos WMO, temperatura, precipitación, viento, elevación y ciclo diurno/nocturno para sugerir afinidades elementales y posibles encuentros cercanos tocables.

### 7. Notificaciones Locales Programables y Deep Linking
- Planificador periódico que recomienda un Pokémon aleatorio con su tipo y estadística principal (`RandomPokemonAlertProvider` + `WorkManager` / canal local).
- **Intervalo Configurable:** Chips rápidos (`1 min`, `5 min` en modo demo + `15 min` a `24 h` en `WorkManager`) y slider de ajuste fino (`NotificationSchedulerPanel`).
- **Botón de Prueba Inmediata:** Disparo instantáneo desde **Sistema y Diagnóstico**.
- **Deep Linking:** Tocar cualquier notificación (automática o de prueba, tanto con la app cerrada como en primer o segundo plano) redirige mediante `neondex://pokemon/{id}` y `DeepLinkCoordinator` directamente a `PokemonDetailPage`.

### 8. Panel de Diagnóstico y Permisos de Android en Tiempo Real
- Verificación en vivo al entrar o resumir la app (`WidgetsBindingObserver`) del estado de permisos críticos en Android:
  - Ubicación precisa (`ACCESS_FINE_LOCATION`).
  - Notificaciones locales (`POST_NOTIFICATIONS`).
- Botones contextuales para solicitar el permiso dentro de la app o abrir directamente los ajustes del sistema si fue denegado permanentemente.

---

## 🛠️ Arquitectura y Stack Tecnológico

El proyecto sigue **Clean Architecture** con separación estricta entre **Data**, **Domain** y **Presentation**, inversión de dependencias con **GetIt** y gestión de estado reactiva con **Riverpod 3**:

```text
lib/
├── core/
│   ├── constants/          # Endpoints PokeAPI/Open-Meteo, metadatos de 18 tipos, storage keys
│   ├── di/                 # Registro completo GetIt (service_locator.dart)
│   ├── error/              # Excepciones tipadas y Failures
│   ├── network/            # Cliente HTTP unificado con timeouts y validación
│   ├── router/             # Rutas tipadas + DeepLinkCoordinator (URI / payloads)
│   ├── theme/              # CyberColors, CyberShapes, CyberTextStyles, CyberTheme
│   ├── utils/              # Parsers de URLs y formateadores de unidades/stats
│   └── widgets/            # CyberHudCard, CyberNetworkImage, CyberErrorPanel, etc.
├── features/
│   ├── pokedex/            # Catálogo, detalle, tipos, evoluciones y modales lazy
│   │   ├── data/           # Datasources remotos, JSON models, PokemonRepositoryImpl
│   │   ├── domain/         # Entities, Repository interface, 8 UseCases
│   │   └── presentation/   # AsyncNotifiers Riverpod, Pages y Widgets HUD
│   ├── favorites/          # Gestión local persistente de favoritos
│   ├── weather_radar/      # Geolocator + Open-Meteo + motor de afinidad climática
│   └── notifications_settings/ # Notificaciones periódicas, deep link y permisos Android
├── shell/                  # Contenedor principal con NavigationBar Cyberpunk
├── app.dart                # MaterialApp + enlace con DeepLinkCoordinator
└── main.dart               # Inicialización DI, zonas horarias y notificaciones locales
```

### Dependencias Principales
- **Estado e Inyección:** `flutter_riverpod: ^3.5.0`, `get_it: ^9.3.0`, `equatable: ^3.0.0`
- **UI & Imágenes:** `material_ui: ^1.1.0`, `cached_network_image: ^4.0.7`
- **Red y Almacenamiento:** `http: ^1.6.0`, `shared_preferences: ^2.5.6`
- **GPS, Permisos y Notificaciones:** `geolocator: ^14.1.2`, `permission_handler: ^13.0.2`, `flutter_local_notifications: ^23.0.1`, `timezone: ^0.11.2`, `workmanager: ^0.10.10`
- **Testing:** `flutter_test`, `mocktail: ^1.0.5`

### Endpoints Externos Verificados
- **PokéAPI v2 (`pokeapi.co`):** `/pokemon`, `/pokemon/{id}`, `/pokemon-species/{id}`, `/evolution-chain/{id}`, `/type/{name}`, `/ability/{name}`, `/move/{name}`
- **Open-Meteo Forecast API (`api.open-meteo.com`):** `/v1/forecast` (`current` + `hourly`)

---

## 💻 Especificaciones del Entorno de Desarrollo

Entorno hardware y software en el que se desarrolló, probó y compiló el proyecto:

| Componente | Especificación |
| :--- | :--- |
| **Sistema Operativo** | CachyOS Linux (`x86_64`, base Arch Linux) |
| **Kernel** | `7.3.3-1-cachyos` |
| **Procesador (CPU)** | AMD Ryzen 5 220 w/ Radeon 740M Graphics (6 núcleos / 12 hilos) |
| **Memoria RAM** | 19 GiB |
| **Flutter SDK** | Flutter `3.50.0` (canal `stable`) |
| **Dart SDK** | Dart `3.14.0` |
| **Android SDK & Tools** | Compile SDK `37` (Android 17 preview platform), Target SDK `36`, Min SDK `24`, Build Tools `37.0.0` |
| **Toolchain JVM / Gradle** | OpenJDK `17` (compilación Android), Gradle `9.5.0`, Android Gradle Plugin `9.3.1` |

---

## 🧪 Cómo Clonar y Ejecutar las Pruebas Localmente

### Requisitos Previos
- Flutter SDK `>= 3.50.0` y Dart `>= 3.14.0`
- Android SDK con Build Tools `37.0.0` y Platform SDK `37` (para compilar Android)
- Java **JDK 17** recomendado para Gradle (`JAVA_HOME`)

### 1. Clonar e Instalar Dependencias

```bash
git clone https://github.com/MauCastillo/neondex.git
cd neondex
flutter pub get
```

*(Nota: si trabajas en entornos sin comprobación remota o offline parcial, puedes añadir `--no-version-check` a los comandos de `flutter`.)*

### 2. Análisis Estático y Suite Completa de Pruebas

El repositorio incluye **28 pruebas automatizadas** distribuidas en `test/` que cubren utilidades, deep links, modelos JSON de PokéAPI y Open-Meteo, cálculo completo de efectividad elemental (tipos simples y duales), motor climático, favoritos locales, configuración de notificaciones, permisos Android y **Widget Tests** end-to-end (incluyendo renderizado sin `overflow` en pantallas móviles compactas de `320×568`):

```bash
# Análisis estático de código y lints
flutter analyze

# Ejecución de todas las pruebas unitarias y de widgets
flutter test -r expanded
```

---

## 📲 Cómo Compilar el APK en Android

1. Asegúrate de tener configurado `ANDROID_HOME` y apunta `JAVA_HOME` a **JDK 17** (necesario si tu sistema tiene un JDK más reciente como JDK 27 que aún no soporta el script de Gradle/Groovy):

```bash
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk   # Ajusta según la ruta de tu JDK 17
export PATH="$JAVA_HOME/bin:$PATH"
```

2. Genera el APK firmado/empaquetado de producción:

```bash
flutter build apk --release
```

3. El archivo final se generará en:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Para instalarlo directamente en un dispositivo Android físico con depuración USB habilitada:

```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```
