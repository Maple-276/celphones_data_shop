import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../core/theme/app_colors.dart';
import 'widgets/app_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final AuthController _authController = AuthController();
  bool _isRegister = false;
  bool _obscure = true;

  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  @override
  void dispose() {
    _shake.dispose();
    _authController.dispose();
    super.dispose();
  }

  void _fail(String? msg) {
    _shake.forward(from: 0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg ?? 'No se pudo continuar')),
    );
  }

  // Texto que hace cross-fade al cambiar (la Key por contenido dispara el switch).
  Widget _switchText(String text, TextStyle style) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, anim) =>
            FadeTransition(opacity: anim, child: child),
        child: Text(text, key: ValueKey(text), style: style),
      );

  void _handleGoogle() async {
    final success = await _authController.signInWithGoogle();
    if (!mounted || success) return; // el auth gate navega al haber sesión.
    _fail(_authController.errorMessage ?? 'No se pudo iniciar sesión');
  }

  void _handleEmail() async {
    final success = _isRegister
        ? await _authController.signUpWithEmail()
        : await _authController.signInWithEmail();
    if (!mounted) return;
    if (success) {
      if (_isRegister) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Cuenta creada. Revisa tu correo para verificarla.')),
        );
      }
      return; // el auth gate navega al haber sesión.
    }
    _fail(_authController.errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 550),
                  curve: Curves.easeOutCubic,
                  tween: Tween(begin: 0, end: 1),
                  builder: (context, t, child) => Opacity(
                    opacity: t.clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(0, (1 - t) * 28),
                      child: child,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    const AppLogo(size: 96),
                    const SizedBox(height: 20),
                    const Text(
                      'Celphones Data Shop',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Gestiona tus equipos con estilo',
                      style: TextStyle(
                          fontSize: 14, color: Colors.white.withValues(alpha: 0.85)),
                    ),
                    const SizedBox(height: 32),
                    AnimatedBuilder(
                      animation: _shake,
                      builder: (context, child) => Transform.translate(
                        // oscila y se amortigua: sacudida corta al fallar.
                        offset: Offset(
                          math.sin(_shake.value * math.pi * 4) *
                              10 *
                              (1 - _shake.value),
                          0,
                        ),
                        child: child,
                      ),
                      child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: AppColors.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: AnimatedBuilder(
                          animation: _authController,
                          builder: (context, _) {
                            return AnimatedSize(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                              alignment: Alignment.topCenter,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                const Text(
                                  'Bienvenido',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 4),
                                _switchText(
                                  _isRegister
                                      ? 'Crea tu cuenta con correo y contraseña'
                                      : 'Ingresa con tu correo o con Google',
                                  const TextStyle(color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 24),
                                TextField(
                                  controller: _authController.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [AutofillHints.email],
                                  decoration: const InputDecoration(
                                    labelText: 'Correo',
                                    prefixIcon: Icon(Icons.email_outlined),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _authController.passwordController,
                                  obscureText: _obscure,
                                  autofillHints: const [AutofillHints.password],
                                  textInputAction: _isRegister
                                      ? TextInputAction.next
                                      : TextInputAction.done,
                                  onSubmitted: (_) => _isRegister ||
                                          _authController.isLoading
                                      ? null
                                      : _handleEmail(),
                                  decoration: InputDecoration(
                                    labelText: 'Contraseña',
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    border: const OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscure
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined),
                                      onPressed: () =>
                                          setState(() => _obscure = !_obscure),
                                    ),
                                  ),
                                ),
                                if (_isRegister) ...[
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller:
                                        _authController.confirmPasswordController,
                                    obscureText: _obscure,
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: (_) =>
                                        _authController.isLoading ? null : _handleEmail(),
                                    decoration: const InputDecoration(
                                      labelText: 'Confirmar contraseña',
                                      prefixIcon: Icon(Icons.lock_outline),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12)),
                                    ),
                                    onPressed:
                                        _authController.isLoading ? null : _handleEmail,
                                    child: _switchText(
                                      _authController.isLoading
                                          ? (_isRegister
                                              ? 'Creando cuenta...'
                                              : 'Ingresando...')
                                          : (_isRegister
                                              ? 'Crear cuenta'
                                              : 'Continuar con correo'),
                                      const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Center(
                                  child: TextButton(
                                    onPressed: _authController.isLoading
                                        ? null
                                        : () => setState(() {
                                              _isRegister = !_isRegister;
                                              _authController.errorMessage = null;
                                            }),
                                    child: Text(
                                      _isRegister
                                          ? '¿Ya tienes cuenta? Inicia sesión'
                                          : '¿No tienes cuenta? Regístrate',
                                      style: const TextStyle(color: AppColors.primary),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: const [
                                    Expanded(child: Divider()),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      child: Text('o',
                                          style: TextStyle(color: AppColors.textSecondary)),
                                    ),
                                    Expanded(child: Divider()),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.textPrimary,
                                      side: const BorderSide(color: AppColors.primary),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12)),
                                    ),
                                    onPressed:
                                        _authController.isLoading ? null : _handleGoogle,
                                    icon: _authController.isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Icon(Icons.login),
                                    label: Text(
                                      _authController.isLoading
                                          ? 'Ingresando...'
                                          : 'Continuar con Google',
                                      style: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    ),
                  ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
