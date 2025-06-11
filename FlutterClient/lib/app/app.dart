import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../presentation/providers/auth_provider.dart';
import '../presentation/providers/theme_provider.dart';
import 'routes.dart';
import 'theme.dart';

/// **APLICACIÓN PRINCIPAL EDUCATIVA** 📱
/// 
/// Este widget demuestra:
/// - Configuración de temas dinámicos
/// - Navegación con GoRouter
/// - Consumer patterns para estado reactivo
/// - Configuración de Material Design 3
/// 
/// Conceptos educativos demostrados:
/// - App-level configuration
/// - Theme management
/// - Navigation setup
/// - Provider consumption

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, AuthProvider>(
      builder: (context, themeProvider, authProvider, child) {
        return MaterialApp.router(
          // **CONFIGURACIÓN BÁSICA** ⚙️
          title: 'MyLibrary - Universidad del Valle',
          debugShowCheckedModeBanner: false,
          
          // **CONFIGURACIÓN DE TEMA** 🎨
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          
          // **CONFIGURACIÓN DE NAVEGACIÓN** 🧭
          routerConfig: AppRoutes.router,
          
          // **CONFIGURACIÓN DE LOCALIZACIÓN** 🌍
          supportedLocales: const [
            Locale('es', 'ES'), // Español
            Locale('en', 'US'), // Inglés
          ],
          locale: const Locale('es', 'ES'),
          
          // **BUILDER PARA CONFIGURACIONES GLOBALES** 🏗️
          builder: (context, child) {
            return _AppBuilder(child: child);
          },
        );
      },
    );
  }
}

/// **BUILDER DE APLICACIÓN** 🏗️
/// 
/// Widget que envuelve toda la aplicación para aplicar configuraciones globales
/// como overlays, shortcuts de teclado, y configuraciones de accesibilidad.
class _AppBuilder extends StatelessWidget {
  final Widget? child;
  
  const _AppBuilder({this.child});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      // **CONFIGURACIÓN DE DENSIDAD DE TEXTO** 📝
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(
          MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
        ),
      ),
      child: _OverlayWrapper(
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}

/// **WRAPPER DE OVERLAYS** 🎭
/// 
/// Maneja overlays globales como snackbars, dialogs, y tooltips.
class _OverlayWrapper extends StatelessWidget {
  final Widget child;
  
  const _OverlayWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) => _GlobalShortcuts(child: child),
        ),
      ],
    );
  }
}

/// **SHORTCUTS GLOBALES** ⌨️
/// 
/// Define shortcuts de teclado globales para la aplicación.
class _GlobalShortcuts extends StatelessWidget {
  final Widget child;
  
  const _GlobalShortcuts({required this.child});

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        // **SHORTCUTS DE NAVEGACIÓN** 🧭
        LogicalKeySet(LogicalKeyboardKey.escape): const _BackIntent(),
        LogicalKeySet(LogicalKeyboardKey.f5): const _RefreshIntent(),
        
        // **SHORTCUTS DE TEMA** 🎨
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
          LogicalKeyboardKey.keyT,
        ): const _ToggleThemeIntent(),
        
        // **SHORTCUTS DE BÚSQUEDA** 🔍
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyF,
        ): const _SearchIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _BackIntent: _BackAction(),
          _RefreshIntent: _RefreshAction(),
          _ToggleThemeIntent: _ToggleThemeAction(),
          _SearchIntent: _SearchAction(),
        },
        child: child,
      ),
    );
  }
}

// **INTENTS PARA SHORTCUTS** 🎯
class _BackIntent extends Intent {
  const _BackIntent();
}

class _RefreshIntent extends Intent {
  const _RefreshIntent();
}

class _ToggleThemeIntent extends Intent {
  const _ToggleThemeIntent();
}

class _SearchIntent extends Intent {
  const _SearchIntent();
}

// **ACCIONES PARA SHORTCUTS** ⚡
class _BackAction extends Action<_BackIntent> {
  @override
  Object? invoke(_BackIntent intent) {
    // Implementar navegación hacia atrás
    return null;
  }
}

class _RefreshAction extends Action<_RefreshIntent> {
  @override
  Object? invoke(_RefreshIntent intent) {
    // Implementar refresh de la pantalla actual
    return null;
  }
}

class _ToggleThemeAction extends Action<_ToggleThemeIntent> {
  @override
  Object? invoke(_ToggleThemeIntent intent) {
    // Implementar toggle del tema
    return null;
  }
}

class _SearchAction extends Action<_SearchIntent> {
  @override
  Object? invoke(_SearchIntent intent) {
    // Implementar activación de búsqueda
    return null;
  }
}