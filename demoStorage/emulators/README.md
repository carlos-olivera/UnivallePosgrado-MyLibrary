# Emulador Firebase Storage - Demo Educativo

## 🎯 Objetivo

Este directorio contiene la configuración para ejecutar el emulador de Firebase Storage localmente, permitiendo desarrollar y probar funcionalidades de almacenamiento sin costos ni configuración compleja.

## 📋 Requisitos Previos

1. **Node.js** (versión 16 o superior)
2. **Firebase CLI** instalado globalmente:
   ```bash
   npm install -g firebase-tools
   ```

## 🚀 Instrucciones de Uso

### Paso 1: Instalar dependencias
```bash
npm install
```

### Paso 2: Iniciar el emulador
```bash
npm start
```

Esto iniciará:
- **Emulador de Storage** en `http://localhost:9199`
- **Firebase UI** en `http://localhost:4000`

### Paso 3: Verificar funcionamiento
- Abre `http://localhost:4000` en tu navegador
- Verás la interfaz de Firebase Emulator Suite
- Navega a la sección "Storage" para ver archivos cargados

## 📁 Archivos de Configuración

### `firebase.json`
- Configura los puertos y servicios del emulador
- Define que use `storage.rules` para las reglas de seguridad

### `storage.rules`
- Reglas de seguridad permisivas para demostración
- **⚠️ NUNCA usar en producción**
- Permite lectura/escritura sin autenticación

### `.firebaserc`
- Define el ID del proyecto para el emulador
- No requiere proyecto real de Firebase

## 🔧 Comandos Útiles

```bash
# Iniciar emulador
npm start

# Parar emulador
Ctrl + C

# Ver logs detallados
firebase emulators:start --debug

# Limpiar datos del emulador
# (los datos se pierden automáticamente al reiniciar)
```

## 📚 Conceptos Educativos

### 1. **Emuladores vs Producción**
- Los emuladores simulan servicios reales sin costos
- Datos temporales (se pierden al reiniciar)
- Perfecto para desarrollo y testing

### 2. **Storage Rules**
- Definen quién puede leer/escribir archivos
- Sintaxis declarativa similar a Firestore
- Importante para seguridad en producción

### 3. **Configuración de Puertos**
- Storage: 9199 (estándar)
- UI: 4000 (interfaz web)
- Puertos configurables en `firebase.json`

## 🚨 Notas Importantes

1. **Solo para desarrollo**: Nunca usar reglas permisivas en producción
2. **Datos temporales**: Todo se pierde al reiniciar el emulador
3. **Red local**: Solo accesible desde localhost por defecto
4. **Sin autenticación**: Este demo no incluye Firebase Auth

## 🛠️ Troubleshooting

### Error: Puerto ocupado
```bash
# Verificar qué proceso usa el puerto
lsof -i :9199

# Cambiar puerto en firebase.json si es necesario
```

### Error: Firebase CLI no encontrado
```bash
# Instalar Firebase CLI globalmente
npm install -g firebase-tools

# Verificar instalación
firebase --version
```

### No se ven archivos en la UI
- Verifica que el cliente esté conectado al emulador
- Revisa la consola del navegador para errores
- Asegúrate que las URLs coincidan (localhost:9199)