# CLAUDE.md - Contexto del Proyecto MyLibrary 🤖

## Información del Proyecto

**Nombre**: MyLibrary - Proyecto Educativo Firebase  
**Repositorio**: UnivallePosgrado-MyLibrary  
**Propósito**: Proyecto educativo para enseñar Firebase a estudiantes de postgrado  
**Universidad**: Universidad del Valle  
**Tecnologías**: Firebase, React Native, Flutter  

## 📚 Documentos de Referencia

Este proyecto está basado en los siguientes documentos de planificación:

1. **Documento de Planificación**: `/Users/colivera/dev/Univalle/modulo5_grupo2/TrabajoFinal/DocumentodePlanificación.md`
2. **Guía Funcional**: `/Users/colivera/dev/Univalle/modulo5_grupo2/TrabajoFinal/GuiaFuncional.md`

## 🎯 Objetivos Educativos

### Conceptos Firebase Demostrados
- **Firebase Authentication**: Registro, login, recuperación de contraseña
- **Cloud Firestore**: Base de datos NoSQL con consultas complejas
- **Firebase Storage**: Almacenamiento de archivos (fotos de perfil)
- **Security Rules**: Reglas de seguridad granulares y educativas
- **Firebase Emulator Suite**: Desarrollo local sin costos

### Patrones Arquitectónicos
- **Context API** (React Native) para manejo de estado global
- **Provider Pattern** (Flutter) para gestión de estado
- **Service Layer** para abstracción de Firebase
- **Repository Pattern** para acceso a datos
- **Observer Pattern** con listeners de Firebase

## 🏗️ Arquitectura Implementada

### Estructura del Proyecto
```
MyLibrary/
├── 🔥 FirebaseLocalEmulator/     # Backend Firebase con emuladores
│   ├── firebase.json            # Configuración de emuladores
│   ├── firestore.rules         # Reglas de seguridad educativas
│   ├── storage.rules           # Reglas de Storage
│   ├── firestore.indexes.json  # Índices optimizados
│   ├── scripts/seed-data.js    # Datos de prueba
│   ├── README.md              # Guía de emuladores
│   └── FIRESTORE_SCHEMA.md    # Esquemas detallados
│
├── 📱 ReactNativeClient/        # Cliente React Native + Expo
│   ├── src/
│   │   ├── components/        # Componentes reutilizables
│   │   ├── screens/          # Pantallas de la aplicación
│   │   ├── services/         # Servicios Firebase y API
│   │   ├── context/          # Context API para estado
│   │   ├── navigation/       # React Navigation
│   │   ├── hooks/           # Custom hooks
│   │   ├── utils/           # Utilidades
│   │   └── constants/       # Configuraciones
│   └── App.js               # Punto de entrada
│
├── 🦋 FlutterClient/           # Cliente Flutter (planificado)
└── 📖 docs/                   # Documentación adicional
```

### Base de Datos Firestore

#### Colecciones Principales
1. **`users`** - Perfiles de usuario
2. **`libraries/{userId}/books`** - Librerías personales (subcollection)
3. **`reviews`** - Reseñas de libros
4. **`system`** - Configuraciones globales

#### Patrones de Datos
- **Subcollections** para escalabilidad
- **Timestamps automáticos** para auditoría
- **Referencias** entre documentos
- **Validación** con reglas de seguridad

## 🎮 Funcionalidades Implementadas

### Módulo de Autenticación
- ✅ **Pantalla Login**: Email/password con validaciones
- ✅ **Pantalla Registro**: Validación de contraseña fuerte
- ✅ **Recuperación de Contraseña**: Flujo completo con email
- ✅ **Context de Auth**: Estado global de autenticación

### Navegación Principal
- ⏳ **Pantalla Tienda**: Búsqueda de libros con API externa
- ⏳ **Pantalla Mi Librería**: Gestión de libros personales
- ⏳ **Pantalla Perfil**: Edición de datos y foto de perfil

### Sistema de Reseñas
- ⏳ **Calificación por estrellas**: 1-5 estrellas interactivas
- ⏳ **Texto de reseña**: Validación de contenido
- ⏳ **Edición**: Modificar reseñas existentes

### Componentes UX/UI
- ✅ **Sistema de tema**: Material Design 3
- ✅ **Loading states**: Spinners y skeletons
- ⏳ **Toast notifications**: Feedback de acciones
- ⏳ **Validación de formularios**: Inline y específica

## 🔧 Configuración Técnica

### Firebase Emulator Suite
- **Authentication**: Puerto 9099
- **Firestore**: Puerto 8080
- **Storage**: Puerto 9199
- **UI Console**: Puerto 4000

### API Externa
- **Books API**: `https://reactnd-books-api.udacity.com`
- **Endpoints**: `/search`, `/books`, `/books/{id}`

### Dependencias Principales
- **Firebase SDK 9.22.0**: Modular y optimizado
- **React Native 0.72**: Con Expo 49
- **React Navigation 6**: Para navegación
- **React Native Paper 5.8**: Material Design

## 📝 Estado Actual del Desarrollo

### ✅ Completado
1. **Estructura de Firebase Backend** con documentación educativa
2. **Esquemas de Firestore** con ejemplos didácticos
3. **Configuración de Emuladores** para desarrollo local
4. **Context de Autenticación** completo
5. **Configuración inicial de React Native**
6. **Sistema de tema** Material Design 3

### 🔄 En Progreso
1. **Componentes de UI reutilizables**
2. **Pantallas principales de la aplicación**
3. **Servicios de integración con Books API**

### ⏳ Pendiente
1. **Cliente Flutter** completo
2. **Navegación entre pantallas**
3. **Integración completa con API de libros**
4. **Testing unitario e integración**

## 🎓 Aspectos Educativos Especiales

### Documentación Integrada
- **Comentarios explicativos** en todo el código
- **Ejemplos de patrones** Firebase
- **Casos de uso específicos** documentados
- **Mejores prácticas** implementadas

### Datos de Prueba
- **Usuarios de ejemplo** predefinidos
- **Libros de muestra** en librerías
- **Reseñas de ejemplo** para demostrar funcionalidad

### Configuración Dual
- **Emuladores locales** para desarrollo
- **Configuración de producción** preparada
- **Variables de entorno** para alternar

## 🔍 Puntos Clave para Claude

### Patrones Implementados
1. **Singleton Pattern**: Inicialización de Firebase
2. **Context Pattern**: Estado global de autenticación
3. **Service Layer**: Abstracción de Firebase services
4. **Observer Pattern**: Listeners de estado de auth

### Convenciones de Código
- **Comentarios educativos** en español e inglés
- **Logging detallado** para debugging
- **Manejo de errores** específico y educativo
- **Validaciones robustas** en formularios

### Estructura de Archivos
- **Separación de responsabilidades** clara
- **Modularidad** para facilitar mantenimiento
- **Reutilización** de componentes
- **Escalabilidad** en la arquitectura

## 🚀 Próximos Pasos Sugeridos

1. **Completar componentes UI** reutilizables
2. **Implementar navegación** entre pantallas
3. **Integrar Books API** con cache local
4. **Desarrollar cliente Flutter** equivalente
5. **Agregar testing** unitario e integración
6. **Optimizar rendimiento** con lazy loading

## 📞 Contexto de Desarrollo

Este proyecto fue desarrollado con **Claude Code** como herramienta de asistencia para:
- Arquitectura de software educativa
- Implementación de patrones Firebase
- Documentación técnica detallada
- Mejores prácticas de desarrollo móvil

El enfoque está en la **educación** y **demostración práctica** de conceptos avanzados de Firebase para estudiantes de postgrado.