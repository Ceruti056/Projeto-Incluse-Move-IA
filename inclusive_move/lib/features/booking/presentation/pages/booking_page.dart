// ============================================================================
// features/booking/presentation/pages/booking_page.dart - Agendar Corrida
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/router/app_router.dart';

class BookingPage extends ConsumerStatefulWidget {
  const BookingPage({super.key});

  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _vehicleType = 'standard';
  bool _needsWheelchair = false;
  bool _needsAssistance = false;
  bool _roundTrip = false;

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppTheme.primaryOrange,
            surface: AppTheme.surfaceNavy,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppTheme.primaryOrange,
            surface: AppTheme.surfaceNavy,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundNavy,
      appBar: AppBar(title: const Text('Agendar Corrida')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Origem e Destino ────────────────────────────────────────────
            _SectionTitle('Rota').animate(delay: 50.ms).fadeIn(),
            const SizedBox(height: 12),

            // Origem
            _LocationField(
              controller: _originController,
              label: 'Ponto de Partida',
              hint: 'Digite seu endereço',
              icon: Icons.my_location_rounded,
              iconColor: AppTheme.success,
            ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.08),

            const SizedBox(height: 4),

            // Linha conectora
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Column(
                children: List.generate(
                  3,
                  (i) => Container(
                    width: 2,
                    height: 6,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    color: AppTheme.textSecondary.withOpacity(0.3),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 4),

            // Destino
            _LocationField(
              controller: _destinationController,
              label: 'Destino',
              hint: 'Para onde você vai?',
              icon: Icons.location_on_rounded,
              iconColor: AppTheme.primaryOrange,
            ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.08),

            const SizedBox(height: 20),

            // ── Data e Hora ──────────────────────────────────────────────────
            _SectionTitle('Data e Hora').animate(delay: 200.ms).fadeIn(),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _PickerButton(
                    icon: Icons.calendar_today_rounded,
                    label: _selectedDate != null
                        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                        : 'Selecionar Data',
                    onTap: _selectDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PickerButton(
                    icon: Icons.access_time_rounded,
                    label: _selectedTime != null
                        ? _selectedTime!.format(context)
                        : 'Selecionar Hora',
                    onTap: _selectTime,
                  ),
                ),
              ],
            ).animate(delay: 250.ms).fadeIn(),

            const SizedBox(height: 20),

            // ── Tipo de Veículo ──────────────────────────────────────────────
            _SectionTitle('Tipo de Veículo').animate(delay: 300.ms).fadeIn(),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _VehicleTypeCard(
                    icon: Icons.directions_car_rounded,
                    label: 'Padrão',
                    description: 'Sedan / Hatchback',
                    isSelected: _vehicleType == 'standard',
                    onTap: () => setState(() => _vehicleType = 'standard'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _VehicleTypeCard(
                    icon: Icons.accessible_rounded,
                    label: 'Adaptado',
                    description: 'Rampa / Elevador',
                    isSelected: _vehicleType == 'adapted',
                    onTap: () => setState(() => _vehicleType = 'adapted'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _VehicleTypeCard(
                    icon: Icons.airport_shuttle_rounded,
                    label: 'Van',
                    description: 'Até 8 pessoas',
                    isSelected: _vehicleType == 'van',
                    onTap: () => setState(() => _vehicleType = 'van'),
                  ),
                ),
              ],
            ).animate(delay: 350.ms).fadeIn(),

            const SizedBox(height: 20),

            // ── Necessidades Especiais ────────────────────────────────────────
            _SectionTitle('Necessidades Especiais')
                .animate(delay: 400.ms)
                .fadeIn(),
            const SizedBox(height: 12),

            _CheckboxTile(
              title: 'Preciso de cadeira de rodas no veículo',
              icon: Icons.wheelchair_pickup_rounded,
              value: _needsWheelchair,
              onChanged: (v) => setState(() => _needsWheelchair = v ?? false),
            ).animate(delay: 420.ms).fadeIn(),

            const SizedBox(height: 8),

            _CheckboxTile(
              title: 'Preciso de auxílio para embarque/desembarque',
              icon: Icons.support_agent_rounded,
              value: _needsAssistance,
              onChanged: (v) => setState(() => _needsAssistance = v ?? false),
            ).animate(delay: 440.ms).fadeIn(),

            const SizedBox(height: 8),

            _CheckboxTile(
              title: 'Viagem de ida e volta',
              icon: Icons.compare_arrows_rounded,
              value: _roundTrip,
              onChanged: (v) => setState(() => _roundTrip = v ?? false),
            ).animate(delay: 460.ms).fadeIn(),

            const SizedBox(height: 28),

            // Botão confirmar
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: const Text('Continuar'),
                onPressed: _canProceed()
                    ? () => context.push(
                          '${AppRoutes.booking}/confirm',
                          extra: {
                            'origin': _originController.text,
                            'destination': _destinationController.text,
                            'date': _selectedDate?.toIso8601String(),
                            'time': _selectedTime != null
                                ? '${_selectedTime!.hour}:${_selectedTime!.minute}'
                                : null,
                            'vehicleType': _vehicleType,
                            'needsWheelchair': _needsWheelchair,
                            'needsAssistance': _needsAssistance,
                            'roundTrip': _roundTrip,
                          },
                        )
                    : null,
              ),
            ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.1),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    return _originController.text.isNotEmpty &&
        _destinationController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedTime != null;
  }
}

// ── Widgets auxiliares da tela de booking ─────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppTheme.textPrimary,
      ),
    );
  }
}

class _LocationField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final Color iconColor;

  const _LocationField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: iconColor, size: 22),
        filled: true,
        fillColor: AppTheme.surfaceNavy,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.surfaceNavyLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.surfaceNavyLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.primaryOrange, width: 2),
        ),
      ),
    );
  }
}

class _PickerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceNavy,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.surfaceNavyLight),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryOrange, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VehicleTypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _VehicleTypeCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryOrange.withOpacity(0.15)
              : AppTheme.surfaceNavy,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryOrange : AppTheme.surfaceNavyLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryOrange : AppTheme.textSecondary,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color:
                    isSelected ? AppTheme.primaryOrange : AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckboxTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _CheckboxTile({
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: value
              ? AppTheme.primaryOrange.withOpacity(0.08)
              : AppTheme.surfaceNavy,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: value ? AppTheme.primaryOrange.withOpacity(0.4) : AppTheme.surfaceNavyLight,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryOrange, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppTheme.primaryOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
