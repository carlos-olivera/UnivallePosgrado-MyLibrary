# Demo Firebase Storage

Este directorio contiene un demo educativo simple para demostrar el uso de Firebase Storage con emulador local y un cliente React Native Expo.

## Estructura del Proyecto

```
demoStorage/
├── emulators/          # Configuración del emulador Firebase
│   ├── firebase.json
│   ├── storage.rules
│   └── package.json
└── reactNativeClient/  # Cliente React Native Expo
    ├── App.js
    ├── package.json
    └── ...
```

## Objetivo Educativo

Demostrar de manera simple:
1. Configuración de Firebase Storage Emulator
2. Selección de imagen desde dispositivo
3. Carga de imagen a Firebase Storage
4. Visualización de imagen desde Storage

## Instrucciones

1. Navegar a `emulators/` y ejecutar `npm start` para iniciar el emulador
2. Navegar a `reactNativeClient/` y ejecutar `expo start` para la app
3. La app mostrará un recuadro - tocar para seleccionar imagen
4. La imagen se carga automáticamente a Storage y se visualiza