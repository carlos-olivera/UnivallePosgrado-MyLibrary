import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';

/// **PÁGINA DE LOGIN EDUCATIVA** 🔐
/// 
/// Esta página demuestra:
/// - Formulario de autenticación con validación
/// - Integración con AuthProvider
/// - Estados de carga y error
/// - Navegación entre pantallas de auth
/// - Diseño responsive y accesible
/// 
/// Conceptos educativos demostrados:
/// - Form validation patterns
/// - Provider consumption
/// - Error handling UI
/// - Responsive design

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  _buildHeader(),
                  const SizedBox(height: 48),
                  _buildLoginForm(authProvider),
                  const SizedBox(height: 24),
                  _buildFooter(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  /// **CONSTRUIR HEADER** 📱
  Widget _buildHeader() {
    return Column(
      children: [
        // Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.library_books,
            size: 40,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Título
        Text(
          'MyLibrary',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Subtítulo
        Text(
          'Tu biblioteca digital personal',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  /// **CONSTRUIR FORMULARIO** 📝
  Widget _buildLoginForm(AuthProvider authProvider) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Campo de email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Ingresa tu email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: _validateEmail,
          ),
          
          const SizedBox(height: 16),
          
          // Campo de contraseña
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              hintText: 'Ingresa tu contraseña',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            validator: _validatePassword,
            onFieldSubmitted: (_) => _handleLogin(authProvider),
          ),
          
          const SizedBox(height: 8),
          
          // Enlace "Olvidé mi contraseña"
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.push('/auth/forgot-password'),
              child: const Text('¿Olvidaste tu contraseña?'),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Botón de login
          FilledButton(
            onPressed: _isLoading ? null : () => _handleLogin(authProvider),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Iniciar Sesión'),
          ),
          
          // Mostrar error si existe
          if (authProvider.error != null) ...[
            const SizedBox(height: 16),
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        authProvider.error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  /// **CONSTRUIR FOOTER** 🔗
  Widget _buildFooter() {
    return Column(
      children: [
        const SizedBox(height: 24),
        
        // Divider con texto
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '¿No tienes cuenta?',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Botón de registro
        OutlinedButton(
          onPressed: () => context.push('/auth/signup'),
          child: const Text('Crear cuenta nueva'),
        ),
        
        const SizedBox(height: 24),
        
        // Información educativa
        Text(
          'Proyecto educativo - Universidad del Valle',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  /// **VALIDAR EMAIL** ✅
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu email';
    }
    
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor ingresa un email válido';
    }
    
    return null;
  }
  
  /// **VALIDAR CONTRASEÑA** ✅
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }
    
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    
    return null;
  }
  
  /// **MANEJAR LOGIN** 🔑
  Future<void> _handleLogin(AuthProvider authProvider) async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final result = await authProvider.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      if (result.isSuccess && mounted) {
        // Navegar a la pantalla principal
        context.go('/home');
        
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}