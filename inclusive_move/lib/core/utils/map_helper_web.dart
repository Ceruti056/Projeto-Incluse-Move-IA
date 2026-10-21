// ============================================================================
// core/utils/map_helper_web.dart
// ============================================================================
// No Flutter Web, verifica de forma segura se window.google.maps está carregado.
// Evita o TypeError: Cannot read properties of undefined (reading 'maps').
// ============================================================================

import 'dart:js_interop';

@JS('google.maps')
external JSAny? get _googleMaps;

bool checkGoogleMapsReady() {
  try {
    return _googleMaps != null;
  } catch (_) {
    return false;
  }
}
