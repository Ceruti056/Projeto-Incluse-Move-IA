// ============================================================================
// features/home/presentation/widgets/map_preview_card.dart
// ============================================================================
// Card com preview do mapa Google Maps ou placeholder quando sem permissão.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/theme/app_theme.dart';

/// Card com miniatura do mapa centrado na localização do usuário
class MapPreviewCard extends StatefulWidget {
  const MapPreviewCard({super.key});

  @override
  State<MapPreviewCard> createState() => _MapPreviewCardState();
}

class _MapPreviewCardState extends State<MapPreviewCard> {
  GoogleMapController? _mapController;

  // Posição padrão: Vitória, ES (sede do InclusIMove)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-20.3155, -40.3128),
    zoom: 14,
  );

  // Estilo de mapa escuro para combinar com o dark mode
  static const String _darkMapStyle = '''
  [
    {"elementType": "geometry", "stylers": [{"color": "#0D1B3E"}]},
    {"elementType": "labels.text.fill", "stylers": [{"color": "#B0BEC5"}]},
    {"elementType": "labels.text.stroke", "stylers": [{"color": "#0D1B3E"}]},
    {"featureType": "road", "elementType": "geometry", "stylers": [{"color": "#1A2B52"}]},
    {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#0A1628"}]}
  ]
  ''';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.surfaceNavyLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Mapa
          GoogleMap(
            initialCameraPosition: _initialPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
              controller.setMapStyle(_darkMapStyle);
            },
          ),

          // Overlay gradiente na parte inferior
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppTheme.backgroundNavy.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),

          // Botão de localização
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () {/* TODO: centralizar no usuário */},
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceNavy.withOpacity(0.9),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.surfaceNavyLight,
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.my_location_rounded,
                  color: AppTheme.primaryOrange,
                  size: 20,
                ),
              ),
            ),
          ),

          // Label "Sua localização"
          const Positioned(
            bottom: 14,
            left: 16,
            child: Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: AppTheme.primaryOrange,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  'Sua localização atual',
                  style: TextStyle(
                    color: AppTheme.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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
