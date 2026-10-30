// ============================================================================
// features/home/presentation/widgets/map_preview_card.dart
// ============================================================================
// Card com preview do mapa Google Maps ou fallback visual rico quando
// executado no Web sem a SDK do Google Maps carregada.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/map_helper.dart';

/// Card com miniatura do mapa centrado na localização do usuário
class MapPreviewCard extends StatefulWidget {
  const MapPreviewCard({super.key});

  @override
  State<MapPreviewCard> createState() => _MapPreviewCardState();
}

class _MapPreviewCardState extends State<MapPreviewCard> {
  GoogleMapController? _mapController;
  late final bool _mapsAvailable;

  // Posição padrão: Vitória, ES (sede do InclusIMove)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-20.3155, -40.3128),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    _mapsAvailable = isGoogleMapsReady();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Mapa real se o SDK estiver pronto, caso contrário exibe mapa estilizado
          if (_mapsAvailable)
            GoogleMap(
              initialCameraPosition: _initialPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
              onMapCreated: (controller) {
                _mapController = controller;
              },
            )
          else
            _buildInteractiveMapMockup(context),

          // Botão de localização
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () {
                if (_mapsAvailable) {
                  _mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(_initialPosition),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Localização centrada em Vitória, ES'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceWhite,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.surfaceBorder,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.my_location_rounded,
                  color: AppTheme.primaryOrange,
                  size: 20,
                ),
              ),
            ),
          ),

          // Label "Sua localização" em card pill elegante
          Positioned(
            bottom: 12,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.surfaceBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: AppTheme.primaryOrange,
                    size: 16,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Sua localização atual • Vitória, ES',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Mapa visual estilizado para pré-visualização quando o JS SDK ainda não está pronto
  Widget _buildInteractiveMapMockup(BuildContext context) {
    return Container(
      color: const Color(0xFF1E293B),
      child: Stack(
        children: [
          // Malha de ruas estilizadas
          CustomPaint(
            size: Size.infinite,
            painter: _StreetGridPainter(),
          ),

          // Veículo adaptado simulado no mapa
          Positioned(
            top: 42,
            left: 70,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceNavyLight,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Text(
                    'Van Acessível • 4 min',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryOrange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.directions_car_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ],
            ).animate(onPlay: (c) => c.repeat(reverse: true)).moveX(
                  begin: 0,
                  end: 18,
                  duration: 2500.ms,
                  curve: Curves.easeInOut,
                ),
          ),

          // Ponto do usuário com pulso animado
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryOrange.withValues(alpha: 0.18),
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(begin: const Offset(0.7, 0.7), end: const Offset(1.4, 1.4))
                    .fadeOut(),
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryOrange,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryOrange.withValues(alpha: 0.5),
                        blurRadius: 10,
                      ),
                    ],
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

/// Painter vetorial para desenhar traçados de vias estilizadas no fundo
class _StreetGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFF334155).withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final secondaryRoadPaint = Paint()
      ..color = const Color(0xFF27354A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Vias secundárias
    for (double y = 20; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), secondaryRoadPaint);
    }
    for (double x = 30; x < size.width; x += 60) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), secondaryRoadPaint);
    }

    // Avenidas principais
    final path1 = Path()
      ..moveTo(0, size.height * 0.75)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.65,
        size.width,
        size.height * 0.25,
      );
    canvas.drawPath(path1, roadPaint);

    final path2 = Path()
      ..moveTo(size.width * 0.25, 0)
      ..lineTo(size.width * 0.75, size.height);
    canvas.drawPath(path2, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
