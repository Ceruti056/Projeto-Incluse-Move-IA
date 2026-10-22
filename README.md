# 🚌 InclusIMove — Mobilidade com Dignidade

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.3+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Riverpod](https://img.shields.io/badge/Riverpod-2.5+-00BCD4?style=for-the-badge)
![Grok AI](https://img.shields.io/badge/Grok_AI-xAI-FF6B35?style=for-the-badge)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)

**Aplicativo de transporte especializado para idosos e pessoas com deficiência.**  
_Projeto aprovado no Programa Centelha — Espírito Santo_

</div>

---

## 📱 Sobre o Projeto

O **InclusIMove** é um aplicativo mobile e web multiplataforma desenvolvido em Flutter que conecta idosos e pessoas com deficiência (PcD) a motoristas especializados e veículos adaptados, oferecendo uma experiência segura, assistida e de alta acessibilidade.

### ✨ Funcionalidades do MVP

| Funcionalidade                | Status | Descrição                                                       |
| ----------------------------- | :----: | --------------------------------------------------------------- |
| 🧪 **Modo Teste / Convidado** |   ✅   | Acesso imediato a todas as telas sem exigir cadastro prévio     |
| 🔐 Login / Cadastro           |   ✅   | Autenticação Firebase com email/senha e tratamento de erros     |
| 🗺️ Mapa com localização       |   ✅   | Google Maps integrado com tema escuro e geolocalização          |
| 📅 Agendamento de corridas    |   ✅   | Seleção de data, horário, tipo de veículo adaptado e bagagens   |
| 📍 Destinos salvos            |   ✅   | Atalhos rápidos para clínicas, hospitais, farmácias e mercados   |
| 🤖 Chat com Grok AI           |   ✅   | Assistente virtual inteligente xAI 24/7 com suporte a voz       |
| 🎙️ Entrada e saída por voz    |   ✅   | Acessibilidade total via `speech_to_text` e `flutter_tts`       |
| 🆘 Botão SOS de Emergência    |   ✅   | Ligação direta para SAMU (192) e disparo de alerta para contatos|
| 👨‍👩‍👧 Rede da Família           |   ✅   | Compartilhamento de trajeto e status da corrida em tempo real   |
| 📡 Rastreamento da corrida    |   ✅   | Acompanhamento ao vivo do motorista com estimativa de chegada   |
| 🌙 Temas Claro / Escuro       |   ✅   | Design system adaptativo com alto contraste e tipografia fluida |

---

## 🛠️ Stack Tecnológica

- **Linguagem & Framework:** Flutter 3.24+ | Dart 3.3+ (multiplataforma: Android, iOS e Web)
- **Gerenciamento de Estado:** Flutter Riverpod 2.5 (reativo e imutável)
- **Roteamento:** GoRouter 14 (navegação declarativa com guards de autenticação)
- **Back-end & Nuvem:** Firebase Auth, Cloud Firestore, Firebase Storage e FCM
- **Geolocalização:** Google Maps Flutter, Geolocator e Geocoding
- **Inteligência Artificial:** Grok AI (`grok-3-mini` via xAI REST API)
- **Estilização & UX:** Google Fonts (Inter), `flutter_animate` e ícones Material Rounded
- **Containerização:** Docker (multi-stage build) + Nginx Alpine para Flutter Web

---

## 📁 Estrutura do Repositório

```text
Projeto-Incluse-Move-IA/
├── Dockerfile                  # Build multi-stage para Flutter Web + Nginx
├── docker-compose.yml          # Orquestração do container Web (porta 8081)
├── .dockerignore               # Otimização de build do Docker
├── docs/                       # Documentação técnica e de negócio
│
└── inclusive_move/             # Projeto Flutter
    ├── android/                # Configurações nativas Android
    ├── ios/                    # Configurações nativas iOS
    ├── web/                    # Configurações web nativas
    ├── assets/                 # Imagens, animações e recursos
    ├── pubspec.yaml            # Dependências e assets do app
    └── lib/
        ├── main.dart           # Ponto de entrada e inicializações
        ├── app.dart            # Widget raiz (MaterialApp.router + tema)
        ├── firebase_options.dart # Credenciais por plataforma
        │
        ├── core/               # Módulos transversais
        │   ├── theme/          # Design system e tokens de cores
        │   ├── router/         # GoRouter, rotas e controle de sessão
        │   ├── layout/         # Shell de navegação e FAB SOS
        │   ├── providers/      # Provedores globais (tema, etc.)
        │   └── services/       # Notificações e utilitários
        │
        └── features/           # Módulos organizados em Clean Architecture
            ├── auth/           # Login, cadastro, splash e Modo Teste
            ├── home/           # Dashboard principal e ações rápidas
            ├── booking/        # Fluxo de agendamento de corridas
            ├── chat/           # Assistente virtual com Grok AI
            ├── saved_places/   # Gerenciamento de destinos favoritos
            ├── family/         # Contatos de emergência e familiares
            ├── sos/            # Central de socorro e discagem rápida
            ├── profile/        # Gestão de perfil e preferências
            └── tracking/       # Acompanhamento de viagem em tempo real
```

---

## 🚀 Como Executar o Projeto

### Opção 1: Execução Local com Flutter (Recomendado para Desenvolvimento)

#### 1. Pré-requisitos
- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado e validado (`flutter doctor`).

#### 2. Instalação e Execução
```powershell
# 1. Clone o repositório
git clone https://github.com/Ceruti056/Projeto-Incluse-Move-IA.git
cd Projeto-Incluse-Move-IA/inclusive_move

# 2. Instale as dependências
flutter pub get

# 3. Execute no dispositivo desejado
flutter run -d chrome    # Para navegador
flutter run -d windows   # Para aplicativo Windows
flutter run              # Para emulador Android/iOS conectado
```

> [!TIP]
> **Modo Teste (Sem Cadastro):**  
> Na tela inicial de login, clique no botão **`Acessar em Modo Teste (Sem cadastro)`** para navegar por todas as funcionalidades sem precisar cadastrar email ou configurar chaves externas imediatamente.

---

### Opção 2: Execução via Docker (Flutter Web em Produção)

Para rodar a versão Web empacotada em um servidor Nginx leve e otimizado:

```powershell
# Na raiz do projeto (onde está o docker-compose.yml):
docker compose up -d --build
```
Acesse o aplicativo em seu navegador em: **`http://localhost:8081`**

Para parar o container:
```powershell
docker compose down
```

---

## ⚙️ Configurações Opcionais de Serviços Externos

Caso deseje ativar os serviços em nuvem reais em vez de usar o modo de teste:

### 1. Firebase (Auth & Firestore)
Instale o FlutterFire CLI e gere seu [firebase_options.dart](file:///c:/Users/Gabriel/Desktop/project_inmove_ia/Projeto-Incluse-Move-IA/inclusive_move/lib/firebase_options.dart):
```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
cd inclusive_move
flutterfire configure
```
Habilite no console do Firebase:
- **Authentication:** Provedor Email/Senha
- **Cloud Firestore:** Modo de teste
- **Cloud Messaging:** Para notificações push

### 2. Google Maps API
Obtenha uma chave no [Google Cloud Console](https://console.cloud.google.com) (ativando SDKs de Maps para Android/iOS e Directions API):
- **Android:** Configure em `inclusive_move/android/app/src/main/AndroidManifest.xml` na tag `com.google.android.geo.API_KEY`.
- **iOS:** Configure em `inclusive_move/ios/Runner/AppDelegate.swift`.

### 3. Grok AI (xAI)
Para ativar respostas reais do assistente inteligente:
1. Obtenha sua API Key em [console.x.ai](https://console.x.ai).
2. Configure a constante em `lib/features/chat/providers/chat_provider.dart`.

---

## 🏛️ Arquitetura do Software

O projeto segue os princípios da **Clean Architecture** com **Riverpod**:

```text
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                      │
│       Widgets, Pages, Controllers e Notifiers Riverpod      │
├─────────────────────────────────────────────────────────────┤
│                        Domain Layer                         │
│            Use Cases, Entidades e Interfaces Puras          │
├─────────────────────────────────────────────────────────────┤
│                         Data Layer                          │
│     Implementações de Repositório, Firebase e APIs REST     │
└─────────────────────────────────────────────────────────────┘
```

- **Guarda de Rotas Híbrida (`app_router.dart`):** Observa o estado da sessão do Firebase Auth em sincronia com o `isGuestModeProvider`, permitindo alternar de forma transparente entre o modo de visitante e usuários reais.
- **Injeção de Dependências:** Providers declarativos do Riverpod desacoplam a lógica de negócio dos componentes visuais.

---

## 📄 Licença

Distribuído sob a licença MIT. Consulte o arquivo de licença para mais detalhes.

<div align="center">
  <strong>InclusIMove • Mobilidade, Autonomia e Dignidade para Todos</strong>
</div>
