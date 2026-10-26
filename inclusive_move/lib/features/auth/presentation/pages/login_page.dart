// ============================================================================
// features/auth/presentation/pages/login_page.dart - Tela de Login
// ============================================================================
// Login com email/senha usando Firebase Auth via Riverpod.
// Design acessível com fontes grandes e alto contraste.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authFormProvider.notifier).signInWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authFormProvider);
    final isLoading = authState.status == AuthStatus.loading;

    // Escuta erros para exibir SnackBar
    ref.listen<AuthFormState>(authFormProvider, (prev, next) {
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: AppTheme.white),
                const SizedBox(width: 10),
                Expanded(child: Text(next.errorMessage!)),
              ],
            ),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: Container(
        color: AppTheme.backgroundWhite,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // ── Logo e título ──────────────────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryOrangeLight,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.primaryOrange.withOpacity(0.35),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryOrange.withOpacity(0.12),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.accessible_forward_rounded,
                            size: 40,
                            color: AppTheme.primaryOrange,
                          ),
                        ).animate().scale(
                              duration: 600.ms,
                              curve: Curves.elasticOut,
                            ),
                        const SizedBox(height: 16),
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Inclus',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              TextSpan(
                                text: 'I',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.primaryOrange,
                                ),
                              ),
                              TextSpan(
                                text: 'Move',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ── Campos de formulário ────────────────────────────────────
                  Text(
                    'Bem-vindo de volta!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ).animate(delay: 300.ms).fadeIn().slideX(begin: -0.1),

                  const SizedBox(height: 6),
                  const Text(
                    'Faça login para continuar',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 15,
                    ),
                  ).animate(delay: 350.ms).fadeIn(),

                  const SizedBox(height: 32),

                  // Email
                  AuthTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'seu@email.com',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Informe seu email';
                      if (!v.contains('@')) return 'Email inválido';
                      return null;
                    },
                  ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1),

                  const SizedBox(height: 16),

                  // Senha
                  AuthTextField(
                    controller: _passwordController,
                    label: 'Senha',
                    hint: '••••••••',
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppTheme.textSecondary,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Informe sua senha';
                      if (v.length < 6) {
                        return 'Senha deve ter pelo menos 6 caracteres';
                      }
                      return null;
                    },
                  ).animate(delay: 450.ms).fadeIn().slideY(begin: 0.1),

                  const SizedBox(height: 12),

                  // Esqueci a senha
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {/* TODO: tela de recuperação de senha */},
                      child: const Text(
                        'Esqueci minha senha',
                        style: TextStyle(
                          color: AppTheme.primaryOrange,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ).animate(delay: 500.ms).fadeIn(),

                  const SizedBox(height: 28),

                  // Botão Entrar
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _onLogin,
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: AppTheme.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Entrar',
                              style: TextStyle(fontSize: 17),
                            ),
                    ),
                  ).animate(delay: 550.ms).fadeIn().slideY(begin: 0.1),

                  const SizedBox(height: 24),

                  // Divisor
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: AppTheme.surfaceNavyLight),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'ou',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: AppTheme.surfaceNavyLight),
                      ),
                    ],
                  ).animate(delay: 600.ms).fadeIn(),

                  const SizedBox(height: 24),

                  // Ir para cadastro
                  Center(
                    child: GestureDetector(
                      onTap: () => context.push(AppRoutes.register),
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Não tem conta? ',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 15,
                              ),
                            ),
                            TextSpan(
                              text: 'Cadastre-se',
                              style: TextStyle(
                                color: AppTheme.primaryOrange,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate(delay: 650.ms).fadeIn(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
