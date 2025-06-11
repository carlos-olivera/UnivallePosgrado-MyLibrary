import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// **CONFIGURACIÓN DE TEMAS EDUCATIVA** 🎨
/// 
/// Este archivo demuestra:
/// - Implementación de Material Design 3
/// - Temas personalizados claro y oscuro
/// - Sistema de colores coherente
/// - Tipografía y espaciado consistente
/// - Componentes temáticos personalizados
/// 
/// Conceptos educativos demostrados:
/// - Theme data configuration
/// - Color scheme generation
/// - Typography systems
/// - Component theming
/// - Responsive design tokens

class AppTheme {
  // **COLORES PRIMARIOS** 🎨
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color tertiaryColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFB00020);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color successColor = Color(0xFF4CAF50);
  
  // **COLORES DE SUPERFICIE** 🏔️
  static const Color lightSurface = Color(0xFFFFFBFE);
  static const Color darkSurface = Color(0xFF1C1B1F);
  
  // **TIPOGRAFÍA** ✍️
  static const String fontFamily = 'Roboto';
  
  /// **TEMA CLARO** ☀️
  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    );
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      
      // **CONFIGURACIÓN DE APP BAR** 📱
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          fontFamily: fontFamily,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      
      // **CONFIGURACIÓN DE NAVEGACIÓN** 🧭
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return TextStyle(
              color: colorScheme.onSurface,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          );
        }),
      ),
      
      // **CONFIGURACIÓN DE BOTONES** 🔘
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: fontFamily,
          ),
        ),
      ),
      
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: fontFamily,
          ),
        ),
      ),
      
      // **CONFIGURACIÓN DE CARDS** 🃏
      cardTheme: CardTheme(
        elevation: 2,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      
      // **CONFIGURACIÓN DE INPUTS** 📝
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      
      // **CONFIGURACIÓN DE CHIPS** 🏷️
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceVariant,
        selectedColor: colorScheme.secondaryContainer,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      // **CONFIGURACIÓN DE DIVIDERS** ➖
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      
      // **CONFIGURACIÓN DE BOTTOM SHEET** 📊
      bottomSheetTheme: const BottomSheetThemeData(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      
      // **CONFIGURACIÓN DE DIALOGS** 💬
      dialogTheme: DialogTheme(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          fontFamily: fontFamily,
        ),
        contentTextStyle: TextStyle(
          fontSize: 16,
          color: colorScheme.onSurfaceVariant,
          fontFamily: fontFamily,
        ),
      ),
    );
  }
  
  /// **TEMA OSCURO** 🌙
  static ThemeData get darkTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    );
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      
      // **CONFIGURACIÓN DE APP BAR** 📱
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          fontFamily: fontFamily,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      
      // **CONFIGURACIÓN DE NAVEGACIÓN** 🧭
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return TextStyle(
              color: colorScheme.onSurface,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          );
        }),
      ),
      
      // **CONFIGURACIÓN DE BOTONES** 🔘
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: fontFamily,
          ),
        ),
      ),
      
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: fontFamily,
          ),
        ),
      ),
      
      // **CONFIGURACIÓN DE CARDS** 🃏
      cardTheme: CardTheme(
        elevation: 2,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      
      // **CONFIGURACIÓN DE INPUTS** 📝
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}

/// **EXTENSIONES DE TEMA** 🔧
/// 
/// Extensiones útiles para acceder a propiedades del tema de manera más fácil.
extension ThemeExtensions on BuildContext {
  /// **ACCESO RÁPIDO AL THEME** 🎨
  ThemeData get theme => Theme.of(this);
  
  /// **ACCESO RÁPIDO AL COLOR SCHEME** 🌈
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  /// **ACCESO RÁPIDO A TEXT THEME** ✍️
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  /// **VERIFICAR SI ES TEMA OSCURO** 🌙
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

/// **TOKENS DE DISEÑO** 🎯
/// 
/// Constantes para espaciado, tamaños y otros tokens de diseño.
class DesignTokens {
  // **ESPACIADO** 📏
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double space2XL = 48.0;
  static const double space3XL = 64.0;
  
  // **BORDER RADIUS** 🔄
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusFull = 9999.0;
  
  // **ELEVACIÓN** 🏔️
  static const double elevationSM = 2.0;
  static const double elevationMD = 4.0;
  static const double elevationLG = 8.0;
  static const double elevationXL = 16.0;
  
  // **ICONOS** 🎭
  static const double iconSM = 16.0;
  static const double iconMD = 24.0;
  static const double iconLG = 32.0;
  static const double iconXL = 48.0;
}

/// **DIMENSIONES RESPONSIVE** 📱
/// 
/// Utilidades para diseño responsive basado en el tamaño de pantalla.
class ResponsiveDimensions {
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }
  
  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }
  
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }
  
  static double getResponsivePadding(BuildContext context) {
    if (isSmallScreen(context)) return DesignTokens.spaceMD;
    if (isMediumScreen(context)) return DesignTokens.spaceLG;
    return DesignTokens.spaceXL;
  }
}