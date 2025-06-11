import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// **PROVIDER DE AUTENTICACIÓN EDUCATIVO** 🔐
/// 
/// Este provider demuestra:
/// - Gestión de estado de autenticación con Firebase
/// - Patrón Observer con ChangeNotifier
/// - Manejo de ciclo de vida del usuario
/// - Estados de carga y error
/// - Operaciones CRUD de autenticación
/// 
/// Conceptos educativos demostrados:
/// - Provider pattern para gestión de estado
/// - Firebase Auth integration
/// - Error handling
/// - State management best practices

class AuthProvider with ChangeNotifier {
  // **INSTANCIA DE FIREBASE AUTH** 🔥
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  // **ESTADO INTERNO** 📊
  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;
  
  // **GETTERS PÚBLICOS** 📖
  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isInitialized => _isInitialized;
  
  /// **INICIALIZAR PROVIDER** ⚡
  /// 
  /// Configura el listener de cambios de autenticación y estado inicial.
  Future<void> initialize() async {
    try {
      debugPrint('🔐 AuthProvider: Inicializando...');
      
      // Configurar listener de cambios de autenticación
      _firebaseAuth.authStateChanges().listen(
        _onAuthStateChanged,
        onError: _onAuthError,
      );
      
      // Obtener usuario actual si existe
      _user = _firebaseAuth.currentUser;
      _isInitialized = true;
      
      debugPrint('🔐 AuthProvider: Inicializado correctamente');
      debugPrint('👤 Usuario actual: ${_user?.email ?? 'No autenticado'}');
      
      notifyListeners();
    } catch (error) {
      debugPrint('❌ Error inicializando AuthProvider: $error');
      _error = 'Error de inicialización: $error';
      _isInitialized = true;
      notifyListeners();
    }
  }
  
  /// **MANEJAR CAMBIOS DE ESTADO DE AUTH** 🔄
  void _onAuthStateChanged(User? user) {
    debugPrint('🔄 Cambio de estado de autenticación: ${user?.email ?? 'null'}');
    
    _user = user;
    _error = null;
    
    notifyListeners();
  }
  
  /// **MANEJAR ERRORES DE AUTH** ❌
  void _onAuthError(Object error) {
    debugPrint('❌ Error en auth state listener: $error');
    _error = error.toString();
    notifyListeners();
  }
  
  /// **INICIAR SESIÓN** 🔑
  Future<AuthResult> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      _setLoading(true);
      _clearError();
      
      debugPrint('🔑 Intentando iniciar sesión: $email');
      
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      debugPrint('✅ Sesión iniciada exitosamente: ${credential.user?.email}');
      
      return AuthResult.success(
        user: credential.user,
        message: 'Sesión iniciada exitosamente',
      );
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e.code);
      debugPrint('❌ Error en inicio de sesión: ${e.code} - $errorMessage');
      
      _setError(errorMessage);
      return AuthResult.error(errorMessage);
    } catch (e) {
      const errorMessage = 'Error inesperado durante el inicio de sesión';
      debugPrint('❌ Error inesperado: $e');
      
      _setError(errorMessage);
      return AuthResult.error(errorMessage);
    } finally {
      _setLoading(false);
    }
  }
  
  /// **REGISTRAR USUARIO** 📝
  Future<AuthResult> createUserWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      _setLoading(true);
      _clearError();
      
      debugPrint('📝 Creando usuario: $email');
      
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      // Actualizar perfil con nombre
      if (displayName.isNotEmpty) {
        await credential.user?.updateDisplayName(displayName.trim());
        await credential.user?.reload();
        _user = _firebaseAuth.currentUser;
      }
      
      debugPrint('✅ Usuario creado exitosamente: ${credential.user?.email}');
      
      return AuthResult.success(
        user: credential.user,
        message: 'Cuenta creada exitosamente',
      );
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e.code);
      debugPrint('❌ Error en registro: ${e.code} - $errorMessage');
      
      _setError(errorMessage);
      return AuthResult.error(errorMessage);
    } catch (e) {
      const errorMessage = 'Error inesperado durante el registro';
      debugPrint('❌ Error inesperado: $e');
      
      _setError(errorMessage);
      return AuthResult.error(errorMessage);
    } finally {
      _setLoading(false);
    }
  }
  
  /// **CERRAR SESIÓN** 🚪
  Future<AuthResult> signOut() async {
    try {
      _setLoading(true);
      _clearError();
      
      debugPrint('🚪 Cerrando sesión...');
      
      await _firebaseAuth.signOut();
      
      debugPrint('✅ Sesión cerrada exitosamente');
      
      return AuthResult.success(
        message: 'Sesión cerrada exitosamente',
      );
    } catch (e) {
      const errorMessage = 'Error cerrando sesión';
      debugPrint('❌ Error cerrando sesión: $e');
      
      _setError(errorMessage);
      return AuthResult.error(errorMessage);
    } finally {
      _setLoading(false);
    }
  }
  
  /// **RECUPERAR CONTRASEÑA** 🔐
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      _setLoading(true);
      _clearError();
      
      debugPrint('📧 Enviando email de recuperación a: $email');
      
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      
      debugPrint('✅ Email de recuperación enviado');
      
      return AuthResult.success(
        message: 'Email de recuperación enviado exitosamente',
      );
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e.code);
      debugPrint('❌ Error enviando email: ${e.code} - $errorMessage');
      
      _setError(errorMessage);
      return AuthResult.error(errorMessage);
    } catch (e) {
      const errorMessage = 'Error enviando email de recuperación';
      debugPrint('❌ Error inesperado: $e');
      
      _setError(errorMessage);
      return AuthResult.error(errorMessage);
    } finally {
      _setLoading(false);
    }
  }
  
  /// **ACTUALIZAR PERFIL** 👤
  Future<AuthResult> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      
      if (_user == null) {
        return AuthResult.error('No hay usuario autenticado');
      }
      
      debugPrint('👤 Actualizando perfil del usuario: ${_user!.email}');
      
      if (displayName != null) {
        await _user!.updateDisplayName(displayName.trim());
      }
      
      if (photoURL != null) {
        await _user!.updatePhotoURL(photoURL);
      }
      
      await _user!.reload();
      _user = _firebaseAuth.currentUser;
      
      debugPrint('✅ Perfil actualizado exitosamente');
      
      notifyListeners();
      
      return AuthResult.success(
        user: _user,
        message: 'Perfil actualizado exitosamente',
      );
    } catch (e) {
      const errorMessage = 'Error actualizando perfil';
      debugPrint('❌ Error actualizando perfil: $e');
      
      _setError(errorMessage);
      return AuthResult.error(errorMessage);
    } finally {
      _setLoading(false);
    }
  }
  
  /// **MÉTODOS AUXILIARES** 🛠️
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
    notifyListeners();
  }
  
  /// **MAPEAR CÓDIGOS DE ERROR** 🗺️
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No existe una cuenta con este email';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'invalid-email':
        return 'Email inválido';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada';
      case 'too-many-requests':
        return 'Demasiados intentos fallidos. Intenta más tarde';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este email';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres';
      case 'invalid-credential':
        return 'Credenciales inválidas';
      case 'network-request-failed':
        return 'Error de conexión. Verifica tu internet';
      default:
        return 'Error de autenticación: $errorCode';
    }
  }
}

/// **RESULTADO DE OPERACIONES DE AUTH** 📋
/// 
/// Clase para encapsular resultados de operaciones de autenticación.
class AuthResult {
  final bool isSuccess;
  final String message;
  final User? user;
  final String? error;
  
  const AuthResult._({
    required this.isSuccess,
    required this.message,
    this.user,
    this.error,
  });
  
  /// **RESULTADO EXITOSO** ✅
  factory AuthResult.success({
    User? user,
    required String message,
  }) {
    return AuthResult._(
      isSuccess: true,
      message: message,
      user: user,
    );
  }
  
  /// **RESULTADO DE ERROR** ❌
  factory AuthResult.error(String error) {
    return AuthResult._(
      isSuccess: false,
      message: error,
      error: error,
    );
  }
}