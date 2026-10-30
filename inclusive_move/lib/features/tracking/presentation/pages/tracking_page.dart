// ============================================================================
// features/tracking/presentation/pages/tracking_page.dart - Rastreamento
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/map_helper.dart';

class TrackingPage extends StatefulWidget {
  final String tripId;

  const TrackingPage({super.key, required this.tripId});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  late final bool _mapsAvailable;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-20.3155, -40.3128),
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
    _mapsAvailable = isGoogleMapsReady();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundNavy,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.surfaceWhite,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded,
                color: AppTheme.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Mapa em tela cheia (ou fallback animado)
          if (_mapsAvailable)
            const GoogleMap(
              initialCameraPosition: _initialPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            )
          else
            _buildFullTrackingMockup(),

          // Card inferior com informações do motorista
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
              decoration: BoxDecoration(
                color: AppTheme.surfaceNavy,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceNavyLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ETA
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: AppTheme.primaryOrange,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Chegada em aprox. 8 minutos',
                          style: TextStyle(
                            color: AppTheme.primaryOrange,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Info do motorista
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor:
                            AppTheme.primaryOrange.withValues(alpha: 0.15),
                        child: const Text(
                          'C',
                          style: TextStyle(
                            color: AppTheme.primaryOrange,
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Carlos Silva',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: AppTheme.warning,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '4.9 • Honda Civic • ABC-1234',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Botão ligar para motorista
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.success.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.success.withValues(alpha: 0.3),
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.phone_rounded),
                          color: AppTheme.success,
                          onPressed: () {/* TODO: ligar */},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Visualização simulada do mapa com rota em tempo real
  Widget _buildFullTrackingMockup() {
    return Container(
      color: const Color(0xFF0F172A),
      child: Stack(
        children: [
          // Traçado de mapa
          Positioned.fill(
            child: CustomPaint(
              painter: _TrackingRoutePainter(),
            ),
          ),

          // Ponto de partida / Usuário
          const Positioned(
            bottom: 240,
            right: 80,
            child: Column(
              children: [
                Icon(
                  Icons.location_pin,
                  color: AppTheme.primaryOrange,
                  size: 34,
                ),
                Text(
                  'Seu Local',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Motorista em movimento aproximando-se
          Positioned(
            top: 200,
            left: 90,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryOrange,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.directions_car_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Carlos (Motorista)',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ],
            ).animate(onPlay: (c) => c.repeat(reverse: true)).move(
                  begin: const Offset(0, 0),
                  end: const Offset(25, 20),
                  duration: 3000.ms,
                  curve: Curves.easeInOut,
                ),
          ),
        ],
      ),
    );
  }
}

class _TrackingRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final routePaint = Paint()
      ..color = AppTheme.primaryOrange.withValues(alpha: 0.7)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(105, 230)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.45, size.width - 95,
          size.height - 250);

    canvas.drawPath(path, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
