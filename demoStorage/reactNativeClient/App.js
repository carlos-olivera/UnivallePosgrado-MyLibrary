// **APLICACIÓN DEMO DE FIREBASE STORAGE - EDUCATIVO** 🎓
//
// Esta app demuestra los conceptos básicos de Firebase Storage:
// 1. Selección de imagen desde el dispositivo
// 2. Carga de imagen a Firebase Storage
// 3. Visualización de imagen desde Storage
//
// Conceptos educativos demostrados:
// - React Native components y hooks
// - Firebase Storage operations (upload/download)
// - Image picker con expo-image-picker
// - Estados de carga y manejo de errores
// - Async/await para operaciones asíncronas

import React, { useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  Image,
  Alert,
  ActivityIndicator,
  Dimensions
} from 'react-native';
import { StatusBar } from 'expo-status-bar';
import * as ImagePicker from 'expo-image-picker';
import { ref, uploadBytes, getDownloadURL } from 'firebase/storage';
import { storage } from './firebaseConfig';

// **OBTENER DIMENSIONES DE PANTALLA** 📱
const { width } = Dimensions.get('window');
const imageSize = width * 0.7; // 70% del ancho de pantalla

export default function App() {
  // **ESTADOS DE LA APLICACIÓN** 📊
  // useState es un hook que nos permite manejar estado en componentes funcionales
  const [imageUri, setImageUri] = useState(null);        // URI de la imagen seleccionada
  const [uploadedImageUrl, setUploadedImageUrl] = useState(null); // URL de la imagen en Firebase
  const [isLoading, setIsLoading] = useState(false);     // Estado de carga
  const [uploadProgress, setUploadProgress] = useState(''); // Texto de progreso

  // **FUNCIÓN PARA SELECCIONAR IMAGEN** 📸
  // Esta función maneja todo el flujo: selección, carga y visualización
  const selectAndUploadImage = async () => {
    try {
      // **PASO 1: SOLICITAR PERMISOS** 🔐
      // Necesitamos permisos para acceder a la galería de fotos
      const permissionResult = await ImagePicker.requestMediaLibraryPermissionsAsync();
      
      if (!permissionResult.granted) {
        Alert.alert(
          'Permisos necesarios',
          'La app necesita permisos para acceder a tus fotos'
        );
        return;
      }

      // **PASO 2: ABRIR SELECTOR DE IMÁGENES** 🖼️
      setUploadProgress('Seleccionando imagen...');
      
      const result = await ImagePicker.launchImageLibraryAsync({
        mediaTypes: ImagePicker.MediaTypeOptions.Images, // Solo imágenes
        allowsEditing: true,   // Permitir edición/recorte
        aspect: [1, 1],        // Aspecto cuadrado
        quality: 0.8,          // Calidad de imagen (80%)
      });

      // Si el usuario canceló la selección
      if (result.canceled) {
        setUploadProgress('');
        return;
      }

      // **PASO 3: PREPARAR PARA CARGA** 🚀
      const selectedImage = result.assets[0];
      setImageUri(selectedImage.uri); // Mostrar imagen seleccionada
      setIsLoading(true);
      setUploadProgress('Preparando imagen...');

      // **PASO 4: CONVERTIR IMAGEN A BLOB** 💾
      // Firebase Storage necesita un Blob para cargar archivos
      setUploadProgress('Convirtiendo imagen...');
      
      const response = await fetch(selectedImage.uri);
      const blob = await response.blob();

      // **PASO 5: CREAR REFERENCIA EN STORAGE** 📁
      // Crear un nombre único para la imagen usando timestamp
      const timestamp = Date.now();
      const fileName = `images/demo_image_${timestamp}.jpg`;
      const storageRef = ref(storage, fileName);

      setUploadProgress('Subiendo a Firebase Storage...');

      // **PASO 6: CARGAR IMAGEN A FIREBASE STORAGE** ⬆️
      // uploadBytes() sube el archivo al servidor
      const snapshot = await uploadBytes(storageRef, blob);
      
      console.log('✅ Imagen cargada exitosamente:', snapshot.metadata.name);

      // **PASO 7: OBTENER URL DE DESCARGA** 🔗
      // getDownloadURL() nos da la URL pública para mostrar la imagen
      setUploadProgress('Obteniendo URL de imagen...');
      
      const downloadURL = await getDownloadURL(storageRef);
      
      // **PASO 8: MOSTRAR IMAGEN DESDE STORAGE** 🖼️
      setUploadedImageUrl(downloadURL);
      setUploadProgress('¡Imagen cargada exitosamente!');
      
      console.log('🔗 URL de descarga:', downloadURL);

      // Limpiar mensaje de progreso después de 2 segundos
      setTimeout(() => {
        setUploadProgress('');
      }, 2000);

    } catch (error) {
      // **MANEJO DE ERRORES** ❌
      console.error('❌ Error en el proceso:', error);
      
      Alert.alert(
        'Error',
        'Hubo un problema al cargar la imagen. Verifica que el emulador esté funcionando.',
        [{ text: 'OK' }]
      );
      
      setUploadProgress('');
    } finally {
      // **LIMPIAR ESTADO DE CARGA** 🧹
      setIsLoading(false);
    }
  };

  // **FUNCIÓN PARA LIMPIAR/REINICIAR** 🔄
  const resetApp = () => {
    setImageUri(null);
    setUploadedImageUrl(null);
    setUploadProgress('');
    setIsLoading(false);
  };

  // **RENDERIZADO DE LA INTERFAZ** 🎨
  return (
    <View style={styles.container}>
      <StatusBar style="auto" />
      
      {/* **TÍTULO DE LA APP** */}
      <Text style={styles.title}>Firebase Storage Demo</Text>
      <Text style={styles.subtitle}>
        Toca el recuadro para seleccionar y cargar una imagen
      </Text>

      {/* **RECUADRO PRINCIPAL PARA IMAGEN** */}
      <TouchableOpacity 
        style={styles.imageContainer}
        onPress={selectAndUploadImage}
        disabled={isLoading} // Deshabilitar mientras carga
      >
        {uploadedImageUrl ? (
          // **MOSTRAR IMAGEN DESDE FIREBASE STORAGE** 🖼️
          <Image 
            source={{ uri: uploadedImageUrl }} 
            style={styles.image}
            resizeMode="cover"
          />
        ) : imageUri ? (
          // **MOSTRAR IMAGEN SELECCIONADA LOCALMENTE** 📱
          <Image 
            source={{ uri: imageUri }} 
            style={[styles.image, styles.localImage]}
            resizeMode="cover"
          />
        ) : (
          // **MOSTRAR PLACEHOLDER CUANDO NO HAY IMAGEN** 📷
          <View style={styles.placeholder}>
            <Text style={styles.placeholderIcon}>📷</Text>
            <Text style={styles.placeholderText}>
              Tocar para seleccionar imagen
            </Text>
          </View>
        )}

        {/* **INDICADOR DE CARGA SUPERPUESTO** */}
        {isLoading && (
          <View style={styles.loadingOverlay}>
            <ActivityIndicator size="large" color="#007AFF" />
          </View>
        )}
      </TouchableOpacity>

      {/* **TEXTO DE PROGRESO** */}
      {uploadProgress ? (
        <Text style={styles.progressText}>{uploadProgress}</Text>
      ) : null}

      {/* **BOTÓN DE REINICIO** */}
      {(imageUri || uploadedImageUrl) && (
        <TouchableOpacity style={styles.resetButton} onPress={resetApp}>
          <Text style={styles.resetButtonText}>Seleccionar otra imagen</Text>
        </TouchableOpacity>
      )}

      {/* **INFORMACIÓN EDUCATIVA** */}
      <View style={styles.infoContainer}>
        <Text style={styles.infoTitle}>¿Qué hace esta app?</Text>
        <Text style={styles.infoText}>
          1. Selecciona una imagen de tu galería{'\n'}
          2. La carga a Firebase Storage emulador{'\n'}
          3. Obtiene la URL pública{'\n'}
          4. Muestra la imagen desde Storage
        </Text>
        
        {uploadedImageUrl && (
          <View style={styles.urlContainer}>
            <Text style={styles.urlTitle}>URL en Firebase Storage:</Text>
            <Text style={styles.urlText} numberOfLines={2}>
              {uploadedImageUrl}
            </Text>
          </View>
        )}
      </View>
    </View>
  );
}

// **ESTILOS DE LA APLICACIÓN** 🎨
// StyleSheet.create() optimiza los estilos para mejor rendimiento
const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 8,
    textAlign: 'center',
  },
  subtitle: {
    fontSize: 16,
    color: '#666',
    marginBottom: 30,
    textAlign: 'center',
    paddingHorizontal: 20,
  },
  imageContainer: {
    width: imageSize,
    height: imageSize,
    borderRadius: 12,
    borderWidth: 2,
    borderColor: '#ddd',
    borderStyle: 'dashed',
    backgroundColor: '#fff',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 20,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  image: {
    width: '100%',
    height: '100%',
    borderRadius: 10,
  },
  localImage: {
    opacity: 0.7, // Imagen local más transparente
  },
  placeholder: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  placeholderIcon: {
    fontSize: 48,
    marginBottom: 12,
  },
  placeholderText: {
    fontSize: 16,
    color: '#999',
    textAlign: 'center',
  },
  loadingOverlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(255, 255, 255, 0.8)',
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 10,
  },
  progressText: {
    fontSize: 14,
    color: '#007AFF',
    textAlign: 'center',
    marginBottom: 20,
    fontWeight: '500',
  },
  resetButton: {
    backgroundColor: '#007AFF',
    paddingHorizontal: 24,
    paddingVertical: 12,
    borderRadius: 8,
    marginBottom: 30,
  },
  resetButtonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: '600',
  },
  infoContainer: {
    backgroundColor: '#fff',
    padding: 16,
    borderRadius: 12,
    width: '100%',
    maxWidth: 400,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 2,
    elevation: 2,
  },
  infoTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 8,
  },
  infoText: {
    fontSize: 14,
    color: '#666',
    lineHeight: 20,
  },
  urlContainer: {
    marginTop: 12,
    padding: 12,
    backgroundColor: '#f8f9fa',
    borderRadius: 8,
  },
  urlTitle: {
    fontSize: 12,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 4,
  },
  urlText: {
    fontSize: 10,
    color: '#666',
    fontFamily: 'monospace',
  },
});

// **NOTAS EDUCATIVAS ADICIONALES** 📚
//
// 1. **React Hooks**: useState para manejar estado del componente
// 2. **Async/Await**: Para manejar operaciones asíncronas de manera limpia
// 3. **Firebase Storage**: Upload y download de archivos
// 4. **Image Picker**: Selección de imágenes del dispositivo
// 5. **Error Handling**: Try/catch para manejo robusto de errores
// 6. **UI/UX**: Estados de carga y feedback al usuario
// 7. **Responsive Design**: Estilos que se adaptan al tamaño de pantalla