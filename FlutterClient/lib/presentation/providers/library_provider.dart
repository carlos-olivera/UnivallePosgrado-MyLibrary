import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// **PROVIDER DE LIBRERÍA EDUCATIVO** 📖
/// 
/// Este provider demuestra:
/// - Gestión de librería personal del usuario
/// - Estados de lectura y progreso
/// - Sincronización con Firestore
/// - Operaciones CRUD de la colección
/// - Estadísticas personalizadas
/// 
/// Conceptos educativos demostrados:
/// - Provider pattern para datos del usuario
/// - Firestore integration
/// - State management for user data
/// - Progress tracking patterns

class LibraryProvider with ChangeNotifier {
  // **ESTADO INTERNO** 📊
  List<Map<String, dynamic>> _libraryBooks = [];
  Map<String, dynamic>? _stats;
  bool _isLoading = false;
  String? _error;
  User? _currentUser;
  
  // **GETTERS PÚBLICOS** 📖
  List<Map<String, dynamic>> get libraryBooks => List.unmodifiable(_libraryBooks);
  Map<String, dynamic>? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasBooks => _libraryBooks.isNotEmpty;
  int get totalBooks => _libraryBooks.length;
  
  /// **ACTUALIZAR USUARIO** 👤
  void updateUser(User? user) {
    if (_currentUser?.uid != user?.uid) {
      _currentUser = user;
      if (user != null) {
        loadLibrary();
      } else {
        _clearLibrary();
      }
    }
  }
  
  /// **CARGAR LIBRERÍA** 📥
  Future<void> loadLibrary() async {
    if (_currentUser == null) return;
    
    try {
      _setLoading(true);
      _clearError();
      
      debugPrint('📥 LibraryProvider: Cargando librería para ${_currentUser!.email}');
      
      // TODO: Implementar carga desde Firestore
      // final firestoreService = FirestoreService();
      // final result = await firestoreService.getUserLibrary(_currentUser!.uid);
      
      // Simulación de datos
      await Future.delayed(const Duration(seconds: 1));
      
      _libraryBooks = [
        {
          'id': '1',
          'bookId': '1',
          'title': 'El Quijote',
          'author': 'Miguel de Cervantes',
          'imageUrl': 'https://example.com/quijote.jpg',
          'status': 'reading',
          'progress': 45,
          'rating': 4,
          'dateAdded': DateTime.now().subtract(const Duration(days: 10)),
          'dateUpdated': DateTime.now().subtract(const Duration(days: 2)),
          'notes': 'Una obra maestra que requiere paciencia...',
        },
        {
          'id': '2',
          'bookId': '2',
          'title': 'Cien años de soledad',
          'author': 'Gabriel García Márquez',
          'imageUrl': 'https://example.com/cien-anos.jpg',
          'status': 'completed',
          'progress': 100,
          'rating': 5,
          'dateAdded': DateTime.now().subtract(const Duration(days: 30)),
          'dateUpdated': DateTime.now().subtract(const Duration(days: 5)),
          'notes': 'Increíble narrativa del realismo mágico.',
        },
      ];
      
      await _calculateStats();
      
      debugPrint('✅ Librería cargada: ${_libraryBooks.length} libros');
      
    } catch (error) {
      debugPrint('❌ Error cargando librería: $error');
      _setError('Error cargando tu librería');
    } finally {
      _setLoading(false);
    }
  }
  
  /// **AGREGAR LIBRO A LIBRERÍA** ➕
  Future<bool> addBookToLibrary(Map<String, dynamic> book) async {
    if (_currentUser == null) return false;
    
    try {
      debugPrint('➕ LibraryProvider: Agregando libro: ${book['title']}');
      
      // Verificar si ya existe
      if (isBookInLibrary(book['id'] ?? book['bookId'])) {
        _setError('El libro ya está en tu librería');
        return false;
      }
      
      final libraryBook = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'bookId': book['id'] ?? book['bookId'],
        'title': book['title'],
        'author': book['author'],
        'imageUrl': book['imageUrl'],
        'status': 'want-to-read',
        'progress': 0,
        'rating': 0,
        'dateAdded': DateTime.now(),
        'dateUpdated': DateTime.now(),
        'notes': '',
      };
      
      // TODO: Guardar en Firestore
      // final firestoreService = FirestoreService();
      // await firestoreService.addBookToLibrary(_currentUser!.uid, libraryBook);
      
      _libraryBooks.add(libraryBook);
      await _calculateStats();
      
      debugPrint('✅ Libro agregado exitosamente');
      notifyListeners();
      return true;
      
    } catch (error) {
      debugPrint('❌ Error agregando libro: $error');
      _setError('Error agregando libro a la librería');
      return false;
    }
  }
  
  /// **ACTUALIZAR ESTADO DE LIBRO** ✏️
  Future<bool> updateBookStatus(
    String bookId,
    String status, {
    int? progress,
    int? rating,
    String? notes,
  }) async {
    if (_currentUser == null) return false;
    
    try {
      debugPrint('✏️ LibraryProvider: Actualizando libro $bookId a estado: $status');
      
      final bookIndex = _libraryBooks.indexWhere(
        (book) => book['bookId'] == bookId,
      );
      
      if (bookIndex == -1) {
        _setError('Libro no encontrado en la librería');
        return false;
      }
      
      final updatedBook = Map<String, dynamic>.from(_libraryBooks[bookIndex]);
      updatedBook['status'] = status;
      updatedBook['dateUpdated'] = DateTime.now();
      
      if (progress != null) updatedBook['progress'] = progress;
      if (rating != null) updatedBook['rating'] = rating;
      if (notes != null) updatedBook['notes'] = notes;
      
      // Ajustar progreso automáticamente según estado
      if (status == 'completed' && progress == null) {
        updatedBook['progress'] = 100;
      } else if (status == 'want-to-read' && progress == null) {
        updatedBook['progress'] = 0;
      }
      
      // TODO: Actualizar en Firestore
      // final firestoreService = FirestoreService();
      // await firestoreService.updateBookInLibrary(_currentUser!.uid, bookId, updatedBook);
      
      _libraryBooks[bookIndex] = updatedBook;
      await _calculateStats();
      
      debugPrint('✅ Libro actualizado exitosamente');
      notifyListeners();
      return true;
      
    } catch (error) {
      debugPrint('❌ Error actualizando libro: $error');
      _setError('Error actualizando libro');
      return false;
    }
  }
  
  /// **ELIMINAR LIBRO DE LIBRERÍA** ❌
  Future<bool> removeBookFromLibrary(String bookId) async {
    if (_currentUser == null) return false;
    
    try {
      debugPrint('❌ LibraryProvider: Eliminando libro: $bookId');
      
      final bookIndex = _libraryBooks.indexWhere(
        (book) => book['bookId'] == bookId,
      );
      
      if (bookIndex == -1) {
        _setError('Libro no encontrado en la librería');
        return false;
      }
      
      // TODO: Eliminar de Firestore
      // final firestoreService = FirestoreService();
      // await firestoreService.removeBookFromLibrary(_currentUser!.uid, bookId);
      
      _libraryBooks.removeAt(bookIndex);
      await _calculateStats();
      
      debugPrint('✅ Libro eliminado exitosamente');
      notifyListeners();
      return true;
      
    } catch (error) {
      debugPrint('❌ Error eliminando libro: $error');
      _setError('Error eliminando libro');
      return false;
    }
  }
  
  /// **VERIFICAR SI LIBRO ESTÁ EN LIBRERÍA** ❓
  bool isBookInLibrary(String bookId) {
    return _libraryBooks.any((book) => book['bookId'] == bookId);
  }
  
  /// **OBTENER LIBRO DE LIBRERÍA** 📖
  Map<String, dynamic>? getLibraryBook(String bookId) {
    try {
      return _libraryBooks.firstWhere(
        (book) => book['bookId'] == bookId,
      );
    } catch (e) {
      return null;
    }
  }
  
  /// **FILTRAR LIBROS POR ESTADO** 🔍
  List<Map<String, dynamic>> getBooksByStatus(String status) {
    return _libraryBooks
        .where((book) => book['status'] == status)
        .toList();
  }
  
  /// **OBTENER LIBROS LEYENDO ACTUALMENTE** 📚
  List<Map<String, dynamic>> getCurrentlyReading() {
    return getBooksByStatus('reading');
  }
  
  /// **OBTENER LIBROS COMPLETADOS** ✅
  List<Map<String, dynamic>> getCompletedBooks() {
    return getBooksByStatus('completed');
  }
  
  /// **OBTENER LIBROS POR LEER** 📋
  List<Map<String, dynamic>> getWantToRead() {
    return getBooksByStatus('want-to-read');
  }
  
  /// **OBTENER LIBROS FAVORITOS** ⭐
  List<Map<String, dynamic>> getFavoriteBooks() {
    return _libraryBooks
        .where((book) => (book['rating'] as int? ?? 0) >= 4)
        .toList();
  }
  
  /// **CALCULAR ESTADÍSTICAS** 📊
  Future<void> _calculateStats() async {
    try {
      final total = _libraryBooks.length;
      final reading = getBooksByStatus('reading').length;
      final completed = getBooksByStatus('completed').length;
      final wantToRead = getBooksByStatus('want-to-read').length;
      
      // Calcular progreso promedio
      double averageProgress = 0;
      if (_libraryBooks.isNotEmpty) {
        final totalProgress = _libraryBooks.fold<int>(
          0,
          (sum, book) => sum + (book['progress'] as int? ?? 0),
        );
        averageProgress = totalProgress / _libraryBooks.length;
      }
      
      // Calcular rating promedio
      double averageRating = 0;
      final ratedBooks = _libraryBooks.where(
        (book) => (book['rating'] as int? ?? 0) > 0,
      ).toList();
      
      if (ratedBooks.isNotEmpty) {
        final totalRating = ratedBooks.fold<int>(
          0,
          (sum, book) => sum + (book['rating'] as int? ?? 0),
        );
        averageRating = totalRating / ratedBooks.length;
      }
      
      _stats = {
        'totalBooks': total,
        'reading': reading,
        'completed': completed,
        'wantToRead': wantToRead,
        'averageProgress': averageProgress,
        'averageRating': averageRating,
        'lastUpdated': DateTime.now(),
      };
      
      debugPrint('📊 Estadísticas calculadas: $_stats');
      
    } catch (error) {
      debugPrint('❌ Error calculando estadísticas: $error');
    }
  }
  
  /// **RECARGAR LIBRERÍA** 🔄
  Future<void> refresh() async {
    await loadLibrary();
  }
  
  /// **LIMPIAR LIBRERÍA** 🧹
  void _clearLibrary() {
    _libraryBooks.clear();
    _stats = null;
    _clearError();
    notifyListeners();
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
}

/// **ESTADOS DE LECTURA** 📚
/// 
/// Enum para los diferentes estados de lectura de un libro.
enum ReadingStatus {
  wantToRead('want-to-read', 'Quiero leer', '📋'),
  reading('reading', 'Leyendo', '📖'),
  completed('completed', 'Completado', '✅'),
  onHold('on-hold', 'En pausa', '⏸️'),
  abandoned('abandoned', 'Abandonado', '❌');
  
  const ReadingStatus(this.value, this.label, this.emoji);
  
  final String value;
  final String label;
  final String emoji;
  
  static ReadingStatus fromString(String value) {
    return ReadingStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ReadingStatus.wantToRead,
    );
  }
}