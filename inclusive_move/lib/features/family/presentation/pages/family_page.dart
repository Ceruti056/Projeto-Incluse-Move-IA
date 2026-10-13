// ============================================================================
// features/family/presentation/pages/family_page.dart - Contatos Familiares
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  static const List<Map<String, dynamic>> _contacts = [
    {
      'name': 'João Silva (Filho)',
      'phone': '(27) 99999-1111',
      'relation': 'Filho',
      'isEmergency': true,
    },
    {
      'name': 'Ana Paula (Filha)',
      'phone': '(27) 99999-2222',
      'relation': 'Filha',
      'isEmergency': true,
    },
    {
      'name': 'Dr. Carlos (Médico)',
      'phone': '(27) 99999-3333',
      'relation': 'Médico',
      'isEmergency': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundNavy,
      appBar: AppBar(title: const Text('Família e Contatos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Aviso informativo
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppTheme.primaryOrange.withOpacity(0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppTheme.primaryOrange,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Esses contatos receberão notificações durante suas viagens e em situações de emergência.',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),

            const SizedBox(height: 24),

            const Text(
              'Contatos Cadastrados',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ).animate(delay: 100.ms).fadeIn(),

            const SizedBox(height: 12),

            ..._contacts.asMap().entries.map((entry) {
              final i = entry.key;
              final contact = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ContactCard(contact: contact)
                    .animate(delay: Duration(milliseconds: 150 + i * 80))
                    .fadeIn()
                    .slideY(begin: 0.08),
              );
            }),

            const SizedBox(height: 24),

            // Botão mensagem em massa (1-to-many)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.surfaceNavy,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.surfaceNavyLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.broadcast_on_personal_rounded,
                        color: AppTheme.primaryOrange,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Mensagem em massa',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Envie uma mensagem para todos os seus contatos de uma vez.',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text('Enviar para todos'),
                    onPressed: () {/* TODO: notificação 1-to-many via FCM */},
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 46),
                    ),
                  ),
                ],
              ),
            ).animate(delay: 450.ms).fadeIn(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {/* TODO: adicionar contato */},
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Adicionar contato'),
        backgroundColor: AppTheme.primaryOrange,
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final Map<String, dynamic> contact;

  const _ContactCard({required this.contact});

  Future<void> _callContact(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final isEmergency = contact['isEmergency'] as bool;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceNavy,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isEmergency
              ? AppTheme.error.withOpacity(0.3)
              : AppTheme.surfaceNavyLight,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: AppTheme.primaryOrange.withOpacity(0.15),
            child: Text(
              (contact['name'] as String)[0],
              style: const TextStyle(
                color: AppTheme.primaryOrange,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      contact['name'] as String,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    if (isEmergency) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.error.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'SOS',
                          style: TextStyle(
                            color: AppTheme.error,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  contact['phone'] as String,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Botão ligar
          IconButton(
            icon: const Icon(Icons.phone_rounded),
            color: AppTheme.success,
            onPressed: () => _callContact(contact['phone'] as String),
          ),
          // Botão WhatsApp
          IconButton(
            icon: const Icon(Icons.message_rounded),
            color: AppTheme.primaryOrange,
            onPressed: () {/* TODO: abrir WhatsApp */},
          ),
        ],
      ),
    );
  }
}
