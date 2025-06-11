import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/books_provider.dart';
import '../../providers/library_provider.dart';
import '../../widgets/book_card.dart';
import '../../widgets/stats_card.dart';

/// **PÁGINA DE INICIO EDUCATIVA** 🏠
/// 
/// Esta página demuestra:
/// - Dashboard principal de la aplicación
/// - Integración con múltiples providers
/// - Widgets reutilizables y modulares
/// - Estados de carga y datos
/// - Navegación contextual
/// 
/// Conceptos educativos demostrados:
/// - Multiple Provider consumption
/// - Dashboard design patterns
/// - Widget composition
/// - Data aggregation

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  /// **CARGAR DATOS INICIALES** 📋
  Future<void> _loadData() async {
    final booksProvider = context.read<BooksProvider>();
    final libraryProvider = context.read<LibraryProvider>();
    
    // Cargar datos en paralelo
    await Future.wait([
      booksProvider.fetchBooks(),
      libraryProvider.loadLibrary(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildWelcomeSection(),
                  const SizedBox(height: 24),
                  _buildStatsSection(),
                  const SizedBox(height: 24),
                  _buildCurrentlyReadingSection(),
                  const SizedBox(height: 24),
                  _buildPopularBooksSection(),
                  const SizedBox(height: 24),
                  _buildQuickActionsSection(),
                  const SizedBox(height: 100), // Extra space for bottom nav
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// **CONSTRUIR APP BAR** 📱
  Widget _buildAppBar() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        
        return SliverAppBar(
          expandedHeight: 120,
          floating: true,
          pinned: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'MyLibrary',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => context.push('/explore'),
              tooltip: 'Buscar libros',
            ),
            IconButton(
              icon: CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  user?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onPressed: () => context.push('/profile'),
              tooltip: 'Perfil',
            ),
            const SizedBox(width: 8),
          ],
        );
      },
    );
  }
  
  /// **CONSTRUIR SECCIÓN DE BIENVENIDA** 👋
  Widget _buildWelcomeSection() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        final firstName = user?.displayName?.split(' ').first ?? 'Usuario';
        
        return Card(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.secondaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Hola, $firstName! 👋',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '¿Qué vas a leer hoy?',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: () => context.push('/explore'),
                        child: const Text('Explorar Libros'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.tonal(
                      onPressed: () => context.push('/library'),
                      child: const Text('Mi Librería'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  /// **CONSTRUIR SECCIÓN DE ESTADÍSTICAS** 📊
  Widget _buildStatsSection() {
    return Consumer<LibraryProvider>(
      builder: (context, libraryProvider, child) {
        if (libraryProvider.isLoading) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        
        final stats = libraryProvider.stats;
        if (stats == null) {
          return const SizedBox.shrink();
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tus Estadísticas 📊',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'Total',
                    value: '${stats['totalBooks']}',
                    subtitle: 'libros',
                    icon: Icons.library_books,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatsCard(
                    title: 'Leyendo',
                    value: '${stats['reading']}',
                    subtitle: 'actualmente',
                    icon: Icons.menu_book,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'Completados',
                    value: '${stats['completed']}',
                    subtitle: 'libros',
                    icon: Icons.check_circle,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatsCard(
                    title: 'Rating',
                    value: stats['averageRating'] > 0 
                        ? '${stats['averageRating'].toStringAsFixed(1)}'
                        : '-',
                    subtitle: 'promedio',
                    icon: Icons.star,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  
  /// **CONSTRUIR SECCIÓN LEYENDO ACTUALMENTE** 📚
  Widget _buildCurrentlyReadingSection() {
    return Consumer<LibraryProvider>(
      builder: (context, libraryProvider, child) {
        final currentlyReading = libraryProvider.getCurrentlyReading();
        
        if (currentlyReading.isEmpty) {
          return const SizedBox.shrink();
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Leyendo Actualmente 📚',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/library'),
                  child: const Text('Ver todo'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: currentlyReading.length,
                itemBuilder: (context, index) {
                  final book = currentlyReading[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < currentlyReading.length - 1 ? 16 : 0,
                    ),
                    child: SizedBox(
                      width: 160,
                      child: BookCard(
                        book: book,
                        onTap: () => context.push('/book-detail/${book['bookId']}'),
                        showProgress: true,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
  
  /// **CONSTRUIR SECCIÓN LIBROS POPULARES** 🔥
  Widget _buildPopularBooksSection() {
    return Consumer<BooksProvider>(
      builder: (context, booksProvider, child) {
        if (booksProvider.isLoading) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        
        final popularBooks = booksProvider.getPopularBooks(limit: 5);
        
        if (popularBooks.isEmpty) {
          return const SizedBox.shrink();
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Libros Populares 🔥',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/explore'),
                  child: const Text('Ver todo'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: popularBooks.length,
                itemBuilder: (context, index) {
                  final book = popularBooks[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < popularBooks.length - 1 ? 16 : 0,
                    ),
                    child: SizedBox(
                      width: 160,
                      child: BookCard(
                        book: book,
                        onTap: () => context.push('/book-detail/${book['id']}'),
                        showRating: true,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
  
  /// **CONSTRUIR SECCIÓN ACCIONES RÁPIDAS** ⚡
  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Rápidas ⚡',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Card(
                child: InkWell(
                  onTap: () => context.push('/explore'),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search,
                          size: 32,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Buscar',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Encuentra nuevos libros',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                child: InkWell(
                  onTap: () => context.push('/library'),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.library_books,
                          size: 32,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mi Librería',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Gestiona tu colección',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  /// **MANEJAR ACTUALIZACIÓN** 🔄
  Future<void> _handleRefresh() async {
    await _loadData();
  }
}