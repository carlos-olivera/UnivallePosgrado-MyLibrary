# Firebase Emulator Suite - MyLibrary 🔥

## Descripción Educativa
Este directorio contiene la configuración del **Firebase Emulator Suite** para el proyecto MyLibrary. Los emuladores permiten desarrollar y probar localmente sin necesidad de conectarse a Firebase en la nube, lo cual es ideal para:

- 🎓 **Aprendizaje**: Experimentar sin costos ni limitaciones
- 🛡️ **Seguridad**: Probar sin afectar datos reales
- ⚡ **Velocidad**: Desarrollo offline y más rápido
- 🧪 **Testing**: Ambiente controlado para pruebas

## Servicios Firebase Emulados

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| **Authentication** | 9099 | Autenticación de usuarios |
| **Firestore** | 8080 | Base de datos NoSQL |
| **Storage** | 9199 | Almacenamiento de archivos |
| **UI Console** | 4000 | Interfaz web para administrar |

## 🚀 Inicio Rápido

### 1. Instalación
```bash
# Navegar al directorio del emulador
cd FirebaseLocalEmulator

# Instalar dependencias
npm install

# Instalar Firebase CLI globalmente (si no lo tienes)
npm install -g firebase-tools
```

### 2. Configuración Inicial
```bash
# Configurar el proyecto Firebase (solo la primera vez)
firebase init

# Seleccionar:
# - Firestore
# - Storage
# - Emulators
```

### 3. Ejecutar Emuladores

#### Opción A: Con datos persistentes (recomendado)
```bash
npm run start
```
Esto iniciará los emuladores y:
- Importará datos previos si existen
- Exportará datos al cerrar

#### Opción B: Fresh start (datos limpios)
```bash
npm run start:fresh
```

### 4. Poblar con Datos de Ejemplo
```bash
# En otra terminal (con emuladores corriendo)
npm run seed
```

## 📊 Acceso a los Emuladores

Una vez iniciados, puedes acceder a:

- **UI del Emulador**: http://localhost:4000
- **Firestore**: http://localhost:8080
- **Authentication**: http://localhost:9099
- **Storage**: http://localhost:9199

## 📁 Estructura de Archivos

```
FirebaseLocalEmulator/
├── firebase.json          # Configuración principal
├── firestore.rules        # Reglas de seguridad Firestore
├── storage.rules          # Reglas de seguridad Storage
├── firestore.indexes.json # Índices de Firestore
├── package.json           # Dependencias y scripts
├── scripts/
│   └── seed-data.js       # Script para datos de prueba
├── data/                  # Datos exportados/importados
└── README.md             # Esta documentación
```

## 🎯 Conceptos Firebase Demostrados

### 1. **Firestore Database**
- Colecciones y documentos
- Subcollections anidadas
- Timestamps automáticos
- Consultas complejas con índices

### 2. **Authentication**
- Usuarios con email/password
- Estados de autenticación
- Tokens de seguridad

### 3. **Storage**
- Subida de archivos (fotos de perfil)
- Organización por carpetas
- URLs de descarga

### 4. **Security Rules**
- Autorización basada en usuario
- Validación de datos
- Permisos granulares

## 📚 Esquema de Datos Educativo

### Colección: `users`
```javascript
users/{userId} = {
  email: string,
  nombre: string,
  apellido: string,
  fotoPerfilUrl: string | null,
  fechaCreacion: timestamp,
  fechaUltimaActividad: timestamp
}
```

### Colección: `libraries` (subcollection)
```javascript
libraries/{userId}/books/{bookId} = {
  bookId: string,      // ID de la API externa
  titulo: string,
  autor: string,
  portadaUrl: string,
  fechaAgregado: timestamp,
  tieneReseña: boolean
}
```

### Colección: `reviews`
```javascript
reviews/{reviewId} = {
  userId: string,
  bookId: string,
  calificacion: number,        // 1-5
  textoReseña: string,
  fechaCreacion: timestamp,
  fechaModificacion: timestamp
}
```

## 🛠️ Comandos Útiles

```bash
# Ver logs detallados
firebase emulators:start --debug

# Exportar datos manualmente
firebase emulators:export ./backup

# Importar datos específicos
firebase emulators:start --import=./backup

# Limpiar datos
rm -rf ./data
```

## 🐛 Troubleshooting

### Puerto ocupado
```bash
# Matar procesos en puerto específico
lsof -ti:4000 | xargs kill -9
```

### Problemas de permisos
```bash
# Verificar reglas de Firestore
firebase firestore:rules:get
```

### Datos no se guardan
- Verificar que los emuladores estén corriendo
- Comprobar las reglas de seguridad
- Revisar la consola del navegador

## 📖 Recursos Educativos

- [Firebase Emulator Suite Docs](https://firebase.google.com/docs/emulator-suite)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Firebase Storage Rules](https://firebase.google.com/docs/storage/security)

---

**💡 Tip Educativo**: Usa la UI del emulador (http://localhost:4000) para explorar visualmente los datos y entender cómo funciona Firebase en tiempo real.