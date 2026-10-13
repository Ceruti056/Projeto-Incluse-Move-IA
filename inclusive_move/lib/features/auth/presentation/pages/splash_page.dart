// ============================================================================
// features/auth/presentation/pages/splash_page.dart - Tela de Splash
// ============================================================================
// Tela de entrada animada com logo, nome e tagline do app.
// Verifica estado de autenticação e redireciona automaticamente.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';

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
    // Navega após a animação (2,5 segundos)
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      final auth = ref.read(authStateProvider);
      auth.when(
        data: (user) {
          if (user != null) {
            context.go(AppRoutes.home);
          } else {
            context.go(AppRoutes.login);
          }
        },
        loading: () => context.go(AppRoutes.login),
        error: (_, __) => context.go(AppRoutes.login),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundNavy,
      body: Container(
        // Gradiente de fundo
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A1628),
              AppTheme.backgroundNavy,
              Color(0xFF1A2B52),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // ── Logo animado ───────────────────────────────────────────────
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.primaryOrange.withOpacity(0.3),
                      AppTheme.primaryOrange.withOpacity(0.0),
                    ],
                  ),
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Ícone de localização atrás
                      const Icon(
                        Icons.location_on_rounded,
                        size: 80,
                        color: AppTheme.primaryOrange,
                      ),
                      // Ícone de acessibilidade sobreposto
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppTheme.backgroundNavy,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.accessible_rounded,
                            size: 28,
                            color: AppTheme.primaryOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  .animate()
                  .scale(
                    duration: 800.ms,
                    curve: Curves.elasticOut,
                    begin: const Offset(0.3, 0.3),
                  )
                  .fadeIn(duration: 600.ms),

              const SizedBox(height: 32),

              // ── Nome do App ────────────────────────────────────────────────
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Inclus',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.white,
                        letterSpacing: -1,
                      ),
                    ),
                    TextSpan(
                      text: 'I',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryOrange,
                        letterSpacing: -1,
                      ),
                    ),
                    TextSpan(
                      text: 'Move',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.white,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 10),

              // ── Tagline ────────────────────────────────────────────────────
              const Text(
                'Mobilidade com dignidade',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              )
                  .animate(delay: 700.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),

              const Spacer(flex: 2),

              // ── Indicador de carregamento ──────────────────────────────────
              Column(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryOrange,
                      strokeWidth: 3,
                    ),
                  )
                      .animate(delay: 1000.ms)
                      .fadeIn(duration: 500.ms)
                      .scale(begin: const Offset(0.5, 0.5)),
                  const SizedBox(height: 16),
                  const Text(
                    'Carregando...',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ).animate(delay: 1100.ms).fadeIn(duration: 400.ms),
                ],
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
