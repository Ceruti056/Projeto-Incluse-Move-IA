// ============================================================================
// features/home/presentation/widgets/trip_card.dart
// ============================================================================

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

enum TripStatus { scheduled, confirmed, inProgress, completed, cancelled }

/// Card de viagem agendada
class TripCard extends StatelessWidget {
  final String time;
  final String destination;
  final String driverName;
  final TripStatus status;

  const TripCard({
    super.key,
    required this.time,
    required this.destination,
    required this.driverName,
    required this.status,
  });

  Color get _statusColor {
    switch (status) {
      case TripStatus.scheduled:
        return AppTheme.warning;
      case TripStatus.confirmed:
        return AppTheme.success;
      case TripStatus.inProgress:
        return AppTheme.primaryOrange;
      case TripStatus.completed:
        return AppTheme.textSecondary;
      case TripStatus.cancelled:
        return AppTheme.error;
    }
  }

  String get _statusLabel {
    switch (status) {
      case TripStatus.scheduled:
        return 'Agendada';
      case TripStatus.confirmed:
        return 'Confirmada';
      case TripStatus.inProgress:
        return 'Em andamento';
      case TripStatus.completed:
        return 'Concluída';
      case TripStatus.cancelled:
        return 'Cancelada';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceNavy,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.surfaceNavyLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho: horário e status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    color: AppTheme.primaryOrange,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    time,
                    style: const TextStyle(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _statusColor.withOpacity(0.4)),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(
                    color: _statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(height: 1, color: AppTheme.surfaceNavyLight),
          const SizedBox(height: 10),

          // Destino
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: AppTheme.primaryOrange,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  destination,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Motorista
          Row(
            children: [
              const Icon(
                Icons.person_outlined,
                color: AppTheme.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Motorista: $driverName',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
