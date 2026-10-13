// ============================================================================
// features/chat/presentation/widgets/voice_input_button.dart
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';

/// Botão animado de entrada por voz para o chat
class VoiceInputButton extends StatelessWidget {
  final bool isListening;
  final VoidCallback onTap;

  const VoiceInputButton({
    super.key,
    required this.isListening,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isListening
              ? AppTheme.error.withOpacity(0.15)
              : AppTheme.surfaceBorderLight,
          shape: BoxShape.circle,
          border: Border.all(
            color: isListening ? AppTheme.error : AppTheme.surfaceBorder,
            width: 1.5,
          ),
        ),
        child: Icon(
          isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
          color: isListening ? AppTheme.error : AppTheme.textSecondary,
          size: 22,
        ),
      ).animate(target: isListening ? 1 : 0).scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.1, 1.1),
            duration: 600.ms,
            curve: Curves.easeInOut,
          ),
    );
  }
}
