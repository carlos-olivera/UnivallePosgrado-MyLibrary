import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// **PROVIDER DE TEMA EDUCATIVO** 🎨
/// 
/// Este provider demuestra:
/// - Gestión de estado del tema de la aplicación
/// - Persistencia de preferencias del usuario
/// - Cambio dinámico entre tema claro y oscuro
/// - Integración con SharedPreferences
/// - Notificación reactiva de cambios
/// 
/// Conceptos educativos demostrados:
/// - Provider pattern para configuraciones globales
/// - Local storage con SharedPreferences
/// - Reactive state management
/// - Theme switching patterns

class ThemeProvider with ChangeNotifier {
  // **CONSTANTES** 📝
  static const String _themeModeKey = 'theme_mode';
  static const String _primaryColorKey = 'primary_color';
  static const String _useSystemThemeKey = 'use_system_theme';
  
  // **ESTADO INTERNO** 📊
  late SharedPreferences _prefs;
  ThemeMode _themeMode = ThemeMode.system;
  Color _primaryColor = const Color(0xFF1976D2);
  bool _useSystemTheme = true;
  bool _isInitialized = false;
  
  // **GETTERS PÚBLICOS** 📖
  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;
  bool get useSystemTheme => _useSystemTheme;
  bool get isInitialized => _isInitialized;
  
  /// **DETERMINAR SI ES TEMA OSCURO** 🌙
  bool get isDarkMode {
    switch (_themeMode) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness == 
               Brightness.dark;
    }
  }
  
  /// **INICIALIZAR PROVIDER** ⚡
  Future<void> initialize() async {
    try {
      debugPrint('🎨 ThemeProvider: Inicializando...');
      
      _prefs = await SharedPreferences.getInstance();
      await _loadThemePreferences();
      
      _isInitialized = true;
      debugPrint('🎨 ThemeProvider: Inicializado correctamente');
      debugPrint('🎨 Tema actual: $_themeMode');
      
      notifyListeners();
    } catch (error) {
      debugPrint('❌ Error inicializando ThemeProvider: $error');
      _isInitialized = true;
      notifyListeners();
    }
  }
  
  /// **CARGAR PREFERENCIAS DE TEMA** 📥
  Future<void> _loadThemePreferences() async {
    try {
      // Cargar modo de tema
      final themeModeIndex = _prefs.getInt(_themeModeKey) ?? ThemeMode.system.index;
      _themeMode = ThemeMode.values[themeModeIndex];
      
      // Cargar color primario
      final primaryColorValue = _prefs.getInt(_primaryColorKey) ?? 0xFF1976D2;
      _primaryColor = Color(primaryColorValue);
      
      // Cargar preferencia de tema del sistema
      _useSystemTheme = _prefs.getBool(_useSystemThemeKey) ?? true;
      
      debugPrint('📥 Preferencias de tema cargadas:');
      debugPrint('   - Modo: $_themeMode');
      debugPrint('   - Color primario: $_primaryColor');
      debugPrint('   - Usar tema del sistema: $_useSystemTheme');
    } catch (error) {
      debugPrint('❌ Error cargando preferencias de tema: $error');
    }
  }
  
  /// **CAMBIAR MODO DE TEMA** 🔄
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    try {
      debugPrint('🔄 Cambiando tema a: $mode');
      
      _themeMode = mode;
      _useSystemTheme = mode == ThemeMode.system;
      
      await _prefs.setInt(_themeModeKey, mode.index);
      await _prefs.setBool(_useSystemThemeKey, _useSystemTheme);
      
      debugPrint('✅ Tema cambiado exitosamente');
      notifyListeners();
    } catch (error) {
      debugPrint('❌ Error cambiando tema: $error');
    }
  }
  
  /// **ALTERNAR ENTRE CLARO Y OSCURO** 🌓
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    
    await setThemeMode(newMode);
  }
  
  /// **ESTABLECER TEMA DEL SISTEMA** 📱
  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }
  
  /// **ESTABLECER TEMA CLARO** ☀️
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }
  
  /// **ESTABLECER TEMA OSCURO** 🌙
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }
  
  /// **CAMBIAR COLOR PRIMARIO** 🎨
  Future<void> setPrimaryColor(Color color) async {
    if (_primaryColor == color) return;
    
    try {
      debugPrint('🎨 Cambiando color primario a: $color');
      
      _primaryColor = color;
      await _prefs.setInt(_primaryColorKey, color.value);
      
      debugPrint('✅ Color primario cambiado exitosamente');
      notifyListeners();
    } catch (error) {
      debugPrint('❌ Error cambiando color primario: $error');
    }
  }
  
  /// **RESTABLECER TEMA POR DEFECTO** 🔄
  Future<void> resetToDefault() async {
    try {
      debugPrint('🔄 Restableciendo tema por defecto...');
      
      _themeMode = ThemeMode.system;
      _primaryColor = const Color(0xFF1976D2);
      _useSystemTheme = true;
      
      await _prefs.setInt(_themeModeKey, ThemeMode.system.index);
      await _prefs.setInt(_primaryColorKey, 0xFF1976D2);
      await _prefs.setBool(_useSystemThemeKey, true);
      
      debugPrint('✅ Tema restablecido por defecto');
      notifyListeners();
    } catch (error) {
      debugPrint('❌ Error restableciendo tema: $error');
    }
  }
  
  /// **OBTENER DESCRIPCIÓN DEL TEMA ACTUAL** 📝
  String get currentThemeDescription {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Tema claro';
      case ThemeMode.dark:
        return 'Tema oscuro';
      case ThemeMode.system:
        return 'Seguir sistema';
    }
  }
  
  /// **OBTENER ÍCONO DEL TEMA ACTUAL** 🎭
  IconData get currentThemeIcon {
    switch (_themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.auto_mode;
    }
  }
}

/// **COLORES PREDEFINIDOS** 🌈
/// 
/// Colores predefinidos que el usuario puede seleccionar.
class ThemeColors {
  static const List<Color> predefinedColors = [
    Color(0xFF1976D2), // Azul Material
    Color(0xFF388E3C), // Verde
    Color(0xFFD32F2F), // Rojo
    Color(0xFFE64A19), // Naranja profundo
    Color(0xFF7B1FA2), // Púrpura
    Color(0xFF1976D2), // Índigo
    Color(0xFF00796B), // Verde azulado
    Color(0xFFAFB42B), // Lima
    Color(0xFFF57C00), // Naranja
    Color(0xFFC2185B), // Rosa
    Color(0xFF5D4037), // Marrón
    Color(0xFF455A64), // Azul gris
  ];
  
  /// **OBTENER NOMBRE DEL COLOR** 🏷️
  static String getColorName(Color color) {
    switch (color.value) {
      case 0xFF1976D2:
        return 'Azul';
      case 0xFF388E3C:
        return 'Verde';
      case 0xFFD32F2F:
        return 'Rojo';
      case 0xFFE64A19:
        return 'Naranja profundo';
      case 0xFF7B1FA2:
        return 'Púrpura';
      case 0xFF3F51B5:
        return 'Índigo';
      case 0xFF00796B:
        return 'Verde azulado';
      case 0xFFAFB42B:
        return 'Lima';
      case 0xFFF57C00:
        return 'Naranja';
      case 0xFFC2185B:
        return 'Rosa';
      case 0xFF5D4037:
        return 'Marrón';
      case 0xFF455A64:
        return 'Azul gris';
      default:
        return 'Personalizado';
    }
  }
}