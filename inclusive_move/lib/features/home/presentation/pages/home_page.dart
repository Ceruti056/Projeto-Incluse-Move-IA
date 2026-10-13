// ============================================================================
// features/home/presentation/pages/home_page.dart - Tela Principal
// ============================================================================
// Dashboard do usuário: mapa, ações rápidas, próximas viagens.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/providers/auth_provider.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/trip_card.dart';
import '../widgets/map_preview_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final firstName = user?.displayName?.split(' ').first ?? 'Usuário';

    return Scaffold(
      backgroundColor: AppTheme.backgroundNavy,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar personalizado ────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 80,
            floating: true,
            snap: true,
            backgroundColor: AppTheme.backgroundNavy,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá, $firstName! 👋',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const Text(
                        'Para onde vamos hoje?',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  // Avatar do usuário
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.profile),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          AppTheme.primaryOrange.withOpacity(0.2),
                      child: user?.photoURL != null
                          ? ClipOval(
                              child: Image.network(
                                user!.photoURL!,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Text(
                              firstName[0].toUpperCase(),
                              style: const TextStyle(
                                color: AppTheme.primaryOrange,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Conteúdo principal ─────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Preview do mapa ────────────────────────────────────────
                const MapPreviewCard()
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.1),

                const SizedBox(height: 24),

                // ── Ações rápidas ──────────────────────────────────────────
                Text(
                  'Ações Rápidas',
                  style: Theme.of(context).textTheme.titleLarge,
                ).animate(delay: 100.ms).fadeIn(),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: QuickActionCard(
                        icon: Icons.calendar_today_rounded,
                        label: 'Agendar\nCorrida',
                        color: AppTheme.primaryOrange,
                        onTap: () => context.go(AppRoutes.booking),
                      ).animate(delay: 150.ms).fadeIn().scale(
                            begin: const Offset(0.9, 0.9),
                          ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuickActionCard(
                        icon: Icons.bookmark_outline_rounded,
                        label: 'Destinos\nSalvos',
                        color: const Color(0xFF64B5F6),
                        onTap: () => context.push(AppRoutes.savedPlaces),
                      ).animate(delay: 200.ms).fadeIn().scale(
                            begin: const Offset(0.9, 0.9),
                          ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuickActionCard(
                        icon: Icons.groups_rounded,
                        label: 'Família\ne Contatos',
                        color: const Color(0xFF81C784),
                        onTap: () => context.push(AppRoutes.family),
                      ).animate(delay: 250.ms).fadeIn().scale(
                            begin: const Offset(0.9, 0.9),
                          ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Botão de suporte por ligação
                _SupportCallButton()
                    .animate(delay: 300.ms)
                    .fadeIn()
                    .slideY(begin: 0.1),

                const SizedBox(height: 28),

                // ── Próximas viagens ────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Próximas Viagens',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () {/* TODO: ver todas */},
                      child: const Text(
                        'Ver todas',
                        style: TextStyle(
                          color: AppTheme.primaryOrange,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ).animate(delay: 350.ms).fadeIn(),

                // Lista de viagens agendadas (mock)
                const TripCard(
                  time: '14h30',
                  destination: 'UPA Norte - Av. Marechal Campos, 1468',
                  driverName: 'Carlos Silva',
                  status: TripStatus.scheduled,
                ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1),

                const SizedBox(height: 10),

                const TripCard(
                  time: '09h00 - Amanhã',
                  destination: 'Farmácia Drogasil - R. das Flores, 235',
                  driverName: 'Ana Paula',
                  status: TripStatus.confirmed,
                ).animate(delay: 450.ms).fadeIn().slideY(begin: 0.1),

                const SizedBox(height: 10),

                // Estado vazio (sem viagens)
                const _EmptyTripsHint()
                    .animate(delay: 500.ms)
                    .fadeIn(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

/// Botão de chamada rápida para o suporte
class _SupportCallButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryOrange.withOpacity(0.15),
            AppTheme.primaryOrange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryOrange.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: AppTheme.primaryOrange,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.phone_rounded,
              color: AppTheme.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Precisa de ajuda?',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Ligue para o suporte agora',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppTheme.primaryOrange,
          ),
        ],
      ),
    );
  }
}

class _EmptyTripsHint extends StatelessWidget {
  const _EmptyTripsHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.directions_car_outlined,
            color: AppTheme.textSecondary,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sem viagens próximas',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Agende sua primeira corrida tocando em "Agendar Corrida"',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
