// ============================================================================
// features/booking/presentation/pages/booking_confirm_page.dart
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';

class BookingConfirmPage extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const BookingConfirmPage({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    final dateStr = bookingData['date'] != null
        ? DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(bookingData['date'] as String))
        : '--';

    return Scaffold(
      backgroundColor: AppTheme.backgroundNavy,
      appBar: AppBar(title: const Text('Confirmar Agendamento')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Ícone de confirmação
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.success.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppTheme.success,
                size: 44,
              ),
            )
                .animate()
                .scale(
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                )
                .fadeIn(),

            const SizedBox(height: 20),

            const Text(
              'Revise os detalhes da sua corrida',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ).animate(delay: 200.ms).fadeIn(),

            const SizedBox(height: 24),

            // Card com detalhes
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surfaceNavy,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.surfaceNavyLight),
              ),
              child: Column(
                children: [
                  _DetailRow(
                    icon: Icons.my_location_rounded,
                    iconColor: AppTheme.success,
                    label: 'Partida',
                    value: bookingData['origin'] ?? '--',
                  ),
                  const Divider(color: AppTheme.surfaceNavyLight, height: 24),
                  _DetailRow(
                    icon: Icons.location_on_rounded,
                    iconColor: AppTheme.primaryOrange,
                    label: 'Destino',
                    value: bookingData['destination'] ?? '--',
                  ),
                  const Divider(color: AppTheme.surfaceNavyLight, height: 24),
                  _DetailRow(
                    icon: Icons.calendar_today_rounded,
                    iconColor: const Color(0xFF64B5F6),
                    label: 'Data',
                    value: dateStr,
                  ),
                  const Divider(color: AppTheme.surfaceNavyLight, height: 24),
                  _DetailRow(
                    icon: Icons.access_time_rounded,
                    iconColor: AppTheme.warning,
                    label: 'Horário',
                    value: bookingData['time'] ?? '--',
                  ),
                  const Divider(color: AppTheme.surfaceNavyLight, height: 24),
                  _DetailRow(
                    icon: Icons.directions_car_rounded,
                    iconColor: AppTheme.textSecondary,
                    label: 'Veículo',
                    value: _vehicleLabel(bookingData['vehicleType'] as String?),
                  ),
                  if (bookingData['needsWheelchair'] == true) ...[
                    const Divider(color: AppTheme.surfaceNavyLight, height: 24),
                    const _DetailRow(
                      icon: Icons.accessible_rounded,
                      iconColor: AppTheme.primaryOrange,
                      label: 'Acessibilidade',
                      value: 'Cadeira de rodas',
                    ),
                  ],
                ],
              ),
            ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.1),

            const SizedBox(height: 28),

            // Botão confirmar
            ElevatedButton.icon(
              icon: const Icon(Icons.check_rounded),
              label: const Text('Confirmar Agendamento'),
              onPressed: () {
                // TODO: Salvar no Firestore e enviar notificação
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Corrida agendada com sucesso!'),
                    backgroundColor: AppTheme.success,
                  ),
                );
                context.go(AppRoutes.home);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
            ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1),

            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: () => context.pop(),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text('Editar'),
            ).animate(delay: 450.ms).fadeIn(),
          ],
        ),
      ),
    );
  }

  String _vehicleLabel(String? type) {
    switch (type) {
      case 'adapted':
        return 'Adaptado (Rampa/Elevador)';
      case 'van':
        return 'Van (até 8 pessoas)';
      default:
        return 'Padrão (Sedan/Hatch)';
    }
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
