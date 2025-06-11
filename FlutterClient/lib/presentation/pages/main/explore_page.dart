import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../providers/books_provider.dart';
import '../../providers/library_provider.dart';
import '../../widgets/book_card.dart';

/// **PÁGINA DE EXPLORACIÓN EDUCATIVA** 🔍
/// 
/// Esta página demuestra:
/// - Búsqueda y filtrado de libros
/// - Resultados en tiempo real
/// - Categorías y filtros avanzados
/// - Lista y grid layouts
/// - Estados vacíos y de carga
/// 
/// Conceptos educativos demostrados:
/// - Search and filter patterns
/// - Real-time data updates
/// - Multiple layout options
/// - Empty state handling

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final _searchController = TextEditingController();
  bool _isGridView = false;
  String _selectedCategory = 'all';
  
  @override
  void initState() {
    super.initState();
    _loadBooks();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  /// **CARGAR LIBROS** 📋
  Future<void> _loadBooks() async {
    final booksProvider = context.read<BooksProvider>();
    if (!booksProvider.hasBooks) {
      await booksProvider.fetchBooks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            _buildSearchSection(),
            _buildCategoriesSection(),
            _buildResultsSection(),
          ],
        ),
      ),
    );
  }
  
  /// **CONSTRUIR APP BAR** 📱
  Widget _buildAppBar() {
    return SliverAppBar(
      title: const Text('Explorar Libros'),
      floating: true,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      actions: [
        IconButton(
          icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
          onPressed: () {
            setState(() {
              _isGridView = !_isGridView;
            });
          },
          tooltip: _isGridView ? 'Vista de lista' : 'Vista de cuadrícula',
        ),
        const SizedBox(width: 8),
      ],
    );
  }
  
  /// **CONSTRUIR SECCIÓN DE BÚSQUEDA** 🔍
  Widget _buildSearchSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<BooksProvider>(
          builder: (context, booksProvider, child) {
            return TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar libros, autores...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          booksProvider.clearSearch();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (query) {
                booksProvider.searchBooks(query);
                setState(() {});
              },
            );
          },
        ),
      ),
    );
  }
  
  /// **CONSTRUIR SECCIÓN DE CATEGORÍAS** 🏷️
  Widget _buildCategoriesSection() {
    return Consumer<BooksProvider>(
      builder: (context, booksProvider, child) {
        final categories = booksProvider.getAvailableCategories();
        
        return SliverToBoxAdapter(
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == _selectedCategory;
                
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < categories.length - 1 ? 8 : 0,
                  ),
                  child: FilterChip(
                    label: Text(_getCategoryDisplayName(category)),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = category;
                      });
                      booksProvider.filterByCategory(category);
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
  
  /// **CONSTRUIR SECCIÓN DE RESULTADOS** 📋
  Widget _buildResultsSection() {
    return Consumer2<BooksProvider, LibraryProvider>(
      builder: (context, booksProvider, libraryProvider, child) {
        if (booksProvider.isLoading || booksProvider.isSearching) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (booksProvider.error != null) {
          return SliverFillRemaining(
            child: _buildErrorState(booksProvider.error!),
          );
        }
        
        // Determinar qué libros mostrar
        List<Map<String, dynamic>> booksToShow;
        
        if (_searchController.text.isNotEmpty || _selectedCategory != 'all') {
          booksToShow = booksProvider.searchResults;
        } else {
          booksToShow = booksProvider.books;
        }
        
        if (booksToShow.isEmpty) {
          return SliverFillRemaining(
            child: _buildEmptyState(),
          );
        }
        
        return _isGridView
            ? _buildGridView(booksToShow, libraryProvider)
            : _buildListView(booksToShow, libraryProvider);
      },
    );
  }
  
  /// **CONSTRUIR VISTA DE CUADRÍCULA** 🌀
  Widget _buildGridView(List<Map<String, dynamic>> books, LibraryProvider libraryProvider) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final book = books[index];
            final isInLibrary = libraryProvider.isBookInLibrary(book['id']);
            
            return BookCard(
              book: book,
              onTap: () => context.push('/book-detail/${book['id']}'),
              showRating: true,
            );
          },
          childCount: books.length,
        ),
      ),
    );
  }
  
  /// **CONSTRUIR VISTA DE LISTA** 📋
  Widget _buildListView(List<Map<String, dynamic>> books, LibraryProvider libraryProvider) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final book = books[index];
            final isInLibrary = libraryProvider.isBookInLibrary(book['id']);
            
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < books.length - 1 ? 16 : 100,
              ),
              child: CompactBookCard(
                book: book,
                onTap: () => context.push('/book-detail/${book['id']}'),
                showRating: true,
              ),
            );
          },
          childCount: books.length,
        ),
      ),
    );
  }
  
  /// **CONSTRUIR ESTADO VACÍO** 📋
  Widget _buildEmptyState() {
    final hasQuery = _searchController.text.isNotEmpty;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasQuery ? Icons.search_off : Icons.auto_stories,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            hasQuery 
                ? 'No se encontraron libros'
                : 'No hay libros disponibles',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasQuery
                ? 'Intenta con otros términos de búsqueda'
                : 'Los libros aparecen aquí cuando estén disponibles',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          if (hasQuery) ...[
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                _searchController.clear();
                context.read<BooksProvider>().clearSearch();
                setState(() {});
              },
              child: const Text('Limpiar búsqueda'),
            ),
          ],
        ],
      ),
    );
  }
  
  /// **CONSTRUIR ESTADO DE ERROR** ⚠️
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Ups, algo salió mal',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _handleRefresh,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
  
  /// **OBTENER NOMBRE DE CATEGORÍA** 🏷️
  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'all':
        return 'Todos';
      case 'fiction':
        return 'Ficción';
      case 'non-fiction':
        return 'No ficción';
      case 'mystery':
        return 'Misterio';
      case 'romance':
        return 'Romance';
      case 'sci-fi':
        return 'Ciencia ficción';
      case 'fantasy':
        return 'Fantasía';
      case 'biography':
        return 'Biografía';
      case 'history':
        return 'Historia';
      case 'science':
        return 'Ciencia';
      default:
        return category.substring(0, 1).toUpperCase() + category.substring(1);
    }
  }
  
  /// **MANEJAR ACTUALIZACIÓN** 🔄
  Future<void> _handleRefresh() async {
    final booksProvider = context.read<BooksProvider>();
    await booksProvider.refresh();
  }
}