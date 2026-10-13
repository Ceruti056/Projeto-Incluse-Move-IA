// ============================================================================
// app.dart - Widget raiz do aplicativo InclusIMove
// ============================================================================
// Configura tema, roteamento (GoRouter) e o MaterialApp.router.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';

/// Widget raiz que consome o provedor de tema e inicializa o roteador
class InclusIMovApp extends ConsumerWidget {
  const InclusIMovApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observa o modo de tema (claro / escuro)
    final themeMode = ref.watch(themeModeProvider);
    // Obtém o roteador configurado
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'InclusIMove',
      debugShowCheckedModeBanner: false,

      // Configurações de tema
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // Configurações de localização
      locale: const Locale('pt', 'BR'),

      // Configurações do roteador (GoRouter)
      routerConfig: router,
    );
  }
}
