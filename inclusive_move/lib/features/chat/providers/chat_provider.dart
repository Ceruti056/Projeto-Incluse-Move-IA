// ============================================================================
// features/chat/providers/chat_provider.dart - Provider do Chat com Groq Cloud AI
// ============================================================================
// Integra a API Groq Cloud (Llama 3.3 70B Versatile) para o assistente conversacional.
// Documentação: https://console.groq.com/docs/overview
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

  /// Chave da API Groq Cloud (https://console.groq.com/)
  /// Suporta tanto GROQ_API_KEY quanto GROK_API_KEY para compatibilidade
  static const String _envGroqKey = String.fromEnvironment('GROQ_API_KEY');
  static const String _envGrokKey = String.fromEnvironment('GROK_API_KEY');

  static String get _apiKey {
    if (_envGroqKey.isNotEmpty && !_envGroqKey.startsWith('YOUR_')) {
      return _envGroqKey;
    }
    if (_envGrokKey.isNotEmpty && !_envGrokKey.startsWith('YOUR_')) {
      return _envGrokKey;
    }
    return '';
  }

  /// URL da API Groq Cloud
  static const String _apiUrl = String.fromEnvironment(
    'GROQ_API_URL',
    defaultValue: 'https://api.groq.com/openai/v1/chat/completions',
  );

  /// Modelo padrão solicitado: Llama 3.3 70B Versatile
  static const String _model = String.fromEnvironment(
    'GROQ_MODEL',
    defaultValue: 'llama-3.3-70b-versatile',
  );

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

  /// Envia uma mensagem e obtém resposta do Groq Cloud (Llama 3.3 70B Versatile)
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

    // Validação preventiva da chave da API
    if (_apiKey.isEmpty) {
      _handleError(
        'Sua chave da API Groq ainda não foi configurada! Abra o arquivo .env e cole sua chave real (ex: gsk_...) no campo GROQ_API_KEY.',
      );
      return;
    }

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

      // Chamada à API Groq Cloud (formato OpenAI-compatible)
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messagesHistory,
          'max_tokens': 1024,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'] as String? ??
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
          'Chave da API Groq inválida. Verifique sua chave no arquivo .env (https://console.groq.com/keys).',
        );
      } else if (response.statusCode == 429) {
        _handleError(
          'Limite de requisições excedido no Groq Cloud. Aguarde alguns instantes e tente novamente.',
        );
      } else {
        String errorMessage =
            'Erro ao conectar ao assistente (${response.statusCode}).';
        try {
          final errorData = jsonDecode(utf8.decode(response.bodyBytes));
          if (errorData is Map) {
            final err = errorData['error'];
            if (err is Map && err['message'] != null) {
              errorMessage = err['message'].toString();
            } else if (err is String) {
              errorMessage = err;
            }
          }
        } catch (_) {}
        _handleError(errorMessage);
      }
    } catch (e) {
      _handleError(
        'Erro de conexão com o assistente Groq. Verifique sua rede e tente novamente.',
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
