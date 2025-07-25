# Kaaru App POC - Aplicación de Mapas con Simulación de Rutas

Una aplicación Flutter que muestra mapas en tiempo real, crea rutas y simula el movimiento de vehículos.

## 🚀 Características

- 📍 **Mapas en tiempo real** con Google Maps
- 🗺️ **Creación de rutas** entre ubicaciones
- 🚗 **Simulación de vehículos** moviéndose por la ruta
- ⏱️ **Información de viaje** (distancia y tiempo estimado)
- 📱 **Interfaz intuitiva** con botones flotantes

## 📋 Requisitos Previos

- Flutter SDK (versión 3.8.1 o superior)
- Android Studio o VS Code
- Dispositivo Android o emulador
- Clave API de Google Maps

## 🛠️ Configuración Inicial

### 1. Clonar el repositorio
```bash
git clone https://github.com/leodan87/kaaru_app_poc.git
cd kaaru_app_poc
```

### 2. Instalar dependencias
```bash
flutter pub get
```

### 3. Configurar Google Maps API Key

#### Obtener la clave API:
1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Crea un proyecto o selecciona uno existente
3. Habilita las siguientes APIs:
   - Maps SDK for Android
   - Maps SDK for iOS  
   - Directions API
4. Crea credenciales (API Key)

#### Configurar en el proyecto:

**Para Dart/Flutter:**
1. Ve a `lib/config/`
2. Copia `api_keys.template.dart` y renómbralo a `api_keys.dart`
3. Reemplaza `"TU_CLAVE_GOOGLE_MAPS_AQUI"` con tu clave API real

**Para Android:**
1. Ve a `android/`
2. Copia `local.properties.template` y renómbralo a `local.properties`
3. Agrega tu clave API:
```properties
GOOGLE_MAPS_API_KEY=TU_CLAVE_API_AQUI
```

Ejemplo de configuración:

```dart
class ApiKeys {
  static const String googleMapsApiKey = "TU_CLAVE_API_AQUI";
  static const String directionsBaseUrl = 'https://maps.googleapis.com/maps/api/directions/json';
}
```

### 4. Ejecutar la aplicación
```bash
flutter run
```

## 📱 Cómo usar la aplicación

1. **Abrir la app** - Verás el mapa centrado en una ubicación inicial
2. **Presionar "Crear Ruta"** - Se creará una ruta hacia el destino
3. **Ver información** - En la parte inferior aparecerá la distancia y tiempo
4. **Presionar "Iniciar Simulación"** - Un vehículo se moverá por la ruta

## 🏗️ Estructura del Proyecto

```
lib/
├── config/
│   ├── api_keys.dart          # Configuración de API keys (no incluido)
│   └── api_keys.template.dart # Plantilla para configuración
├── models/
│   └── directions_model.dart  # Modelo de datos para direcciones
├── providers/
│   └── map_provider.dart      # Lógica de estado del mapa
├── screens/
│   └── map_screen.dart        # Pantalla principal del mapa
├── services/
│   └── directions_service.dart # Servicio para obtener direcciones
├── widgets/
│   └── trip_info_widget.dart  # Widget de información del viaje
└── main.dart                  # Punto de entrada de la aplicación
```

## 🔧 Dependencias Principales

- `google_maps_flutter`: Mapas de Google
- `provider`: Gestión de estado
- `geolocator`: Geolocalización
- `http`: Peticiones HTTP
- `flutter_polyline_points`: Dibujo de rutas

## ⚠️ Notas Importantes

- **Nunca compartir** tu clave API real en repositorios públicos
- **Configurar restricciones** en Google Cloud Console para tu API key
- **Probar en dispositivo real** para mejor experiencia de geolocalización

## 🐛 Solución de Problemas

### Error de NDK Android
Si obtienes errores de NDK, agrega en `android/app/build.gradle.kts`:
```kotlin
android {
    ndkVersion = "27.0.12077973"
    // ... resto de configuración
}
```

### Problemas de permisos de ubicación
Asegúrate de que los permisos estén configurados en:
- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`

## 👥 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crea un Pull Request

## 📄 Licencia

Este proyecto es un POC (Proof of Concept) con fines educativos.
