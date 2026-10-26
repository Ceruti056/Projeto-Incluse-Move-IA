// ============================================================================
// main.dart - Ponto de entrada do aplicativo InclusIMove
// ============================================================================
// Inicializa Firebase, configura Riverpod e inicia o app.
// ============================================================================

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/services/notification_service.dart';
import 'firebase_options.dart';

/// Função principal assíncrona - inicializa serviços antes de rodar o app
Future<void> main() async {
  // Garante que os widgets do Flutter estejam inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase com as opções geradas pelo FlutterFire CLI
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Aviso: Firebase não pôde ser inicializado nesta plataforma: $e');
  }

  // Configura notificações locais
  try {
    await NotificationService.initialize();
  } catch (e) {
    debugPrint('Aviso: Notificações não puderam ser inicializadas nesta plataforma: $e');
  }

  // Força orientação retrato para melhor acessibilidade
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configura a aparência da barra de status (transparente / dark icons)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Inicializa o ProviderScope (Riverpod) envolvendo todo o app
  runApp(
    const ProviderScope(
      child: InclusIMovApp(),
    ),
  );
}
