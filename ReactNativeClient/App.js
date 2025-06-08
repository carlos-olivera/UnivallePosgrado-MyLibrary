import React from 'react';
import { StatusBar } from 'expo-status-bar';
import { NavigationContainer } from '@react-navigation/native';
import { Provider as PaperProvider } from 'react-native-paper';

// Context Providers
import { AuthProvider } from './src/context/AuthContext';
import { LibraryProvider } from './src/context/LibraryContext';
import { ToastProvider } from './src/context/ToastContext';

// Navigation
import AppNavigator from './src/navigation/AppNavigator';

// Theme
import { theme } from './src/constants/theme';

/**
 * **COMPONENTE PRINCIPAL DE LA APP MYLIBRARY** 📱
 * 
 * Esta es la entrada principal de la aplicación React Native.
 * Demuestra el patrón de Provider/Context para manejo de estado global.
 * 
 * Conceptos educativos demostrados:
 * - Context API para estado global
 * - Navigation setup
 * - Provider pattern
 * - Theme configuration
 */
export default function App() {
  return (
    <PaperProvider theme={theme}>
      <NavigationContainer>
        {/* 
          **PATRÓN DE PROVIDERS ANIDADOS** 🎯
          Los providers se anidam para proporcionar diferentes contextos:
          1. AuthProvider: Estado de autenticación global
          2. LibraryProvider: Estado de la librería personal
          3. ToastProvider: Sistema de notificaciones
        */}
        <AuthProvider>
          <LibraryProvider>
            <ToastProvider>
              <StatusBar style="auto" />
              <AppNavigator />
            </ToastProvider>
          </LibraryProvider>
        </AuthProvider>
      </NavigationContainer>
    </PaperProvider>
  );
}