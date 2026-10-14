# 🚌 InclusIMove — Mobilidade com Dignidade

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.3+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Riverpod](https://img.shields.io/badge/Riverpod-2.5+-00BCD4?style=for-the-badge)
![Grok AI](https://img.shields.io/badge/Grok_AI-xAI-FF6B35?style=for-the-badge)

**Aplicativo de transporte especializado para idosos e pessoas com deficiência.**
*Projeto aprovado no Programa Centelha — Espírito Santo*

</div>

---

## 📱 Sobre o Projeto

O **InclusIMove** é um aplicativo mobile multiplataforma desenvolvido em Flutter que conecta idosos e pessoas com deficiências a motoristas especializados e veículos adaptados.

### ✨ Funcionalidades do MVP

| Funcionalidade | Status | Descrição |
|---|---|---|
| 🔐 Login / Cadastro | ✅ | Firebase Auth com email/senha |
| 🗺️ Mapa com localização | ✅ | Google Maps com dark style |
| 📅 Agendamento de corridas | ✅ | Data, hora, tipo de veículo |
| 📍 Destinos salvos | ✅ | Clínica, farmácia, mercados |
| 🤖 Chat com Grok AI | ✅ | Assistente 24/7 em português |
| 🎙️ Entrada por voz | ✅ | speech_to_text + TTS |
| 🆘 Botão SOS | ✅ | SAMU (192) + alertar família |
| 👨‍👩‍👧 Mensagens para família | ✅ | Notificações 1-to-many (FCM) |
| 📡 Rastreamento em tempo real | ✅ | Google Maps + info do motorista |
| 🌙 Dark Mode | ✅ | Tema escuro padrão |

---

## 🛠️ Stack Tecnológica

### Linguagem e Framework
- **Flutter 3.24+** — Framework multiplataforma (iOS, Android)
- **Dart 3.3+** — Linguagem fortemente tipada, null-safe

### Back-end e Banco de Dados
- **Firebase Auth** — Autenticação segura
- **Cloud Firestore** — Banco de dados NoSQL em tempo real
- **Firebase Storage** — Fotos de perfil e documentos
- **Firebase Cloud Messaging (FCM)** — Push notifications

### Mapas e Geolocalização
- **Google Maps Flutter** — Renderização de mapas nativo
- **Geolocator** — GPS e localização em tempo real
- **Geocoding** — Conversão endereço coordenadas

### Inteligência Artificial
- **Grok AI (xAI)** — LLM para o assistente conversacional
  - Endpoint: `https://api.x.ai/v1/chat/completions`
  - Modelo: `grok-3-mini`

### Gerenciamento de Estado
- **Riverpod 2.5** — Gerenciamento reativo e type-safe

### Navegação
- **GoRouter 14** — Roteamento declarativo com guards de auth

---

## 📁 Estrutura de Pastas

```
inclusive_move/
├── android/
├── ios/
├── web/
├── assets/
│   ├── images/
│   ├── icons/
│   ├── animations/
│   └── fonts/
├── lib/
│   ├── main.dart               # Ponto de entrada
│   ├── app.dart                # Widget raiz (MaterialApp)
│   ├── firebase_options.dart   # Configurações Firebase
│   │
│   ├── core/
│   │   ├── theme/app_theme.dart      # Design system
│   │   ├── router/app_router.dart    # GoRouter
│   │   ├── layout/main_shell.dart    # Bottom Nav + FAB SOS
│   │   ├── providers/
│   │   └── services/
│   │
│   └── features/
│       ├── auth/               # Login, cadastro, splash
│       │   ├── domain/         # Use Cases + interfaces
│       │   ├── data/           # Implementações Firebase
│       │   ├── providers/      # Riverpod providers
│       │   └── presentation/   # Pages + Widgets
│       ├── home/               # Dashboard principal
│       ├── booking/            # Agendamento de corridas
│       ├── chat/               # Chat com Grok AI
│       ├── saved_places/       # Destinos salvos
│       ├── family/             # Contatos familiares
│       ├── profile/            # Perfil do usuário
│       ├── sos/                # Emergência SOS
│       └── tracking/           # Rastreamento em tempo real
│
├── pubspec.yaml
└── README.md
```

---

## 🏛️ Arquitetura — Clean Architecture + Riverpod

```
┌─────────────────────────────────────────────────────────┐
│                   Presentation Layer                     │
│         Pages (Widgets) + Providers (Riverpod)          │
├─────────────────────────────────────────────────────────┤
│                    Domain Layer                          │
│         Use Cases + Repository Interfaces               │
│         (Regras de negócio puras, sem Flutter)          │
├─────────────────────────────────────────────────────────┤
│                     Data Layer                           │
│      Repository Implementations + Data Sources          │
│          (Firebase, APIs, SharedPreferences)            │
└─────────────────────────────────────────────────────────┘
```

### Exemplo de fluxo: Login

```
LoginPage (UI)
  → ref.read(authFormProvider.notifier).signInWithEmail()
    → SignInUseCase.call()
      → AuthRepository.signInWithEmail()  [interface]
        → AuthRepositoryImpl.signInWithEmail()  [Firebase]
```

---

## 🚀 Guia de Instalação Passo a Passo

### Pré-requisitos

```bash
# 1. Instalar Flutter SDK (versão estável)
# Windows: https://docs.flutter.dev/get-started/install/windows

# 2. Verificar instalação
flutter doctor
# Todos os itens devem estar com OK verde
```

### Passo 1 — Clonar e instalar dependências

```bash
git clone https://github.com/seu-usuario/inclusive_move.git
cd inclusive_move/inclusive_move
flutter pub get
```

### Passo 2 — Configurar Firebase

```bash
# Instalar Firebase CLI
npm install -g firebase-tools
firebase login

# Instalar FlutterFire CLI
dart pub global activate flutterfire_cli

# Criar projeto no Firebase Console: https://console.firebase.google.com
# Depois execute dentro da pasta do projeto:
flutterfire configure
# Isso gera automaticamente lib/firebase_options.dart com suas credenciais
```

**No Firebase Console, habilite:**
- Authentication → Email/Senha
- Cloud Firestore → Criar banco (modo teste)
- Firebase Storage
- Cloud Messaging

### Passo 3 — Configurar Google Maps

Acesse: https://console.cloud.google.com e ative:
- Maps SDK for Android
- Maps SDK for iOS
- Directions API / Geocoding API / Places API

**Android** — `android/app/src/main/AndroidManifest.xml`:
```xml
<application>
  <meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="SUA_CHAVE_AQUI"/>
</application>
```

**iOS** — `ios/Runner/AppDelegate.swift`:
```swift
import GoogleMaps
GMSServices.provideAPIKey("SUA_CHAVE_AQUI")
```

### Passo 4 — Configurar API Grok

1. Acesse: https://console.x.ai
2. Gere uma chave de API
3. Em `lib/features/chat/providers/chat_provider.dart`:

```dart
static const String _apiKey = 'xai-SUA_CHAVE_AQUI';
```

### Passo 5 — Permissões Android

Em `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.CALL_PHONE"/>
```

**iOS** — `ios/Runner/Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>O InclusIMove precisa da sua localização para encontrar corridas próximas.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Usado para comandos de voz no assistente InclusI.</string>
```

### Passo 6 — Executar

```bash
flutter devices          # listar dispositivos
flutter run              # executar em modo debug
flutter build apk        # gerar APK Android
flutter build ios        # gerar iOS (requer macOS)
```

---

## 🔍 Partes Fundamentais do Código

### 1. Ponto de Entrada (`main.dart`)

```dart
Future<void> main() async {
  // OBRIGATORIO antes de qualquer operacao async
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa Firebase com credenciais da plataforma
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    const ProviderScope(    // Container global do Riverpod
      child: InclusIMovApp(),
    ),
  );
}
```

### 2. Guard de Autenticação (`app_router.dart`)

```dart
// Stream reativo do Firebase Auth via Riverpod
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Guard no GoRouter — redireciona automaticamente
redirect: (context, state) {
  final isAuthenticated = authState.valueOrNull != null;
  if (!isAuthenticated && !isAuthRoute) return '/login';
  if (isAuthenticated && isAuthRoute)  return '/home';
  return null; // sem redirecionamento
}
```

### 3. Integração Grok AI (`chat_provider.dart`)

```dart
// Chamada REST para API Grok (xAI)
final response = await http.post(
  Uri.parse('https://api.x.ai/v1/chat/completions'),
  headers: {'Authorization': 'Bearer $_apiKey'},
  body: jsonEncode({
    'model': 'grok-3-mini',
    'messages': [
      {'role': 'system', 'content': _systemPrompt},
      ...historicoDeMensagens,  // Contexto das ultimas 10 msgs
    ],
    'temperature': 0.7,
  }),
);
```

### 4. Animações com flutter_animate

```dart
// Animacao encadeada declarativa
Container(child: Text('InclusIMove'))
  .animate(delay: 400.ms)
  .fadeIn(duration: 500.ms)
  .slideY(begin: 0.1, end: 0)
  .scale(begin: Offset(0.9, 0.9));

// Botao SOS pulsando em loop
Icon(Icons.emergency)
  .animate(onPlay: (c) => c.repeat(reverse: true))
  .scale(begin: Offset(1.0, 1.0), end: Offset(1.1, 1.1));
```

### 5. Riverpod StateNotifier (Auth Form)

```dart
class AuthFormNotifier extends StateNotifier<AuthFormState> {
  // Estado gerenciado: idle / loading / success / error
  
  Future<void> signInWithEmail({...}) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _signIn.call(email: email, password: password);
      state = state.copyWith(status: AuthStatus.success);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _mapFirebaseError(e.code), // traduz para PT-BR
      );
    }
  }
}
```

---

## 🎨 Paleta de Cores

| Cor | Hex | Uso |
|---|---|---|
| Laranja Principal | `#FF6B35` | Botões, ícones, destaques |
| Azul Escuro | `#0D1B3E` | Background principal |
| Azul Médio | `#1A2B52` | Cards e containers |
| Branco | `#FFFFFF` | Textos principais |
| Cinza | `#B0BEC5` | Textos secundários |
| Verde | `#4CAF50` | Sucesso, confirmado |
| Vermelho | `#F44336` | Erro, SOS |
| Amarelo | `#FFC107` | Aviso, agendado |

---

## 📄 Licença

MIT License

---

<div align="center">
  <strong>InclusIMove — Mobilidade com dignidade</strong>
</div>
