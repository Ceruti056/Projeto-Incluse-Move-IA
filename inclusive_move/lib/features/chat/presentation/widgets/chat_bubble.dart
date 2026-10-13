// ============================================================================
// features/chat/presentation/widgets/chat_bubble.dart - Bolha de Chat
// ============================================================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/chat_provider.dart';

/// Bolha de mensagem no chat
class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  bool get _isUser => message.role == MessageRole.user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            _isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!_isUser) ...[
            // Avatar do assistente
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: AppTheme.primaryOrange,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
          ],

          // Conteúdo da bolha
          Flexible(
            child: Column(
              crossAxisAlignment: _isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _isUser
                        ? AppTheme.primaryOrange
                        : AppTheme.surfaceNavy,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: _isUser
                          ? const Radius.circular(18)
                          : const Radius.circular(4),
                      bottomRight: _isUser
                          ? const Radius.circular(4)
                          : const Radius.circular(18),
                    ),
                    border: !_isUser
                        ? Border.all(color: AppTheme.surfaceNavyLight)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: (_isUser
                                ? AppTheme.primaryOrange
                                : Colors.black)
                            .withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color: _isUser ? AppTheme.white : AppTheme.textPrimary,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('HH:mm').format(message.timestamp),
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          if (_isUser) const SizedBox(width: 10),
        ],
      ),
    );
  }
}
