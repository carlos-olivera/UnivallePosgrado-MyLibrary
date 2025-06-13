# Cliente React Native - Demo Firebase Storage

## 🎯 Objetivo

Aplicación React Native Expo que demuestra los conceptos básicos de Firebase Storage:
- Selección de imagen desde dispositivo
- Carga a Firebase Storage (emulador)
- Visualización desde Storage

## 📋 Requisitos Previos

1. **Node.js** (versión 16 o superior)
2. **Expo CLI** instalado globalmente:
   ```bash
   npm install -g @expo/cli
   ```
3. **Emulador Firebase Storage** ejecutándose (ver directorio `../emulators/`)

## 🚀 Instrucciones de Uso

### Paso 1: Instalar dependencias
```bash
npm install
```

### Paso 2: Iniciar la aplicación
```bash
npm start
```

### Paso 3: Abrir en dispositivo/simulador
- **iOS**: Presionar `i` en la terminal o escanear QR con Expo Go
- **Android**: Presionar `a` en la terminal o escanear QR con Expo Go
- **Web**: Presionar `w` en la terminal

## 📱 Funcionalidad de la App

### Interfaz Simple
- **Recuadro central**: Área para mostrar/seleccionar imagen
- **Texto informativo**: Explica qué hacer
- **Estados visuales**: Carga, éxito, error

### Flujo de Uso
1. **Tocar recuadro** → Abre selector de imágenes
2. **Seleccionar imagen** → Se muestra preview local
3. **Carga automática** → Sube a Firebase Storage
4. **Visualización final** → Muestra imagen desde Storage URL

## 📁 Estructura de Archivos

```
reactNativeClient/
├── App.js              # Componente principal
├── firebaseConfig.js   # Configuración Firebase
├── package.json        # Dependencias y scripts
├── app.json           # Configuración Expo
└── babel.config.js    # Configuración Babel
```

## 🔧 Archivos Principales

### `App.js`
- Componente principal con toda la lógica
- Manejo de estados (imagen, carga, errores)
- Interfaz de usuario responsive
- Comentarios educativos extensos

### `firebaseConfig.js`
- Configuración para conectar al emulador
- Inicialización de Firebase Storage
- Explicaciones sobre desarrollo vs producción

## 📚 Conceptos Educativos Demostrados

### 1. **React Native Básico**
```javascript
// Hooks para estado
const [imageUri, setImageUri] = useState(null);

// Componentes nativos
<TouchableOpacity onPress={selectImage}>
  <Image source={{ uri: imageUri }} />
</TouchableOpacity>
```

### 2. **Firebase Storage Operations**
```javascript
// Referencia al archivo
const storageRef = ref(storage, 'images/photo.jpg');

// Subir archivo
await uploadBytes(storageRef, blob);

// Obtener URL de descarga
const url = await getDownloadURL(storageRef);
```

### 3. **Async/Await Pattern**
```javascript
const uploadImage = async () => {
  try {
    const result = await ImagePicker.launchImageLibraryAsync();
    const response = await fetch(result.uri);
    const blob = await response.blob();
    await uploadBytes(storageRef, blob);
  } catch (error) {
    console.error(error);
  }
};
```

### 4. **Image Picker Integration**
```javascript
// Solicitar permisos
const permission = await ImagePicker.requestMediaLibraryPermissionsAsync();

// Abrir galería
const result = await ImagePicker.launchImageLibraryAsync({
  mediaTypes: ImagePicker.MediaTypeOptions.Images,
  allowsEditing: true,
  quality: 0.8,
});
```

## 🎨 Características de UI/UX

### Estados Visuales
- **Placeholder**: Icono y texto cuando no hay imagen
- **Preview local**: Imagen seleccionada con opacidad reducida
- **Loading**: Indicador circular durante carga
- **Final**: Imagen desde Storage con opacidad completa

### Responsive Design
- Tamaño de imagen adaptable (70% del ancho de pantalla)
- Estilos que funcionan en diferentes dispositivos
- Layout centrado y espaciado apropiado

### Feedback al Usuario
- Textos de progreso ("Subiendo...", "Convirtiendo...")
- Indicadores visuales de estado
- Mensajes de error informativos

## 🚨 Requisitos Importantes

### Permisos
- **iOS**: Acceso a galería de fotos
- **Android**: Acceso a almacenamiento externo

### Emulador Firebase
- Debe estar ejecutándose en `localhost:9199`
- Verificar conexión en consola del dispositivo

## 🛠️ Troubleshooting

### Error: No se conecta al emulador
```javascript
// Verificar configuración en firebaseConfig.js
connectStorageEmulator(storage, 'localhost', 9199);
```

### Error: Permisos de imagen
```javascript
// Verificar permisos en app.json
"plugins": [
  ["expo-image-picker", {
    "photosPermission": "Mensaje personalizado"
  }]
]
```

### Error: Expo Go no escanea QR
- Verificar que dispositivo y computadora estén en la misma red
- Usar túnel: `expo start --tunnel`

## 🎓 Objetivos de Aprendizaje

Al completar este demo, los estudiantes entenderán:

1. **Configuración básica** de Firebase en React Native
2. **Operaciones CRUD** en Firebase Storage
3. **Manejo de archivos** y conversión a Blob
4. **Async/await** para operaciones asíncronas
5. **Estados de UI** y feedback al usuario
6. **Permisos de dispositivo** en aplicaciones móviles
7. **Diferencias** entre desarrollo y producción