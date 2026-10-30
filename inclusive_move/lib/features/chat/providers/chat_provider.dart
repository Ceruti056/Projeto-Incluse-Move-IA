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

  /// Controle de taxa para não estourar o limite gratuito (RPM/TPM)
  DateTime? _lastRequestTime;

  static const String _apiKey = String.fromEnvironment('GROK_API_KEY');

  /// URL da API Groq Cloud
  static String get _apiUrl {
    const urlK = String.fromEnvironment('GROK_API_URL');
    if (urlK.isNotEmpty) return urlK;
    return 'https://api.groq.com/openai/v1/chat/completions';
  }

  /// Modelo padrão solicitado: openai/gpt-oss-120b
  static String get _model {
    const modelK = String.fromEnvironment('GROK_MODEL');
    if (modelK.isNotEmpty) return modelK;
    return 'openai/gpt-oss-120b';
  }

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
- Seja CONCISO e OBJETIVO (no máximo 2 ou 3 parágrafos curtos) para economizar tokens
- Use linguagem simples, clara e respeitosa
- Seja paciente e acolhedor, pois nosso público inclui idosos
- Para informações críticas de segurança, sempre recomende o botão SOS
- Não forneça informações médicas ou de saúde — recomende profissionais
''';

  /// Envia uma mensagem e obtém resposta do Groq Cloud (Llama 3.3 70B Versatile)
  /// Envia uma mensagem e obtém resposta do Groq Cloud usando openai/gpt-oss-120b com stream
  Future<void> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    // Evita requisições sobrepostas
    if (state.isLoading) return;

    // Cooldown de 2s para evitar ultrapassar 30 RPM
    final now = DateTime.now();
    if (_lastRequestTime != null &&
        now.difference(_lastRequestTime!) < const Duration(seconds: 2)) {
      return;
    }
    _lastRequestTime = now;

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
        'Sua chave da API Groq ainda não foi configurada!',
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
        ...(state.messages.length > 4
                ? state.messages.sublist(state.messages.length - 4)
                : state.messages)
            .map(
          (m) => {
            'role': m.role == MessageRole.user ? 'user' : 'assistant',
            'content': m.content,
          },
        ),
      ];

      // Requisição para Groq Cloud com streaming e parâmetros do modelo openai/gpt-oss-120b
      final client = http.Client();
      final request = http.Request('POST', Uri.parse(_apiUrl))
        ..headers.addAll({
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'Accept': 'text/event-stream',
        })
        ..body = jsonEncode({
          'model': _model,
          'messages': messagesHistory,
          'temperature': 0.7,
          'max_completion_tokens': 512,
          'top_p': 0.9,
          'stream': true,
          'reasoning_effort': 'low',
          'stop': null,
        });

      final streamedResponse = await client.send(request);

      if (streamedResponse.statusCode == 200) {
        String accumulatedContent = '';
        final assistantId = DateTime.now().millisecondsSinceEpoch.toString();

        await for (final line in streamedResponse.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter())) {
          final trimmed = line.trim();
          if (trimmed.isEmpty) continue;
          if (trimmed == 'data: [DONE]') break;
          if (trimmed.startsWith('data: ')) {
            try {
              final jsonStr = trimmed.substring(6);
              final data = jsonDecode(jsonStr);
              final delta = data['choices']?[0]?['delta'];
              final chunk = delta?['content'] as String?;
              if (chunk != null && chunk.isNotEmpty) {
                accumulatedContent += chunk;
                _updateOrAddAssistantMessage(assistantId, accumulatedContent);
              }
            } catch (_) {}
          }
        }

        if (accumulatedContent.isEmpty) {
          _updateOrAddAssistantMessage(
            assistantId,
            'Desculpe, não consegui entender. Tente novamente.',
          );
        } else {
          state = state.copyWith(isLoading: false);
        }
      } else if (streamedResponse.statusCode == 401) {
        _handleError(
          'Chave da API Groq inválida. Verifique sua chave no arquivo .env (https://console.groq.com/keys).',
        );
      } else if (streamedResponse.statusCode == 429) {
        _handleError(
          'Limite de requisições excedido no Groq Cloud. Aguarde alguns instantes e tente novamente.',
        );
      } else {
        final errorBytes = await streamedResponse.stream.toBytes();
        String errorMessage =
            'Erro ao conectar ao assistente (${streamedResponse.statusCode}).';
        try {
          final errorData = jsonDecode(utf8.decode(errorBytes));
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

  /// Atualiza uma mensagem existente em streaming ou adiciona uma nova
  void _updateOrAddAssistantMessage(String id, String content) {
    final existingIndex = state.messages.indexWhere((m) => m.id == id);
    final msg = ChatMessage(
      id: id,
      content: content.trimLeft(),
      role: MessageRole.assistant,
      timestamp: DateTime.now(),
    );

    if (existingIndex >= 0) {
      final updatedList = List<ChatMessage>.from(state.messages);
      updatedList[existingIndex] = msg;
      state = state.copyWith(messages: updatedList, isLoading: false);
    } else {
      state = state.copyWith(
        messages: [...state.messages, msg],
        isLoading: false,
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
