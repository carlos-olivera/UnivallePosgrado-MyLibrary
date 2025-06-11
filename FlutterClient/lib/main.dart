import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'core/constants/firebase_options.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/books_provider.dart';
import 'presentation/providers/library_provider.dart';
import 'presentation/providers/theme_provider.dart';

/// **MAIN EDUCATIVO PARA MYLIBRARY FLUTTER** 🚀
/// 
/// Este archivo demuestra:
/// - Inicialización correcta de Firebase
/// - Configuración de Providers para gestión de estado
/// - Setup de la aplicación con patrones profesionales
/// - Manejo de errores en la inicialización
/// 
/// Conceptos educativos demostrados:
/// - Async initialization con FutureBuilder
/// - Multi-provider setup para separación de responsabilidades
/// - Error boundaries y fallbacks
/// - Firebase initialization patterns

void main() async {
  // **INICIALIZACIÓN FLUTTER** ⚡
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // **INICIALIZACIÓN FIREBASE** 🔥
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    debugPrint('🔥 Firebase inicializado correctamente');
    
    // **EJECUTAR APLICACIÓN** 🏃‍♂️
    runApp(const MyLibraryApp());
    
  } catch (error, stackTrace) {
    // **MANEJO DE ERRORES CRÍTICOS** ❌
    debugPrint('❌ Error inicializando Firebase: $error');
    debugPrint('Stack trace: $stackTrace');
    
    // Ejecutar app con estado de error
    runApp(MaterialApp(
      title: 'MyLibrary - Error',
      home: Scaffold(
        backgroundColor: Colors.red.shade50,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade600,
              ),
              const SizedBox(height: 16),
              Text(
                'Error de inicialización',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'No se pudo inicializar Firebase. Verifica la configuración.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

/// **APLICACIÓN PRINCIPAL CON PROVIDERS** 🏗️
/// 
/// Envuelve la aplicación con múltiples providers para gestión de estado.
/// Demuestra el patrón de separación de responsabilidades en Flutter.
class MyLibraryApp extends StatelessWidget {
  const MyLibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // **PROVIDER DE AUTENTICACIÓN** 🔐
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        
        // **PROVIDER DE TEMA** 🎨
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        
        // **PROVIDER DE LIBROS** 📚
        ChangeNotifierProvider(
          create: (context) => BooksProvider(),
        ),
        
        // **PROVIDER DE LIBRERÍA PERSONAL** 📖
        ChangeNotifierProxyProvider<AuthProvider, LibraryProvider>(
          create: (context) => LibraryProvider(),
          update: (context, authProvider, libraryProvider) {
            // Actualizar librería cuando cambie el usuario
            libraryProvider?.updateUser(authProvider.user);
            return libraryProvider ?? LibraryProvider();
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return const MyLibraryMainApp();
        },
      ),
    );
  }
}

/// **APLICACIÓN PRINCIPAL** 📱
/// 
/// Componente principal que inicializa la aplicación Flutter.
/// Demuestra configuración de temas, navegación y estructura general.
class MyLibraryMainApp extends StatelessWidget {
  const MyLibraryMainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      // Inicialización asíncrona de servicios
      future: _initializeServices(context),
      builder: (context, snapshot) {
        // **PANTALLA DE SPLASH DURANTE INICIALIZACIÓN** ⏳
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            title: 'MyLibrary',
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
          );
        }
        
        // **ERROR EN INICIALIZACIÓN** ❌
        if (snapshot.hasError) {
          return MaterialApp(
            title: 'MyLibrary - Error',
            debugShowCheckedModeBanner: false,
            home: ErrorScreen(error: snapshot.error.toString()),
          );
        }
        
        // **APLICACIÓN INICIALIZADA CORRECTAMENTE** ✅
        return const App();
      },
    );
  }
  
  /// **INICIALIZAR SERVICIOS** 🛠️
  /// 
  /// Inicializa todos los servicios necesarios para la aplicación.
  Future<void> _initializeServices(BuildContext context) async {
    try {
      // Inicializar provider de autenticación
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.initialize();
      
      // Inicializar provider de tema
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      await themeProvider.initialize();
      
      debugPrint('✅ Servicios inicializados correctamente');
    } catch (error) {
      debugPrint('❌ Error inicializando servicios: $error');
      rethrow;
    }
  }
}

/// **PANTALLA DE SPLASH** ⏳
/// 
/// Pantalla mostrada durante la inicialización de la aplicación.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1976D2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo de la aplicación
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.library_books,
                size: 64,
                color: Color(0xFF1976D2),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Título
            const Text(
              'MyLibrary',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Subtítulo
            const Text(
              'Tu biblioteca digital',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Indicador de carga
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

/// **PANTALLA DE ERROR** ❌
/// 
/// Pantalla mostrada cuando hay errores en la inicialización.
class ErrorScreen extends StatelessWidget {
  final String error;
  
  const ErrorScreen({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade600,
              ),
              
              const SizedBox(height: 24),
              
              Text(
                'Error de inicialización',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              Text(
                error,
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: () {
                  // Reiniciar la aplicación
                  main();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}