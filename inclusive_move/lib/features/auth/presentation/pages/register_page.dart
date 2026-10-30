// ============================================================================
// features/auth/presentation/pages/register_page.dart - Tela de Cadastro
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _acceptedTerms = false;

  // Necessidades de acessibilidade selecionadas
  final Set<String> _accessibilityNeeds = {};
  static const _accessibilityOptions = [
    'Cadeirante',
    'Bengala/Andador',
    'Deficiência Visual',
    'Deficiência Auditiva',
    'Idoso (60+)',
    'Mobilidade Reduzida',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aceite os termos para continuar.')),
      );
      return;
    }

    await ref.read(authFormProvider.notifier).signUpWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
          phone: _phoneController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authFormProvider);
    final isLoading = authState.status == AuthStatus.loading;

    ref.listen<AuthFormState>(authFormProvider, (prev, next) {
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundNavy,
      appBar: AppBar(
        title: const Text('Criar conta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtítulo
              const Text(
                'Preencha seus dados para começar sua jornada acessível.',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 15),
              ).animate().fadeIn(delay: 100.ms),

              const SizedBox(height: 28),

              // Nome completo
              AuthTextField(
                controller: _nameController,
                label: 'Nome completo',
                hint: 'Maria Silva',
                prefixIcon: Icons.person_outline_rounded,
                textCapitalization: TextCapitalization.words,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Informe seu nome completo';
                  }
                  return null;
                },
              ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.08),

              const SizedBox(height: 14),

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
              ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.08),

              const SizedBox(height: 14),

              // Telefone
              AuthTextField(
                controller: _phoneController,
                label: 'Telefone / WhatsApp',
                hint: '(27) 99999-9999',
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe seu telefone';
                  return null;
                },
              ).animate(delay: 250.ms).fadeIn().slideY(begin: 0.08),

              const SizedBox(height: 14),

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
                  if (v == null || v.isEmpty) return 'Crie uma senha';
                  if (v.length < 6) return 'Mínimo de 6 caracteres';
                  return null;
                },
              ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.08),

              const SizedBox(height: 14),

              // Confirmação de senha
              AuthTextField(
                controller: _confirmController,
                label: 'Confirmar senha',
                hint: '••••••••',
                obscureText: true,
                prefixIcon: Icons.lock_outline_rounded,
                validator: (v) {
                  if (v != _passwordController.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ).animate(delay: 350.ms).fadeIn().slideY(begin: 0.08),

              const SizedBox(height: 24),

              // ── Necessidades de acessibilidade ──────────────────────────────
              Text(
                'Necessidades de acessibilidade',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ).animate(delay: 400.ms).fadeIn(),

              const SizedBox(height: 4),
              const Text(
                'Selecione todas que se aplicam (opcional)',
                style:
                    TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ).animate(delay: 420.ms).fadeIn(),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _accessibilityOptions.map((option) {
                  final isSelected = _accessibilityNeeds.contains(option);
                  return FilterChip(
                    label: Text(option),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _accessibilityNeeds.add(option);
                        } else {
                          _accessibilityNeeds.remove(option);
                        }
                      });
                    },
                    selectedColor: AppTheme.primaryOrange.withValues(alpha: 0.2),
                    checkmarkColor: AppTheme.primaryOrange,
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.primaryOrange
                          : AppTheme.surfaceNavyLight,
                      width: 1.5,
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? AppTheme.primaryOrange : AppTheme.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  );
                }).toList(),
              ).animate(delay: 450.ms).fadeIn(),

              const SizedBox(height: 24),

              // Termos de uso
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _acceptedTerms,
                    activeColor: AppTheme.primaryOrange,
                    onChanged: (v) =>
                        setState(() => _acceptedTerms = v ?? false),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Aceito os ',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: 'Termos de Uso',
                              style: TextStyle(
                                color: AppTheme.primaryOrange,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: ' e a ',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: 'Política de Privacidade',
                              style: TextStyle(
                                color: AppTheme.primaryOrange,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ).animate(delay: 500.ms).fadeIn(),

              const SizedBox(height: 28),

              // Botão Cadastrar
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _onRegister,
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: AppTheme.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text('Criar minha conta'),
                ),
              ).animate(delay: 550.ms).fadeIn().slideY(begin: 0.1),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
