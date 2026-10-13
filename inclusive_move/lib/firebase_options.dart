// ============================================================================
// firebase_options.dart - Configurações do Firebase (gerado pelo FlutterFire CLI)
// ============================================================================
// ⚠️ ATENÇÃO: Este arquivo é um PLACEHOLDER.
// Você DEVE substituí-lo executando:
//   dart pub global activate flutterfire_cli
//   flutterfire configure
// Isso gerará este arquivo com as credenciais reais do seu projeto Firebase.
// ============================================================================

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError('macOS não configurado.');
      case TargetPlatform.windows:
        throw UnsupportedError('Windows não configurado.');
      case TargetPlatform.linux:
        throw UnsupportedError('Linux não configurado.');
      default:
        throw UnsupportedError('Plataforma não suportada.');
    }
  }

  // ── SUBSTITUA COM SUAS CREDENCIAIS REAIS DO FIREBASE CONSOLE ────────────────
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '[GCP_API_KEY]',
    appId: '1:497670703900:android:56b0440f303710d527e517',
    messagingSenderId: '497670703900',
    projectId: 'inclusimove-ia',
    storageBucket: 'inclusimove-ia.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: '[GCP_API_KEY]',
    appId: '1:497670703900:ios:024b128f1220a74f27e517',
    messagingSenderId: '497670703900',
    projectId: 'inclusimove-ia',
    storageBucket: 'inclusimove-ia.firebasestorage.app',
    iosClientId: '497670703900-3p108a75g3f080i73v08h83v8tqvj5g2.apps.googleusercontent.com',
    iosBundleId: 'com.inclusimove.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: '[GCP_API_KEY]',
    appId: '1:497670703900:web:f0d91139225e818427e517',
    messagingSenderId: '497670703900',
    projectId: 'inclusimove-ia',
    storageBucket: 'inclusimove-ia.firebasestorage.app',
    authDomain: 'inclusimove-ia.firebaseapp.com',
  );
}
