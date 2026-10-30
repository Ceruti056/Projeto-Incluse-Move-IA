// ============================================================================
// features/auth/presentation/pages/splash_page.dart - Tela de Splash
// ============================================================================
// Tela de entrada com fundo branco luminoso, logotipo refinado, animações suaves
// e verificação automática de autenticação.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Navega suavemente após a exibição direto para a home
    Future.delayed(const Duration(milliseconds: 2600), () {
      if (!mounted) return;
      context.go(AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Stack(
        children: [
          // ── Fundo Branco com Brilho Ambiente Suave ─────────────────────────
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.primaryOrange.withValues(alpha: 0.08),
                    AppTheme.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.primaryOrange.withValues(alpha: 0.06),
                    AppTheme.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // ── Logo Central com Camadas e Sombra Premium ──────────────
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Pulso sutil de fundo
                      Container(
                        width: 136,
                        height: 136,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                        ),
                      )
                          .animate(
                            onPlay: (controller) => controller.repeat(reverse: true),
                          )
                          .scale(
                            begin: const Offset(0.9, 0.9),
                            end: const Offset(1.15, 1.15),
                            duration: 1800.ms,
                            curve: Curves.easeInOut,
                          ),

                      // Card circular do emblema
                      Container(
                        width: 108,
                        height: 108,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.primaryOrange,
                              AppTheme.primaryOrangeDark,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryOrange.withValues(alpha: 0.35),
                              blurRadius: 28,
                              spreadRadius: 2,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Ícone de pin de rota
                              Icon(
                                Icons.location_on_rounded,
                                size: 58,
                                color: AppTheme.white.withValues(alpha: 0.28),
                              ),
                              // Ícone principal de acessibilidade
                              const Icon(
                                Icons.accessible_forward_rounded,
                                size: 48,
                                color: AppTheme.white,
                              ),
                            ],
                          ),
                        ),
                      )
                          .animate()
                          .scale(
                            duration: 850.ms,
                            curve: Curves.elasticOut,
                            begin: const Offset(0.3, 0.3),
                          )
                          .fadeIn(duration: 600.ms),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ── Título da Marca (Tipografia Alta Definição) ────────────
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Inclus',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textPrimary,
                            letterSpacing: -1,
                          ),
                        ),
                        TextSpan(
                          text: 'I',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.primaryOrange,
                            letterSpacing: -1,
                          ),
                        ),
                        TextSpan(
                          text: 'Move',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textPrimary,
                            letterSpacing: -1,
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate(delay: 300.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.25, end: 0, curve: Curves.easeOutCubic),

                  const SizedBox(height: 8),

                  // ── Tagline ────────────────────────────────────────────────
                  const Text(
                    'Mobilidade com dignidade',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  )
                      .animate(delay: 500.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 16),

                  // ── Badge de Especialidade ─────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryOrangeLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.primaryOrange.withValues(alpha: 0.25),
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          size: 14,
                          color: AppTheme.primaryOrange,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Transporte Especializado & Acessível',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryOrangeDark,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate(delay: 700.ms)
                      .fadeIn(duration: 500.ms)
                      .scale(begin: const Offset(0.85, 0.85)),

                  const Spacer(flex: 3),

                  // ── Indicador de Carregamento ──────────────────────────────
                  Column(
                    children: [
                      const SizedBox(
                        width: 34,
                        height: 34,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryOrange,
                          ),
                          backgroundColor: AppTheme.surfaceBorder,
                        ),
                      )
                          .animate(delay: 800.ms)
                          .fadeIn(duration: 400.ms)
                          .scale(begin: const Offset(0.6, 0.6)),
                      const SizedBox(height: 14),
                      const Text(
                        'Carregando com segurança...',
                        style: TextStyle(
                          color: AppTheme.textTertiary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ).animate(delay: 900.ms).fadeIn(duration: 400.ms),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── Rodapé Sutil ───────────────────────────────────────────
                  const Text(
                    'InclusIMove • Mobilidade para Todos',
                    style: TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.4,
                    ),
                  ).animate(delay: 1100.ms).fadeIn(duration: 400.ms),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
