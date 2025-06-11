import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// **SHELL PRINCIPAL EDUCATIVO** 🏠
/// 
/// Este widget demuestra:
/// - Navegación principal con BottomNavigationBar
/// - Shell routes para mantener estado
/// - Gestión de índices de navegación
/// - Transiciones suaves entre pantallas
/// 
/// Conceptos educativos demostrados:
/// - Shell navigation patterns
/// - State preservation
/// - Bottom navigation implementation
/// - Route-based navigation

class MainShell extends StatefulWidget {
  final Widget child;
  
  const MainShell({
    super.key,
    required this.child,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  
  // **NAVEGACIÓN PRINCIPAL** 🧭
  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      route: '/home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Inicio',
    ),
    NavigationItem(
      route: '/explore',
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      label: 'Explorar',
    ),
    NavigationItem(
      route: '/library',
      icon: Icons.library_books_outlined,
      activeIcon: Icons.library_books,
      label: 'Mi Librería',
    ),
    NavigationItem(
      route: '/profile',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Perfil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
  
  /// **CONSTRUIR BARRA DE NAVEGACIÓN** 📱
  Widget _buildBottomNavigationBar() {
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: _onDestinationSelected,
      destinations: _navigationItems.map((item) {
        final isSelected = _currentIndex == _navigationItems.indexOf(item);
        
        return NavigationDestination(
          icon: Icon(item.icon),
          selectedIcon: Icon(item.activeIcon),
          label: item.label,
        );
      }).toList(),
    );
  }
  
  /// **MANEJAR SELECCIÓN DE DESTINO** 🎯
  void _onDestinationSelected(int index) {
    if (index == _currentIndex) return;
    
    setState(() {
      _currentIndex = index;
    });
    
    final route = _navigationItems[index].route;
    context.go(route);
  }
  
  /// **ACTUALIZAR ÍNDICE SEGÚN RUTA** 🔄
  void _updateCurrentIndex(String location) {
    final index = _navigationItems.indexWhere(
      (item) => location.startsWith(item.route),
    );
    
    if (index != -1 && index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Actualizar índice basado en la ruta actual
    final location = GoRouterState.of(context).fullPath ?? '/home';
    _updateCurrentIndex(location);
  }
}

/// **ITEM DE NAVEGACIÓN** 🧭
/// 
/// Clase para definir elementos de navegación.
class NavigationItem {
  final String route;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  
  const NavigationItem({
    required this.route,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}