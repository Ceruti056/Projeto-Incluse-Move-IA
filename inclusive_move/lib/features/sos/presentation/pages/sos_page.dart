// ============================================================================
// features/sos/presentation/pages/sos_page.dart - Tela de Emergência SOS
// ============================================================================
// Tela de emergência com ligação direta e mensagem automática para família.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_theme.dart';

class SosPage extends ConsumerStatefulWidget {
  const SosPage({super.key});

  @override
  ConsumerState<SosPage> createState() => _SosPageState();
}

class _SosPageState extends ConsumerState<SosPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _alertSent = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _callEmergency() async {
    final uri = Uri(scheme: 'tel', path: '192'); // SAMU
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _callSupport() async {
    final uri = Uri(scheme: 'tel', path: '(27)99999-0000');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _sendFamilyAlert() async {
    // TODO: Integrar com Firebase e FCM para enviar push para contatos
    setState(() => _alertSent = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '📱 Alerta enviado para seus contatos de emergência!',
          ),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_rounded, color: AppTheme.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'EMERGÊNCIA',
          style: TextStyle(
            color: AppTheme.error,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Botão SOS pulsante ─────────────────────────────────────────
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 180 + (_pulseController.value * 20),
                    height: 180 + (_pulseController.value * 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.error.withValues(
                          alpha: 0.1 + _pulseController.value * 0.1),
                    ),
                    child: child,
                  );
                },
                child: GestureDetector(
                  onTap: _callEmergency,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.error,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x66F44336),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emergency_rounded,
                          color: AppTheme.white,
                          size: 60,
                        ),
                        SizedBox(height: 6),
                        Text(
                          'SOS',
                          style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().scale(
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  ),

              const SizedBox(height: 20),

              const Text(
                'Toque para chamar o SAMU (192)',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ).animate(delay: 200.ms).fadeIn(),

              const SizedBox(height: 40),

              // ── Ações secundárias ──────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _EmergencyButton(
                      icon: Icons.phone_rounded,
                      label: 'Suporte\nInclusIMove',
                      color: AppTheme.primaryOrange,
                      onTap: _callSupport,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _EmergencyButton(
                      icon: _alertSent
                          ? Icons.check_rounded
                          : Icons.notifications_active_rounded,
                      label:
                          _alertSent ? 'Alerta\nEnviado!' : 'Alertar\nFamília',
                      color: _alertSent
                          ? AppTheme.success
                          : const Color(0xFF9C27B0),
                      onTap: _alertSent ? () {} : _sendFamilyAlert,
                    ),
                  ),
                ],
              ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.1),

              const SizedBox(height: 24),

              // Minha localização atual
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceNavy.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.error.withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: AppTheme.error,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sua localização está sendo compartilhada',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Os contatos de emergência receberão sua posição',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate(delay: 400.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmergencyButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _EmergencyButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
