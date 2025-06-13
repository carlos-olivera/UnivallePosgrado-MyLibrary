// **CONFIGURACIÓN DE FIREBASE - DEMO EDUCATIVO** 🔥
//
// Este archivo configura Firebase para conectarse al emulador local
// en lugar de los servicios de producción de Firebase.
//
// Conceptos educativos demostrados:
// - Configuración de Firebase SDK
// - Uso de emuladores para desarrollo
// - Diferencia entre desarrollo y producción
// - Inicialización de servicios Firebase

import { initializeApp } from 'firebase/app';
import { getStorage, connectStorageEmulator } from 'firebase/storage';

// **CONFIGURACIÓN MÍNIMA PARA EMULADOR** ⚙️
// Para el emulador, solo necesitamos un projectId
// En producción, aquí irían las claves reales de Firebase
const firebaseConfig = {
  projectId: "mylibrary-demo-storage", // ID del proyecto (puede ser cualquiera para emulador)
  storageBucket: "mylibrary-demo-storage.appspot.com" // Bucket de storage
};

// **INICIALIZAR FIREBASE APP** 🚀
// Esta función crea la instancia principal de Firebase
const app = initializeApp(firebaseConfig);

// **INICIALIZAR FIREBASE STORAGE** 📁
// Obtener referencia al servicio de Storage
const storage = getStorage(app);

// **CONECTAR AL EMULADOR DE STORAGE** 🔧
// Esto le dice a Firebase que use el emulador local en lugar del servicio real
// Solo se ejecuta una vez para evitar errores de reconexión
if (!storage._delegate._host.includes('localhost')) {
  // Conectar al emulador en localhost:9199 (puerto configurado en firebase.json)
  connectStorageEmulator(storage, 'localhost', 9199);
  
  console.log('🔧 Conectado al emulador de Firebase Storage en localhost:9199');
}

// **EXPORTAR PARA USO EN LA APP** 📤
// Exportamos la instancia de storage para usarla en otros archivos
export { storage };

// **NOTAS EDUCATIVAS** 📚
// 
// 1. En producción, firebaseConfig contendría claves reales
// 2. connectStorageEmulator() solo se debe llamar en desarrollo
// 3. El emulador permite desarrollo sin costos ni configuración compleja
// 4. Los datos del emulador se pierden al reiniciar (perfecto para testing)