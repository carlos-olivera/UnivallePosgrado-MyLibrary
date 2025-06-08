# MyLibrary 📚 - Proyecto Educativo Firebase

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Firebase](https://img.shields.io/badge/Firebase-9.22.0-orange.svg)](https://firebase.google.com/)
[![React Native](https://img.shields.io/badge/React%20Native-0.72-blue.svg)](https://reactnative.dev/)
[![Flutter](https://img.shields.io/badge/Flutter-3.10-blue.svg)](https://flutter.dev/)

> **Proyecto educativo para demostrar las capacidades de Firebase** desarrollado para el programa de postgrado de la Universidad del Valle.

## 🎓 Propósito Educativo

MyLibrary es una aplicación móvil completa diseñada específicamente para enseñar conceptos avanzados de Firebase a estudiantes de postgrado. El proyecto implementa un caso de uso real y práctico: una librería personal donde los usuarios pueden buscar libros, gestionar su colección y escribir reseñas.

### 🎯 Objetivos de Aprendizaje

- **Firebase Authentication**: Registro, login, recuperación de contraseña
- **Cloud Firestore**: Base de datos NoSQL, consultas complejas, reglas de seguridad
- **Firebase Storage**: Almacenamiento de archivos (fotos de perfil)
- **Firebase Emulator Suite**: Desarrollo local sin costos
- **Arquitectura móvil**: Patrones modernos en React Native y Flutter

## 🏗️ Arquitectura del Proyecto

```
MyLibrary/
├── 🔥 FirebaseLocalEmulator/     # Backend Firebase con emuladores
├── 📱 ReactNativeClient/         # Cliente React Native + Expo
├── 🦋 FlutterClient/            # Cliente Flutter
└── 📖 docs/                     # Documentación educativa
```

### 🔥 Backend Firebase

El backend utiliza **Firebase Emulator Suite** para desarrollo local, permitiendo:

- ✅ **Desarrollo offline** sin conexión a internet
- ✅ **Cero costos** durante el desarrollo
- ✅ **Datos de prueba** predefinidos
- ✅ **Reglas de seguridad** educativas comentadas

#### Servicios Implementados

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| **Authentication** | 9099 | Gestión de usuarios |
| **Firestore** | 8080 | Base de datos NoSQL |
| **Storage** | 9199 | Almacenamiento de archivos |
| **UI Console** | 4000 | Interfaz de administración |

### 📱 Clientes Móviles

El proyecto incluye dos implementaciones móviles para comparar tecnologías:

#### React Native + Expo
- **Context API** para manejo de estado
- **React Navigation** para navegación
- **React Native Paper** para UI Material Design
- **Expo** para desarrollo simplificado

#### Flutter
- **Provider/Riverpod** para manejo de estado
- **Firebase FlutterFire** para integración
- **Material Design 3** para UI consistente

## 🚀 Inicio Rápido

### Prerrequisitos

```bash
# Node.js (versión 18 o superior)
node --version

# Firebase CLI
npm install -g firebase-tools

# Para React Native
npm install -g @expo/cli

# Para Flutter
flutter --version
```

### 1. Clonar y Configurar

```bash
# Clonar el repositorio
git clone https://github.com/TuUsuario/UnivallePosgrado-MyLibrary.git
cd UnivallePosgrado-MyLibrary

# Instalar dependencias del emulador
cd FirebaseLocalEmulator
npm install
```

### 2. Iniciar Firebase Emulators

```bash
# En el directorio FirebaseLocalEmulator
npm run start

# ✅ Acceder a la UI en: http://localhost:4000
```

### 3. Poblar con Datos de Prueba

```bash
# En otra terminal (con emuladores corriendo)
npm run seed
```

### 4. Ejecutar Cliente React Native

```bash
# En el directorio ReactNativeClient
cd ../ReactNativeClient
npm install
npm start

# Escanear QR con Expo Go app
```

### 5. Ejecutar Cliente Flutter

```bash
# En el directorio FlutterClient
cd ../FlutterClient
flutter pub get
flutter run
```

## 📚 Funcionalidades Implementadas

### 👤 Autenticación de Usuarios
- ✅ Registro con email/contraseña
- ✅ Inicio de sesión
- ✅ Recuperación de contraseña
- ✅ Cierre de sesión
- ✅ Persistencia de sesión

### 📖 Gestión de Libros
- ✅ Búsqueda de libros (API externa)
- ✅ Visualización de detalles
- ✅ Agregar a librería personal
- ✅ Eliminar de librería
- ✅ Estados de carga optimizados

### ⭐ Sistema de Reseñas
- ✅ Calificación por estrellas (1-5)
- ✅ Texto de reseña
- ✅ Edición de reseñas existentes
- ✅ Visualización de reseñas propias

### 👤 Perfil de Usuario
- ✅ Edición de datos personales
- ✅ Cambio de foto de perfil
- ✅ Visualización de estadísticas

## 🎨 Stack Tecnológico

### Backend
- **Firebase Authentication** - Gestión de usuarios
- **Cloud Firestore** - Base de datos NoSQL
- **Firebase Storage** - Almacenamiento de archivos
- **Firebase Emulator Suite** - Desarrollo local

### Frontend
- **React Native 0.72** + **Expo 49**
- **Flutter 3.10** + **Dart 3.0**
- **Material Design 3** - Sistema de diseño
- **React Navigation 6** - Navegación (RN)
- **Provider Pattern** - Estado global

### APIs Externas
- **Books API** (Udacity) - Catálogo de libros

## 📊 Esquema de Base de Datos

### Colección: `users`
```javascript
{
  email: string,
  nombre: string,
  apellido: string,
  fotoPerfilUrl: string | null,
  fechaCreacion: timestamp,
  fechaUltimaActividad: timestamp
}
```

### Colección: `libraries/{userId}/books`
```javascript
{
  bookId: string,
  titulo: string,
  autor: string,
  portadaUrl: string,
  fechaAgregado: timestamp,
  tieneReseña: boolean
}
```

### Colección: `reviews`
```javascript
{
  userId: string,
  bookId: string,
  calificacion: number,    // 1-5
  textoReseña: string,
  fechaCreacion: timestamp,
  fechaModificacion: timestamp
}
```

## 🔒 Reglas de Seguridad

El proyecto incluye reglas de seguridad educativas que demuestran:

- **Autorización basada en usuario**: Solo acceso a datos propios
- **Validación de datos**: Tipos y formatos correctos
- **Permisos granulares**: Lectura vs escritura diferenciada

```javascript
// Ejemplo: Solo el propietario puede modificar su librería
match /libraries/{userId}/books/{bookId} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
}
```

## 🧪 Testing y Desarrollo

### Datos de Prueba

El proyecto incluye usuarios y datos de ejemplo:

- **Usuario 1**: `estudiante1@example.com` / `password123`
- **Usuario 2**: `estudiante2@example.com` / `password123`

### Scripts Útiles

```bash
# Iniciar emuladores con datos limpios
npm run start:fresh

# Resetear datos y poblar de nuevo
npm run seed

# Ver logs detallados
firebase emulators:start --debug
```

## 📖 Documentación Educativa

- 📄 **[Firebase Schema](FirebaseLocalEmulator/FIRESTORE_SCHEMA.md)** - Estructura de datos detallada
- 🔥 **[Emulator Guide](FirebaseLocalEmulator/README.md)** - Guía completa de emuladores
- 📱 **[React Native Guide](ReactNativeClient/README.md)** - Arquitectura del cliente RN
- 🦋 **[Flutter Guide](FlutterClient/README.md)** - Arquitectura del cliente Flutter

## 🎓 Ejercicios para Estudiantes

### Nivel Básico
1. Modificar las reglas de Firestore para permitir lectura pública de reseñas
2. Agregar un nuevo campo al perfil de usuario
3. Implementar validación de email único en el registro

### Nivel Intermedio
1. Crear una consulta para obtener libros por género
2. Implementar paginación en la lista de libros
3. Agregar notificaciones push con Firebase Messaging

### Nivel Avanzado
1. Implementar Cloud Functions para cálculo de promedios
2. Crear un sistema de recomendaciones basado en reseñas
3. Optimizar consultas con índices compuestos

## 🤝 Contribuir

Este es un proyecto educativo. Las contribuciones son bienvenidas:

1. Fork el proyecto
2. Crea una branch para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la branch (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT. Ver `LICENSE` para más detalles.

## 👨‍🏫 Autores

- **Equipo de Postgrado Universidad del Valle** - Proyecto educativo Firebase

## 🙏 Reconocimientos

- **Firebase Team** por la excelente documentación
- **Udacity** por la Books API gratuita
- **Universidad del Valle** por el programa de postgrado

## 📞 Soporte

Si tienes preguntas sobre este proyecto educativo:

1. Revisa la [documentación](docs/)
2. Consulta los [issues existentes](https://github.com/TuUsuario/UnivallePosgrado-MyLibrary/issues)
3. Crea un nuevo issue si es necesario

---

**💡 Tip para Estudiantes**: Explora el código comentado, experimenta con los emuladores y no dudes en romper cosas. ¡Es la mejor forma de aprender Firebase! 🚀