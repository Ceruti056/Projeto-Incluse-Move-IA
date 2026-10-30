// ============================================================================
// features/profile/presentation/pages/profile_page.dart - Perfil do Usuário
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../auth/providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);
    final isDark = ref.watch(themeModeProvider.notifier).isDark;

    final name = user?.displayName ?? 'Usuário';
    final email = user?.email ?? '--';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Scaffold(
      backgroundColor: AppTheme.backgroundNavy,
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
        child: Column(
          children: [
            // ── Avatar e nome ──────────────────────────────────────────────
            Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor:
                          AppTheme.primaryOrange.withValues(alpha: 0.2),
                      child: user?.photoURL != null
                          ? ClipOval(
                              child: Image.network(
                                user!.photoURL!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Text(
                              initial,
                              style: const TextStyle(
                                color: AppTheme.primaryOrange,
                                fontSize: 38,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryOrange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: AppTheme.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 500.ms),

            const SizedBox(height: 32),

            // ── Seções de configurações ────────────────────────────────────
            _ProfileSection(
              title: 'Minha Conta',
              items: [
                _ProfileItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Editar perfil',
                  onTap: () {/* TODO */},
                ),
                _ProfileItem(
                  icon: Icons.bookmark_outline_rounded,
                  label: 'Destinos salvos',
                  onTap: () => context.push(AppRoutes.savedPlaces),
                ),
                _ProfileItem(
                  icon: Icons.groups_rounded,
                  label: 'Contatos familiares',
                  onTap: () => context.push(AppRoutes.family),
                ),
                _ProfileItem(
                  icon: Icons.history_rounded,
                  label: 'Histórico de viagens',
                  onTap: () {/* TODO */},
                ),
              ],
            ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.06),

            const SizedBox(height: 16),

            _ProfileSection(
              title: 'Preferências',
              items: [
                _ProfileItem(
                  icon: Icons.dark_mode_rounded,
                  label: 'Modo escuro',
                  trailing: Switch(
                    value: isDark,
                    activeThumbColor: AppTheme.primaryOrange,
                    onChanged: (_) => themeNotifier.toggleTheme(),
                  ),
                  onTap: () => themeNotifier.toggleTheme(),
                ),
                _ProfileItem(
                  icon: Icons.notifications_outlined,
                  label: 'Notificações',
                  onTap: () {/* TODO */},
                ),
                _ProfileItem(
                  icon: Icons.accessibility_new_rounded,
                  label: 'Necessidades de acessibilidade',
                  onTap: () {/* TODO */},
                ),
                _ProfileItem(
                  icon: Icons.language_rounded,
                  label: 'Idioma',
                  subtitle: 'Português (BR)',
                  onTap: () {/* TODO */},
                ),
              ],
            ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.06),

            const SizedBox(height: 16),

            _ProfileSection(
              title: 'Suporte',
              items: [
                _ProfileItem(
                  icon: Icons.smart_toy_outlined,
                  label: 'Assistente InclusI',
                  onTap: () => context.go(AppRoutes.chat),
                ),
                _ProfileItem(
                  icon: Icons.help_outline_rounded,
                  label: 'Central de ajuda',
                  onTap: () {/* TODO */},
                ),
                _ProfileItem(
                  icon: Icons.policy_outlined,
                  label: 'Termos e Privacidade',
                  onTap: () {/* TODO */},
                ),
                _ProfileItem(
                  icon: Icons.info_outline_rounded,
                  label: 'Versão do app',
                  subtitle: '1.0.0',
                  onTap: () {},
                ),
              ],
            ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.06),

            const SizedBox(height: 16),

            // Botão sair
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout_rounded, color: AppTheme.error),
                label: const Text(
                  'Sair da conta',
                  style: TextStyle(color: AppTheme.error),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.error, width: 1.5),
                  foregroundColor: AppTheme.error,
                ),
                onPressed: () async {
                  await ref.read(authFormProvider.notifier).signOut();
                  if (context.mounted) context.go(AppRoutes.login);
                },
              ),
            ).animate(delay: 400.ms).fadeIn(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<_ProfileItem> items;

  const _ProfileSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceNavy,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.surfaceNavyLight),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  item,
                  if (i < items.length - 1)
                    const Divider(
                      height: 1,
                      color: AppTheme.surfaceNavyLight,
                      indent: 56,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _ProfileItem({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryOrange.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppTheme.primaryOrange, size: 20),
      ),
      title: Text(
        label,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            )
          : null,
      trailing: trailing ??
          const Icon(
            Icons.chevron_right_rounded,
            color: AppTheme.textSecondary,
            size: 20,
          ),
    );
  }
}
