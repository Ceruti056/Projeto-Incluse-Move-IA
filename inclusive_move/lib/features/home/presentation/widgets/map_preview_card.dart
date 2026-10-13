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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.surfaceBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
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
            },
          ),

          // Botão de localização
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () {
                _mapController?.animateCamera(
                  CameraUpdate.newCameraPosition(_initialPosition),
                );
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
                      color: Colors.black.withOpacity(0.08),
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
                color: AppTheme.surfaceWhite.withOpacity(0.95),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.surfaceBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
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
                    'Sua localização atual',
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
}
