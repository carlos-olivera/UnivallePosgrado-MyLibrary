import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';

/// **PÁGINA DE RECUPERACIÓN DE CONTRASEÑA EDUCATIVA** 🔐
/// 
/// Esta página demuestra:
/// - Formulario de recuperación de contraseña
/// - Validación de email
/// - Estados de éxito y error
/// - Envío de email de recuperación
/// - Navegación de retorno
/// 
/// Conceptos educativos demostrados:
/// - Password reset flow
/// - Email validation
/// - Success/error state handling
/// - Firebase Auth integration

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Contraseña'),
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
                  const SizedBox(height: 32),
                  _buildHeader(),
                  const SizedBox(height: 48),
                  if (_emailSent)
                    _buildSuccessMessage()
                  else
                    _buildResetForm(authProvider),
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
        // Ícono
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Icon(
            _emailSent ? Icons.mark_email_read : Icons.lock_reset,
            size: 40,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Título
        Text(
          _emailSent ? '¡Email Enviado!' : '¿Olvidaste tu contraseña?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 16),
        
        // Descripción
        Text(
          _emailSent
              ? 'Hemos enviado un enlace de recuperación a tu email. Revisa tu bandeja de entrada y sigue las instrucciones.'
              : 'No te preocupes, ingresa tu email y te enviaremos un enlace para restablecer tu contraseña.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  /// **CONSTRUIR FORMULARIO DE RECUPERACIÓN** 📝
  Widget _buildResetForm(AuthProvider authProvider) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Campo de email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Ingresa tu email registrado',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: _validateEmail,
            onFieldSubmitted: (_) => _handlePasswordReset(authProvider),
          ),
          
          const SizedBox(height: 32),
          
          // Botón de envío
          FilledButton(
            onPressed: _isLoading ? null : () => _handlePasswordReset(authProvider),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Enviar Enlace de Recuperación'),
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
  
  /// **CONSTRUIR MENSAJE DE ÉXITO** ✅
  Widget _buildSuccessMessage() {
    return Column(
      children: [
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(height: 16),
                Text(
                  'Revisa tu email',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Si no ves el email, revisa tu carpeta de spam o correo no deseado.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Botón para reenviar
        OutlinedButton(
          onPressed: () {
            setState(() {
              _emailSent = false;
            });
          },
          child: const Text('Enviar a otro email'),
        ),
      ],
    );
  }
  
  /// **CONSTRUIR FOOTER** 🔗
  Widget _buildFooter() {
    return Column(
      children: [
        const SizedBox(height: 32),
        
        // Botón de retorno
        TextButton.icon(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Volver al login'),
        ),
        
        if (_emailSent) ...[
          const SizedBox(height: 16),
          
          Text(
            '¿No recibiste el email?',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          
          const SizedBox(height: 8),
          
          TextButton(
            onPressed: () {
              setState(() {
                _emailSent = false;
              });
            },
            child: const Text('Intentar con otro email'),
          ),
        ],
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
  
  /// **MANEJAR RECUPERACIÓN DE CONTRASEÑA** 🔐
  Future<void> _handlePasswordReset(AuthProvider authProvider) async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final result = await authProvider.sendPasswordResetEmail(
        _emailController.text.trim(),
      );
      
      if (result.isSuccess && mounted) {
        setState(() {
          _emailSent = true;
        });
        
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