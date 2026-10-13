// ============================================================================
// features/chat/providers/chat_provider.dart - Provider do Chat com Grok AI
// ============================================================================
// Integra a API Grok (xAI) para o assistente conversacional.
// Documentação: https://docs.x.ai/api
// ============================================================================

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// ── Modelo de Mensagem ────────────────────────────────────────────────────────

enum MessageRole { user, assistant }

class ChatMessage {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
  });
}

// ── Estado do Chat ────────────────────────────────────────────────────────────

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(const ChatState());

  /// Chave da API Grok (xAI) — substitua pela sua chave real
  /// ⚠️  Em produção, use flutter_secure_storage ou variáveis de ambiente
  static const String _apiKey = 'YOUR_GROK_API_KEY_HERE';
  static const String _apiUrl = 'https://api.x.ai/v1/chat/completions';
  static const String _model = 'grok-3-mini';

  /// System prompt que define o comportamento do assistente
  static const String _systemPrompt = '''
Você é o "Assistente InclusI", o assistente virtual do aplicativo InclusIMove.
O InclusIMove é um serviço de transporte especializado para idosos e pessoas com deficiência no Espírito Santo, Brasil.

Seu papel é:
1. Ajudar os usuários a agendar corridas e gerenciar viagens
2. Explicar como usar as funcionalidades do aplicativo
3. Informar sobre acessibilidade, veículos adaptados e cuidados especiais
4. Responder perguntas sobre o serviço de forma clara, gentil e acessível
5. Em casos de emergência, instruir o usuário a pressionar o botão SOS vermelho

IMPORTANTE:
- Responda SEMPRE em português brasileiro
- Use linguagem simples, clara e respeitosa
- Seja paciente e acolhedor, pois nosso público inclui idosos
- Para informações críticas de segurança, sempre recomende o botão SOS
- Não forneça informações médicas ou de saúde — recomende profissionais
''';

  /// Envia uma mensagem e obtém resposta do Grok
  Future<void> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    // Adiciona a mensagem do usuário
    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: userMessage.trim(),
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
      error: null,
    );

    try {
      // Monta o histórico de mensagens para contexto
      final messagesHistory = [
        {
          'role': 'system',
          'content': _systemPrompt,
        },
        // Inclui até as últimas 10 mensagens como contexto
        ...state.messages.take(10).map(
              (m) => {
                'role': m.role == MessageRole.user ? 'user' : 'assistant',
                'content': m.content,
              },
            ),
      ];

      // Chamada à API Grok
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messagesHistory,
          'max_tokens': 600,
          'temperature': 0.7,
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content =
            data['choices'][0]['message']['content'] as String? ??
                'Desculpe, não consegui entender. Tente novamente.';

        // Adiciona a resposta do assistente
        final assistantMsg = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: content.trim(),
          role: MessageRole.assistant,
          timestamp: DateTime.now(),
        );

        state = state.copyWith(
          messages: [...state.messages, assistantMsg],
          isLoading: false,
        );
      } else if (response.statusCode == 401) {
        _handleError(
          'Chave de API inválida. Contate o suporte.',
        );
      } else if (response.statusCode == 429) {
        _handleError(
          'Muitas solicitações. Aguarde alguns segundos e tente novamente.',
        );
      } else {
        _handleError(
          'Erro ao conectar ao assistente. Tente novamente.',
        );
      }
    } catch (e) {
      _handleError(
        'Sem conexão com a internet. Verifique sua rede e tente novamente.',
      );
    }
  }

  /// Adiciona mensagem de erro como resposta do assistente
  void _handleError(String errorMessage) {
    final errorMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: '⚠️ $errorMessage',
      role: MessageRole.assistant,
      timestamp: DateTime.now(),
    );
    state = state.copyWith(
      messages: [...state.messages, errorMsg],
      isLoading: false,
      error: errorMessage,
    );
  }

  /// Limpa todo o histórico de conversa
  void clearMessages() {
    state = const ChatState();
  }
}

/// Provider do chat
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});
