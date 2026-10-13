// ============================================================================
// features/saved_places/presentation/pages/saved_places_page.dart
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';

class SavedPlacesPage extends StatefulWidget {
  const SavedPlacesPage({super.key});

  @override
  State<SavedPlacesPage> createState() => _SavedPlacesPageState();
}

class _SavedPlacesPageState extends State<SavedPlacesPage> {
  // Destinos mockados — substituir por dados do Firestore
  final List<Map<String, dynamic>> _places = [
    {
      'name': 'UPA Norte',
      'address': 'Av. Marechal Campos, 1468 - Vitória, ES',
      'icon': Icons.local_hospital_rounded,
      'color': 0xFFF44336,
      'category': 'Saúde',
    },
    {
      'name': 'Farmácia Drogasil',
      'address': 'R. das Flores, 235 - Vitória, ES',
      'icon': Icons.local_pharmacy_rounded,
      'color': 0xFF4CAF50,
      'category': 'Farmácia',
    },
    {
      'name': 'Supermercado Extrabom',
      'address': 'R. Pedro Palácios, 100 - Vitória, ES',
      'icon': Icons.shopping_cart_rounded,
      'color': 0xFF2196F3,
      'category': 'Mercado',
    },
    {
      'name': 'Casa',
      'address': 'R. Exemplo, 45 - Vitória, ES',
      'icon': Icons.home_rounded,
      'color': 0xFFFF6B35,
      'category': 'Casa',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundNavy,
      appBar: AppBar(title: const Text('Destinos Salvos')),
      body: Column(
        children: [
          // Barra de busca
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: TextField(
              style: const TextStyle(color: AppTheme.white),
              decoration: InputDecoration(
                hintText: 'Buscar destino...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: AppTheme.surfaceNavy,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Lista de destinos
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
              itemCount: _places.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final place = _places[index];
                return _PlaceCard(place: place)
                    .animate(delay: Duration(milliseconds: index * 80))
                    .fadeIn()
                    .slideX(begin: -0.05);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {/* TODO: adicionar destino */},
        icon: const Icon(Icons.add_rounded),
        label: const Text('Adicionar'),
        backgroundColor: AppTheme.primaryOrange,
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final Map<String, dynamic> place;

  const _PlaceCard({required this.place});

  @override
  Widget build(BuildContext context) {
    final color = Color(place['color'] as int);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceNavy,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.surfaceNavyLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(place['icon'] as IconData, color: color, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place['name'] as String,
                  style: const TextStyle(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  place['address'] as String,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    place['category'] as String,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.directions_rounded),
                color: AppTheme.primaryOrange,
                onPressed: () {/* TODO: ir para esse destino */},
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                color: AppTheme.textSecondary,
                iconSize: 20,
                onPressed: () {/* TODO: remover */},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
