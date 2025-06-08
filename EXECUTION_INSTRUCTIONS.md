# 🚀 Instrucciones de Ejecución - MyLibrary

## Problemas Solucionados

### ✅ Bug #1: Datos de prueba no aparecen en emulador
**Solución**: Mejorado el script de seeding con verificaciones previas.

### ✅ Bug #2: Incompatibilidad Expo SDK 49 vs 53
**Solución**: Actualizado el proyecto a Expo SDK 53.

---

## 📋 Prerrequisitos

1. **Node.js** (versión 18 o superior)
2. **npm** o **yarn**
3. **Firebase CLI**: `npm install -g firebase-tools`
4. **Expo CLI**: `npm install -g @expo/cli`

---

## 🔧 Configuración Inicial

### 1. Instalar dependencias

```bash
# En el directorio raíz del proyecto
cd /path/to/MyLibrary

# Instalar dependencias del emulador
cd FirebaseLocalEmulator
npm install

# Instalar dependencias del cliente React Native
cd ../ReactNativeClient
npm install
```

### 2. Verificar versiones compatibles

```bash
# Verificar versión de Node.js
node --version  # Debe ser 18.x o superior

# Verificar Firebase CLI
firebase --version  # Debe ser 12.x o superior

# Verificar Expo CLI
expo --version  # Debe ser 51.x o superior
```

---

## 🚀 Ejecución Paso a Paso

### Paso 1: Iniciar Emuladores Firebase

```bash
cd FirebaseLocalEmulator
npm run start
```

**Resultado esperado**:
- Firestore emulator: `http://localhost:8080`
- Auth emulator: `http://localhost:9099`
- Storage emulator: `http://localhost:9199`
- Firebase UI: `http://localhost:4000`

### Paso 2: Poblar con Datos de Prueba

**En una nueva terminal**:

```bash
cd FirebaseLocalEmulator
npm run seed
```

**El script mejorado verificará**:
- ✅ Emuladores están corriendo
- ✅ Puertos están disponibles
- ✅ Conectividad con Firebase

**Datos creados**:
- 2 usuarios de ejemplo
- 3 libros en librerías personales
- 2 reseñas de ejemplo

### Paso 3: Verificar Datos en Firebase UI

1. Abrir: `http://localhost:4000`
2. Ir a **Firestore**
3. Verificar colecciones:
   - `users` (2 documentos)
   - `libraries/{userId}/books` (subcollecciones)
   - `reviews` (2 documentos)

### Paso 4: Iniciar Cliente React Native

**En una nueva terminal**:

```bash
cd ReactNativeClient

# Para desarrollo con Expo
npm start

# O específicamente para tu dispositivo
npm run android  # Para Android
npm run ios      # Para iOS
```

### Paso 5: Configurar Cliente para Emuladores

El cliente ya está configurado para usar emuladores locales en desarrollo. Verificar que en `src/services/firebase/config.js` esté:

```javascript
// Configuración automática para emuladores en desarrollo
if (__DEV__) {
  // Conectar a emuladores locales
}
```

---

## 🧪 Pruebas Recomendadas

### Prueba 1: Autenticación Demo
1. En la app, tocar **"Modo Demo"**
2. Verificar login automático con `demo@mylibrary.com`
3. Navegar entre tabs

### Prueba 2: Registro Manual
1. Tocar **"Crear cuenta"**
2. Completar formulario
3. Verificar creación en Firebase UI (`http://localhost:4000`)

### Prueba 3: Navegación
1. Probar tabs: Inicio, Tienda, Librería, Perfil
2. Verificar animaciones y transiciones
3. Probar navegación back

### Prueba 4: Datos de Firebase
1. En Firebase UI, verificar usuarios en tiempo real
2. Agregar/modificar datos manualmente
3. Verificar cambios reflejados en app

---

## 🐛 Troubleshooting

### Error: "Metro bundler failed to start"
```bash
# Limpiar cache de Metro
cd ReactNativeClient
npx expo start -c
```

### Error: "Firebase emulator not found"
```bash
# Verificar instalación Firebase CLI
npm install -g firebase-tools
firebase --version
```

### Error: "Port already in use"
```bash
# Verificar y matar procesos en puertos
lsof -ti:8080 | xargs kill -9  # Firestore
lsof -ti:9099 | xargs kill -9  # Auth
lsof -ti:4000 | xargs kill -9  # UI
```

### Error: "Expo SDK version mismatch"
```bash
# El proyecto ya está actualizado a SDK 53
cd ReactNativeClient
npm install
expo install --fix
```

### Error: "Seeding data not visible"
```bash
# Usar el script mejorado que verifica conexiones
cd FirebaseLocalEmulator
npm run seed

# Si persiste, verificar manualmente:
npm run seed:direct
```

---

## 📱 Prueba en Dispositivo Físico

### Para Android:
1. Habilitar **Modo Desarrollador**
2. Activar **Depuración USB**
3. Conectar dispositivo
4. Ejecutar: `npm run android`

### Para iOS:
1. Tener Xcode instalado
2. Dispositivo registrado en Apple Developer
3. Ejecutar: `npm run ios`

### Para Expo Go (Recomendado):
1. Instalar **Expo Go** desde la tienda
2. Escanear QR desde `npm start`
3. La app se ejecutará en Expo Go

---

## 🎯 Próximos Pasos

Una vez funcionando correctamente:

1. **Implementar pantallas faltantes**:
   - LibraryScreen
   - ProfileScreen
   - BookDetailScreen

2. **Agregar funcionalidades**:
   - Búsqueda de libros (Google Books API)
   - Sistema de reseñas completo
   - Gestión de perfil de usuario

3. **Testing**:
   - Unit tests con Jest
   - Integration tests
   - E2E tests con Detox

---

## 💡 Notas Educativas

Este proyecto demuestra:

- **Firebase Emulator Suite** para desarrollo local
- **React Native con Expo** para desarrollo móvil
- **Context API** para manejo de estado
- **Material Design 3** para UI/UX
- **Navegación híbrida** (Stack + Tabs)
- **Patrones de arquitectura** educativos

---

## 📞 Soporte

Si encuentras problemas:

1. Verificar que todas las dependencias estén instaladas
2. Comprobar que los emuladores estén corriendo
3. Revisar logs en las terminales
4. Consultar Firebase UI para verificar datos

**Firebase UI**: `http://localhost:4000`
**Metro Bundler**: Mostrado al ejecutar `npm start`