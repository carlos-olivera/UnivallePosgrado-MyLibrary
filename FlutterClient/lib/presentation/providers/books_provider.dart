import 'package:flutter/foundation.dart';

/// **PROVIDER DE LIBROS EDUCATIVO** 📚
/// 
/// Este provider demuestra:
/// - Gestión de estado para catálogo de libros
/// - Integración con API externa de libros
/// - Caché local para optimización
/// - Estados de carga, error y datos
/// - Búsqueda y filtrado de libros
/// 
/// Conceptos educativos demostrados:
/// - Provider pattern para datos
/// - HTTP requests and caching
/// - Search and filtering logic
/// - Error handling patterns

class BooksProvider with ChangeNotifier {
  // **ESTADO INTERNO** 📊
  List<Map<String, dynamic>> _books = [];
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String? _error;
  String _currentQuery = '';
  String _selectedCategory = 'all';
  
  // **GETTERS PÚBLICOS** 📖
  List<Map<String, dynamic>> get books => List.unmodifiable(_books);
  List<Map<String, dynamic>> get searchResults => List.unmodifiable(_searchResults);
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get error => _error;
  String get currentQuery => _currentQuery;
  String get selectedCategory => _selectedCategory;
  bool get hasResults => _searchResults.isNotEmpty;
  bool get hasBooks => _books.isNotEmpty;
  
  /// **OBTENER CATÁLOGO DE LIBROS** 📚
  Future<void> fetchBooks() async {
    try {
      _setLoading(true);
      _clearError();
      
      debugPrint('📚 BooksProvider: Obteniendo catálogo de libros...');
      
      // TODO: Implementar llamada a la API de libros
      // final booksApiService = BooksApiService();
      // final result = await booksApiService.getAllBooks();
      
      // Simulación de datos de prueba
      await Future.delayed(const Duration(seconds: 1));
      
      _books = [
        {
          'id': '1',
          'title': 'El Quijote',
          'author': 'Miguel de Cervantes',
          'description': 'La obra maestra de la literatura española...',
          'imageUrl': 'https://example.com/quijote.jpg',
          'rating': 4.5,
          'year': 1605,
          'category': 'fiction',
        },
        {
          'id': '2',
          'title': 'Cien años de soledad',
          'author': 'Gabriel García Márquez',
          'description': 'Una novela del realismo mágico...',
          'imageUrl': 'https://example.com/cien-anos.jpg',
          'rating': 4.8,
          'year': 1967,
          'category': 'fiction',
        },
        // Más libros de ejemplo...
      ];
      
      debugPrint('✅ Catálogo obtenido: ${_books.length} libros');
      
    } catch (error) {
      debugPrint('❌ Error obteniendo catálogo: $error');
      _setError('Error obteniendo catálogo de libros');
    } finally {
      _setLoading(false);
    }
  }
  
  /// **BUSCAR LIBROS** 🔍
  Future<void> searchBooks(String query) async {
    if (query.trim().isEmpty) {
      _clearSearch();
      return;
    }
    
    try {
      _setSearching(true);
      _clearError();
      _currentQuery = query.trim();
      
      debugPrint('🔍 BooksProvider: Buscando libros: "$query"');
      
      // TODO: Implementar búsqueda con API
      // final booksApiService = BooksApiService();
      // final result = await booksApiService.searchBooks(query);
      
      // Simulación de búsqueda
      await Future.delayed(const Duration(milliseconds: 500));
      
      _searchResults = _books.where((book) {
        final title = book['title']?.toString().toLowerCase() ?? '';
        final author = book['author']?.toString().toLowerCase() ?? '';
        final searchTerm = query.toLowerCase();
        
        return title.contains(searchTerm) || author.contains(searchTerm);
      }).toList();
      
      debugPrint('✅ Búsqueda completada: ${_searchResults.length} resultados');
      
    } catch (error) {
      debugPrint('❌ Error en búsqueda: $error');
      _setError('Error buscando libros');
    } finally {
      _setSearching(false);
    }
  }
  
  /// **FILTRAR POR CATEGORÍA** 🏷️
  Future<void> filterByCategory(String category) async {
    try {
      debugPrint('🏷️ BooksProvider: Filtrando por categoría: $category');
      
      _selectedCategory = category;
      
      if (category == 'all') {
        _searchResults = List.from(_books);
      } else {
        _searchResults = _books.where((book) {
          return book['category']?.toString() == category;
        }).toList();
      }
      
      debugPrint('✅ Filtrado completado: ${_searchResults.length} resultados');
      notifyListeners();
      
    } catch (error) {
      debugPrint('❌ Error filtrando: $error');
      _setError('Error filtrando libros');
    }
  }
  
  /// **OBTENER DETALLES DE LIBRO** 📖
  Future<Map<String, dynamic>?> getBookDetails(String bookId) async {
    try {
      debugPrint('📖 BooksProvider: Obteniendo detalles del libro: $bookId');
      
      // Buscar en el caché local primero
      final book = _books.firstWhere(
        (book) => book['id'] == bookId,
        orElse: () => {},
      );
      
      if (book.isNotEmpty) {
        debugPrint('✅ Libro encontrado en caché');
        return book;
      }
      
      // TODO: Implementar llamada a API para detalles
      // final booksApiService = BooksApiService();
      // final result = await booksApiService.getBookDetails(bookId);
      
      debugPrint('❌ Libro no encontrado: $bookId');
      return null;
      
    } catch (error) {
      debugPrint('❌ Error obteniendo detalles: $error');
      _setError('Error obteniendo detalles del libro');
      return null;
    }
  }
  
  /// **OBTENER LIBROS POPULARES** 🔥
  List<Map<String, dynamic>> getPopularBooks({int limit = 5}) {
    final sortedBooks = List<Map<String, dynamic>>.from(_books);
    sortedBooks.sort((a, b) {
      final ratingA = a['rating'] as double? ?? 0.0;
      final ratingB = b['rating'] as double? ?? 0.0;
      return ratingB.compareTo(ratingA);
    });
    
    return sortedBooks.take(limit).toList();
  }
  
  /// **OBTENER LIBROS RECIENTES** 📅
  List<Map<String, dynamic>> getRecentBooks({int limit = 5}) {
    final sortedBooks = List<Map<String, dynamic>>.from(_books);
    sortedBooks.sort((a, b) {
      final yearA = a['year'] as int? ?? 0;
      final yearB = b['year'] as int? ?? 0;
      return yearB.compareTo(yearA);
    });
    
    return sortedBooks.take(limit).toList();
  }
  
  /// **OBTENER CATEGORÍAS DISPONIBLES** 🏷️
  List<String> getAvailableCategories() {
    final categories = <String>{'all'};
    
    for (final book in _books) {
      final category = book['category']?.toString();
      if (category != null && category.isNotEmpty) {
        categories.add(category);
      }
    }
    
    return categories.toList()..sort();
  }
  
  /// **LIMPIAR BÚSQUEDA** 🧹
  void clearSearch() {
    _clearSearch();
  }
  
  void _clearSearch() {
    _currentQuery = '';
    _searchResults.clear();
    _selectedCategory = 'all';
    notifyListeners();
  }
  
  /// **RECARGAR DATOS** 🔄
  Future<void> refresh() async {
    _clearSearch();
    await fetchBooks();
  }
  
  /// **MÉTODOS AUXILIARES** 🛠️
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setSearching(bool searching) {
    _isSearching = searching;
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

/// **RESULTADO DE BÚSQUEDA** 🔍
/// 
/// Clase para encapsular resultados de búsqueda con metadatos.
class SearchResult {
  final List<Map<String, dynamic>> books;
  final String query;
  final int totalResults;
  final bool fromCache;
  
  const SearchResult({
    required this.books,
    required this.query,
    required this.totalResults,
    this.fromCache = false,
  });
}

/// **FILTROS DE BÚSQUEDA** 🎛️
/// 
/// Clase para configurar filtros de búsqueda avanzada.
class SearchFilters {
  final String? category;
  final double? minRating;
  final int? minYear;
  final int? maxYear;
  final String? author;
  
  const SearchFilters({
    this.category,
    this.minRating,
    this.minYear,
    this.maxYear,
    this.author,
  });
  
  /// **APLICAR FILTROS A LISTA** 🎯
  List<Map<String, dynamic>> apply(List<Map<String, dynamic>> books) {
    return books.where((book) {
      // Filtro por categoría
      if (category != null && category != 'all') {
        if (book['category'] != category) return false;
      }
      
      // Filtro por rating mínimo
      if (minRating != null) {
        final rating = book['rating'] as double? ?? 0.0;
        if (rating < minRating!) return false;
      }
      
      // Filtro por año mínimo
      if (minYear != null) {
        final year = book['year'] as int? ?? 0;
        if (year < minYear!) return false;
      }
      
      // Filtro por año máximo
      if (maxYear != null) {
        final year = book['year'] as int? ?? 9999;
        if (year > maxYear!) return false;
      }
      
      // Filtro por autor
      if (author != null) {
        final bookAuthor = book['author']?.toString().toLowerCase() ?? '';
        if (!bookAuthor.contains(author!.toLowerCase())) return false;
      }
      
      return true;
    }).toList();
  }
}