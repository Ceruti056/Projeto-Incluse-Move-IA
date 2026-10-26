// ============================================================================
// features/chat/presentation/pages/chat_page.dart - Chat com Grok AI
// ============================================================================
// Assistente de IA usando a API Grok (xAI) via HTTP.
// Suporta entrada por texto e por voz (speech_to_text).
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../providers/chat_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/voice_input_button.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _speechToText = SpeechToText();
  final _flutterTts = FlutterTts();

  bool _isListening = false;
  bool _speechAvailable = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initTts();
  }

  /// Inicializa reconhecimento de voz
  Future<void> _initSpeech() async {
    _speechAvailable = await _speechToText.initialize(
      onStatus: (status) {
        if (status == 'done') {
          setState(() => _isListening = false);
        }
      },
      onError: (error) => setState(() => _isListening = false),
    );
    setState(() {});
  }

  /// Inicializa sintetizador de voz (TTS)
  Future<void> _initTts() async {
    await _flutterTts.setLanguage('pt-BR');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  /// Inicia/para reconhecimento de voz
  Future<void> _toggleListening() async {
    if (!_speechAvailable) return;

    if (_isListening) {
      await _speechToText.stop();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      await _speechToText.listen(
        onResult: (result) {
          _messageController.text = result.recognizedWords;
          _messageController.selection = TextSelection.fromPosition(
            TextPosition(offset: _messageController.text.length),
          );
        },
        localeId: 'pt_BR',
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
      );
    }
  }

  /// Envia mensagem de texto
  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    await ref.read(chatProvider.notifier).sendMessage(text);

    // Scrolla para o final
    await Future.delayed(const Duration(milliseconds: 100));
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _speechToText.cancel();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundNavy,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: AppTheme.primaryOrange,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Assistente InclusI',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  chatState.isLoading ? 'Digitando...' : 'Online',
                  style: TextStyle(
                    fontSize: 12,
                    color: chatState.isLoading
                        ? AppTheme.warning
                        : AppTheme.success,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: 'Limpar conversa',
            onPressed: () => ref.read(chatProvider.notifier).clearMessages(),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Lista de mensagens ───────────────────────────────────────────
          Expanded(
            child: chatState.messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: chatState.messages.length +
                        (chatState.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == chatState.messages.length) {
                        // Indicador de digitação
                        return const _TypingIndicator();
                      }
                      final message = chatState.messages[index];
                      return ChatBubble(message: message)
                          .animate()
                          .fadeIn(duration: 300.ms)
                          .slideY(begin: 0.1, end: 0);
                    },
                  ),
          ),

          // ── Área de entrada ──────────────────────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              MediaQuery.of(context).padding.bottom + 12,
            ),
            decoration: const BoxDecoration(
              color: AppTheme.surfaceNavy,
              border: Border(
                top: BorderSide(color: AppTheme.surfaceNavyLight, width: 1),
              ),
            ),
            child: Row(
              children: [
                // Botão de voz
                VoiceInputButton(
                  isListening: _isListening,
                  onTap: _toggleListening,
                ),

                const SizedBox(width: 10),

                // Campo de texto
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(
                        color: AppTheme.textPrimary, fontSize: 15),
                    maxLines: 4,
                    minLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: _isListening
                          ? '🎙️ Ouvindo...'
                          : 'Digite sua pergunta...',
                      hintStyle: TextStyle(
                        color: _isListening
                            ? AppTheme.primaryOrange
                            : AppTheme.textSecondary,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      filled: true,
                      fillColor: AppTheme.backgroundNavy,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: AppTheme.surfaceNavyLight,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: AppTheme.primaryOrange,
                          width: 1.5,
                        ),
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),

                const SizedBox(width: 10),

                // Botão enviar
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: GestureDetector(
                    onTap: chatState.isLoading ? null : _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: chatState.isLoading
                            ? AppTheme.textSecondary
                            : AppTheme.primaryOrange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: AppTheme.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.smart_toy_outlined,
              size: 72,
              color: AppTheme.primaryOrange,
            ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.08, 1.08),
                  duration: 2.seconds,
                  curve: Curves.easeInOut,
                ),
            const SizedBox(height: 20),
            const Text(
              'Olá! Sou o Assistente InclusI 🤖',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Posso te ajudar com:\n• Agendar suas corridas\n• Dúvidas sobre o aplicativo\n• Informações de acessibilidade\n• Suporte geral',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 24),
            // Sugestões de perguntas
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                'Como agendar uma corrida?',
                'Quais veículos são adaptados?',
                'Como adicionar contatos familiares?',
                'O app funciona sem internet?',
              ]
                  .map(
                    (suggestion) => GestureDetector(
                      onTap: () {
                        _messageController.text = suggestion;
                        _sendMessage();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceNavy,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                AppTheme.primaryOrange.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          suggestion,
                          style: const TextStyle(
                            color: AppTheme.primaryOrange,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Indicador de "digitando..." animado
class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: AppTheme.primaryOrange,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceNavy,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              border: Border.all(color: AppTheme.surfaceNavyLight),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppTheme.textSecondary,
                    shape: BoxShape.circle,
                  ),
                )
                    .animate(delay: Duration(milliseconds: i * 200))
                    .then(delay: const Duration(milliseconds: 300))
                    .moveY(
                      begin: 0,
                      end: -6,
                      duration: 400.ms,
                      curve: Curves.easeInOut,
                    )
                    .then()
                    .moveY(
                      begin: -6,
                      end: 0,
                      duration: 400.ms,
                      curve: Curves.easeInOut,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
