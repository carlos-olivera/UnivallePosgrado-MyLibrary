import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';

/// **PÁGINA DE REGISTRO EDUCATIVA** 📝
/// 
/// Esta página demuestra:
/// - Formulario de registro con validación avanzada
/// - Confirmación de contraseña
/// - Términos y condiciones
/// - Integración con AuthProvider
/// - Estados de carga y error
/// 
/// Conceptos educativos demostrados:
/// - Form validation patterns
/// - Password confirmation
/// - Terms acceptance UI
/// - Provider consumption

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cuenta'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildSignupForm(authProvider),
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
        Text(
          'Únete a MyLibrary',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'Crea tu cuenta y comienza tu viaje literario',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  /// **CONSTRUIR FORMULARIO** 📝
  Widget _buildSignupForm(AuthProvider authProvider) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Campo de nombre
          TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Nombre completo',
              hintText: 'Ingresa tu nombre',
              prefixIcon: Icon(Icons.person_outlined),
            ),
            validator: _validateName,
          ),
          
          const SizedBox(height: 16),
          
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
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              hintText: 'Crea una contraseña segura',
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
          ),
          
          const SizedBox(height: 16),
          
          // Campo de confirmación de contraseña
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Confirmar contraseña',
              hintText: 'Repite tu contraseña',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
            validator: _validateConfirmPassword,
            onFieldSubmitted: (_) => _handleSignup(authProvider),
          ),
          
          const SizedBox(height: 24),
          
          // Términos y condiciones
          CheckboxListTile(
            value: _acceptTerms,
            onChanged: (value) {
              setState(() {
                _acceptTerms = value ?? false;
              });
            },
            title: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  const TextSpan(text: 'Acepto los '),
                  TextSpan(
                    text: 'términos y condiciones',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: ' del servicio'),
                ],
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          
          const SizedBox(height: 24),
          
          // Botón de registro
          FilledButton(
            onPressed: _isLoading || !_acceptTerms ? null : () => _handleSignup(authProvider),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Crear Cuenta'),
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
                '¿Ya tienes cuenta?',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Botón de login
        OutlinedButton(
          onPressed: () => context.pop(),
          child: const Text('Iniciar Sesión'),
        ),
      ],
    );
  }
  
  /// **VALIDADORES** ✅
  
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingresa tu nombre';
    }
    
    if (value.trim().length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    
    return null;
  }
  
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
  
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa una contraseña';
    }
    
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    
    // Verificar que tenga al menos una letra y un número
    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])').hasMatch(value)) {
      return 'La contraseña debe tener al menos una letra y un número';
    }
    
    return null;
  }
  
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor confirma tu contraseña';
    }
    
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    
    return null;
  }
  
  /// **MANEJAR REGISTRO** 🔑
  Future<void> _handleSignup(AuthProvider authProvider) async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final result = await authProvider.createUserWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
        displayName: _nameController.text.trim(),
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