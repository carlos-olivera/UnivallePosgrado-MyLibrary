# MyLibrary Flutter Client 📱

Cliente Flutter para el proyecto educativo MyLibrary, desarrollado para demostrar conceptos avanzados de Flutter y Firebase a estudiantes de posgrado en la Universidad del Valle.

## 🎯 Objetivo Educativo

Este proyecto demuestra:
- **Arquitectura Flutter** con patrones profesionales
- **Gestión de estado** con Provider y BLoC
- **Integración Firebase** completa (Auth, Firestore, Storage)
- **Material Design 3** y temas personalizados
- **Navegación avanzada** con GoRouter
- **Testing** unitario e integración
- **Buenas prácticas** de desarrollo Flutter

## 📁 Estructura del Proyecto

```
lib/
├── app/                          # Configuración de la aplicación
│   ├── app.dart                  # Aplicación principal
│   ├── routes.dart               # Configuración de rutas
│   └── theme.dart                # Temas y estilos
├── core/                         # Núcleo de la aplicación
│   ├── constants/                # Constantes globales
│   ├── errors/                   # Manejo de errores
│   ├── network/                  # Configuración de red
│   └── utils/                    # Utilidades generales
├── data/                         # Capa de datos
│   ├── datasources/              # Fuentes de datos
│   ├── models/                   # Modelos de datos
│   └── repositories/             # Implementación de repositorios
├── domain/                       # Lógica de negocio
│   ├── entities/                 # Entidades del dominio
│   ├── repositories/             # Interfaces de repositorios
│   └── usecases/                 # Casos de uso
├── presentation/                 # Capa de presentación
│   ├── bloc/                     # BLoC para gestión de estado
│   ├── pages/                    # Pantallas de la aplicación
│   ├── providers/                # Providers de estado
│   └── widgets/                  # Widgets reutilizables
└── main.dart                     # Punto de entrada
```

## 🛠️ Tecnologías y Dependencias

### Dependencias Principales
- `flutter: sdk` - Framework Flutter
- `firebase_core` - Firebase Core
- `firebase_auth` - Autenticación Firebase
- `cloud_firestore` - Base de datos Firestore
- `firebase_storage` - Almacenamiento Firebase
- `provider` - Gestión de estado
- `flutter_bloc` - Patrón BLoC
- `go_router` - Navegación declarativa
- `cached_network_image` - Cache de imágenes
- `http` - Cliente HTTP
- `shared_preferences` - Persistencia local

### Dependencias de Desarrollo
- `flutter_test` - Testing framework
- `mocktail` - Mocking para tests
- `flutter_launcher_icons` - Íconos de la app
- `flutter_lints` - Análisis de código

## 🚀 Configuración Inicial

### 1. Requisitos Previos
```bash
# Flutter SDK (versión estable)
flutter --version

# Firebase CLI
npm install -g firebase-tools
firebase --version
```

### 2. Configuración Firebase
```bash
# Configurar Firebase para Flutter
flutterfire configure
```

### 3. Instalación de Dependencias
```bash
# Obtener dependencias
flutter pub get

# Generar código (si es necesario)
flutter packages pub run build_runner build
```

### 4. Ejecutar la Aplicación
```bash
# Modo desarrollo
flutter run

# Modo debug con emuladores Firebase
flutter run --debug
```

## 📚 Conceptos Educativos Demostrados

### 1. **Arquitectura Clean Architecture**
- Separación clara de responsabilidades
- Inversión de dependencias
- Testabilidad mejorada

### 2. **Gestión de Estado**
- Provider para estado simple
- BLoC para lógica compleja
- StateNotifier para casos específicos

### 3. **Integración Firebase**
- Autenticación con múltiples proveedores
- CRUD operations en Firestore
- Upload y gestión de archivos
- Reglas de seguridad

### 4. **Responsive Design**
- Layouts adaptativos
- Material Design 3
- Temas claro/oscuro
- Accesibilidad

### 5. **Testing Strategy**
- Unit tests para lógica de negocio
- Widget tests para UI
- Integration tests para flujos completos
- Mocking de servicios externos

## 🔧 Scripts Disponibles

```bash
# Análisis de código
flutter analyze

# Ejecutar tests
flutter test

# Generar coverage
flutter test --coverage

# Build para producción
flutter build apk
flutter build ios
```

## 📱 Características de la Aplicación

### Pantallas Principales
- **Autenticación**: Login, registro, recuperación
- **Home**: Dashboard personalizado
- **Explorar**: Búsqueda y catálogo de libros
- **Mi Librería**: Gestión de colección personal
- **Perfil**: Configuración y estadísticas

### Funcionalidades
- ✅ Autenticación segura con Firebase
- ✅ Búsqueda de libros con API externa
- ✅ Gestión de librería personal
- ✅ Sistema de reseñas y calificaciones
- ✅ Sincronización entre dispositivos
- ✅ Modo offline básico
- ✅ Temas personalizables

## 🎓 Para Estudiantes

Este proyecto sirve como:
1. **Referencia de arquitectura** para aplicaciones Flutter profesionales
2. **Ejemplo de integración** Firebase completa
3. **Demostración de patrones** de diseño en Flutter
4. **Base para proyectos** personales y académicos

## 📄 Licencia

MIT License - Ver [LICENSE](../LICENSE) para más detalles.

## 👥 Contribuciones

Este es un proyecto educativo. Las contribuciones son bienvenidas siguiendo las guías de contribución del proyecto principal.

---

**MyLibrary Flutter Client** - Una implementación educativa completa de una aplicación móvil moderna con Flutter y Firebase.