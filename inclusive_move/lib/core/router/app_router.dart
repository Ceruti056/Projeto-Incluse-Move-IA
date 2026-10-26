// ============================================================================
// core/router/app_router.dart - Roteamento com GoRouter
// ============================================================================
// Define todas as rotas nomeadas do app e guarda de autenticação.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/booking/presentation/pages/booking_page.dart';
import '../../features/booking/presentation/pages/booking_confirm_page.dart';
import '../../features/saved_places/presentation/pages/saved_places_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/family/presentation/pages/family_page.dart';
import '../../features/sos/presentation/pages/sos_page.dart';
import '../../features/tracking/presentation/pages/tracking_page.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../layout/main_shell.dart';

/// Provider do GoRouter — observa autenticação para redirecionar
final appRouterProvider = Provider<GoRouter>((ref) {
  // Notifier reativo: redireciona quando o estado de auth muda
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,

    // ── Guarda de Autenticação ─────────────────────────────────────────────
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      if (isLoading) return null; // aguarda carregamento

      final isAuthenticated = authState.valueOrNull != null;
      final isSplash = state.matchedLocation == AppRoutes.splash;
      final isAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      // Na splash não redireciona — ela trata isso internamente
      if (isSplash) return null;

      // Se autenticado e na tela de auth → home
      if (isAuthenticated && isAuthRoute) return AppRoutes.home;

      return null; // sem redirecionamento
    },

    // ── Rotas ─────────────────────────────────────────────────────────────
    routes: [
      // Splash (animação de entrada)
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      // Login
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginPage(),
          transitionsBuilder: _fadeSlideTransition,
        ),
      ),

      // Cadastro
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterPage(),
          transitionsBuilder: _fadeSlideTransition,
        ),
      ),

      // Shell principal com Bottom Navigation Bar
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // Home
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          // Agendar corrida
          GoRoute(
            path: AppRoutes.booking,
            name: 'booking',
            builder: (context, state) => const BookingPage(),
            routes: [
              GoRoute(
                path: 'confirm',
                name: 'booking-confirm',
                builder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>?;
                  return BookingConfirmPage(bookingData: extra ?? {});
                },
              ),
            ],
          ),
          // Chat com Grok AI
          GoRoute(
            path: AppRoutes.chat,
            name: 'chat',
            builder: (context, state) => const ChatPage(),
          ),
          // Perfil
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),

      // Destinos salvos (sem shell)
      GoRoute(
        path: AppRoutes.savedPlaces,
        name: 'saved-places',
        builder: (context, state) => const SavedPlacesPage(),
      ),

      // Família / contatos
      GoRoute(
        path: AppRoutes.family,
        name: 'family',
        builder: (context, state) => const FamilyPage(),
      ),

      // SOS
      GoRoute(
        path: AppRoutes.sos,
        name: 'sos',
        builder: (context, state) => const SosPage(),
      ),

      // Rastreamento em tempo real
      GoRoute(
        path: AppRoutes.tracking,
        name: 'tracking',
        builder: (context, state) {
          final tripId = state.pathParameters['tripId'] ?? '';
          return TrackingPage(tripId: tripId);
        },
      ),
    ],

    // Página 404
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Página não encontrada: ${state.error}'),
      ),
    ),
  );
});

/// Transição com fade + slide suave
Widget _fadeSlideTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
    child: SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.05),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
      child: child,
    ),
  );
}

/// Constantes de rotas nomeadas
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String booking = '/booking';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String savedPlaces = '/saved-places';
  static const String family = '/family';
  static const String sos = '/sos';
  static const String tracking = '/tracking/:tripId';
}
