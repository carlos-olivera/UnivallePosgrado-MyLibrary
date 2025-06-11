import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/auth/signup_page.dart';
import '../presentation/pages/auth/forgot_password_page.dart';
import '../presentation/pages/main/home_page.dart';
import '../presentation/pages/main/explore_page.dart';
import '../presentation/pages/main/library_page.dart';
import '../presentation/pages/main/profile_page.dart';
import '../presentation/pages/books/book_detail_page.dart';
import '../presentation/pages/books/review_page.dart';
import '../presentation/pages/main/main_shell.dart';
import '../presentation/providers/auth_provider.dart';

/// **CONFIGURACIÓN DE RUTAS EDUCATIVA** 🧭
/// 
/// Este archivo demuestra:
/// - Navegación declarativa con GoRouter
/// - Rutas protegidas por autenticación
/// - Shell routes para navegación principal
/// - Transiciones personalizadas
/// - Deep linking y parámetros
/// 
/// Conceptos educativos demostrados:
/// - Router configuration
/// - Route guards
/// - Nested navigation
/// - Parameter passing
/// - Custom transitions

class AppRoutes {
  /// **ROUTER PRINCIPAL** 🎯
  static final GoRouter router = GoRouter(
    initialLocation: '/auth/login',
    debugLogDiagnostics: true,
    
    // **GUARD DE AUTENTICACIÓN** 🔐
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isAuthenticated = authProvider.isAuthenticated;
      final isAuthRoute = state.fullPath?.startsWith('/auth') ?? false;
      
      // Si no está autenticado y no está en ruta de auth, redirigir a login
      if (!isAuthenticated && !isAuthRoute) {
        return '/auth/login';
      }
      
      // Si está autenticado y está en ruta de auth, redirigir a home
      if (isAuthenticated && isAuthRoute) {
        return '/home';
      }
      
      return null; // No redirigir
    },
    
    routes: [
      // **RUTAS DE AUTENTICACIÓN** 🔐
      GoRoute(
        path: '/auth',
        redirect: (context, state) => '/auth/login',
      ),
      
      GoRoute(
        path: '/auth/login',
        name: 'login',
        pageBuilder: (context, state) => _buildPageWithTransition(
          const LoginPage(),
          state,
          TransitionType.slideUp,
        ),
      ),
      
      GoRoute(
        path: '/auth/signup',
        name: 'signup',
        pageBuilder: (context, state) => _buildPageWithTransition(
          const SignupPage(),
          state,
          TransitionType.slideLeft,
        ),
      ),
      
      GoRoute(
        path: '/auth/forgot-password',
        name: 'forgotPassword',
        pageBuilder: (context, state) => _buildPageWithTransition(
          const ForgotPasswordPage(),
          state,
          TransitionType.slideLeft,
        ),
      ),
      
      // **SHELL ROUTE PARA NAVEGACIÓN PRINCIPAL** 🏠
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // **PANTALLA HOME** 🏠
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) => _buildPageWithTransition(
              const HomePage(),
              state,
              TransitionType.fade,
            ),
          ),
          
          // **PANTALLA EXPLORAR** 🔍
          GoRoute(
            path: '/explore',
            name: 'explore',
            pageBuilder: (context, state) => _buildPageWithTransition(
              const ExplorePage(),
              state,
              TransitionType.fade,
            ),
          ),
          
          // **PANTALLA LIBRERÍA** 📚
          GoRoute(
            path: '/library',
            name: 'library',
            pageBuilder: (context, state) => _buildPageWithTransition(
              const LibraryPage(),
              state,
              TransitionType.fade,
            ),
          ),
          
          // **PANTALLA PERFIL** 👤
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => _buildPageWithTransition(
              const ProfilePage(),
              state,
              TransitionType.fade,
            ),
          ),
        ],
      ),
      
      // **RUTAS MODALES/SECUNDARIAS** 📄
      GoRoute(
        path: '/book/:bookId',
        name: 'bookDetail',
        pageBuilder: (context, state) {
          final bookId = state.pathParameters['bookId']!;
          final book = state.extra as Map<String, dynamic>?;
          
          return _buildPageWithTransition(
            BookDetailPage(
              bookId: bookId,
              book: book,
            ),
            state,
            TransitionType.slideUp,
          );
        },
      ),
      
      GoRoute(
        path: '/book/:bookId/review',
        name: 'review',
        pageBuilder: (context, state) {
          final bookId = state.pathParameters['bookId']!;
          final book = state.extra as Map<String, dynamic>?;
          final existingReview = state.uri.queryParameters['reviewId'];
          
          return _buildPageWithTransition(
            ReviewPage(
              bookId: bookId,
              book: book,
              existingReviewId: existingReview,
            ),
            state,
            TransitionType.slideUp,
          );
        },
      ),
      
      // **RUTA DE ERROR** ❌
      GoRoute(
        path: '/error',
        name: 'error',
        pageBuilder: (context, state) => _buildPageWithTransition(
          ErrorPage(error: state.extra as String?),
          state,
          TransitionType.fade,
        ),
      ),
    ],
    
    // **MANEJO DE ERRORES** ❌
    errorBuilder: (context, state) => ErrorPage(
      error: 'Página no encontrada: ${state.fullPath}',
    ),
  );
  
  /// **TIPOS DE TRANSICIÓN** 🎭
  enum TransitionType {
    fade,
    slideUp,
    slideDown,
    slideLeft,
    slideRight,
    scale,
  }
  
  /// **CONSTRUCTOR DE PÁGINAS CON TRANSICIONES** 🎬
  static Page<dynamic> _buildPageWithTransition(
    Widget child,
    GoRouterState state, [
    TransitionType transition = TransitionType.fade,
  ]) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _buildTransition(
          animation,
          secondaryAnimation,
          child,
          transition,
        );
      },
    );
  }
  
  /// **CONSTRUCTOR DE TRANSICIONES** ✨
  static Widget _buildTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    TransitionType transition,
  ) {
    switch (transition) {
      case TransitionType.fade:
        return FadeTransition(
          opacity: animation,
          child: child,
        );
        
      case TransitionType.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
        
      case TransitionType.slideDown:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
        
      case TransitionType.slideLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
        
      case TransitionType.slideRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
        
      case TransitionType.scale:
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: child,
        );
    }
  }
}

/// **PÁGINA DE ERROR** ❌
/// 
/// Página mostrada cuando ocurre un error de navegación.
class ErrorPage extends StatelessWidget {
  final String? error;
  
  const ErrorPage({
    super.key,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              
              const SizedBox(height: 24),
              
              Text(
                'Oops! Algo salió mal',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              if (error != null)
                Text(
                  error!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              
              const SizedBox(height: 32),
              
              FilledButton(
                onPressed: () => context.go('/home'),
                child: const Text('Ir al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// **EXTENSIONES DE NAVEGACIÓN** 🧭
/// 
/// Extensiones útiles para navegación.
extension NavigationExtensions on BuildContext {
  /// **NAVEGAR A DETALLE DE LIBRO** 📖
  void goToBookDetail(String bookId, [Map<String, dynamic>? book]) {
    go('/book/$bookId', extra: book);
  }
  
  /// **NAVEGAR A RESEÑA** ⭐
  void goToReview(String bookId, [Map<String, dynamic>? book, String? reviewId]) {
    final uri = Uri(
      path: '/book/$bookId/review',
      queryParameters: reviewId != null ? {'reviewId': reviewId} : null,
    );
    go(uri.toString(), extra: book);
  }
  
  /// **NAVEGAR A AUTENTICACIÓN** 🔐
  void goToAuth() {
    go('/auth/login');
  }
  
  /// **NAVEGAR A HOME** 🏠
  void goToHome() {
    go('/home');
  }
}