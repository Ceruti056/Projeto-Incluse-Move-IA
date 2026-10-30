// ============================================================================
// features/auth/providers/auth_provider.dart - Providers de Autenticação
// ============================================================================
// Usa Riverpod para expor estado do Firebase Auth de forma reativa.
// ============================================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/sign_in_usecase.dart';
import '../domain/usecases/sign_up_usecase.dart';
import '../domain/usecases/sign_out_usecase.dart';

/// Indica que a sessao atual esta usando o acesso local de demonstracao.
final isGuestModeProvider = StateProvider<bool>((ref) => false);

// ── Repository ───────────────────────────────────────────────────────────────

/// Provider do repositório de autenticação
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(FirebaseAuth.instance);
});

// ── Use Cases ─────────────────────────────────────────────────────────────────

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  return SignUpUseCase(ref.watch(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
});

// ── Estado de Autenticação (Stream) ───────────────────────────────────────────

/// Stream reativo que emite o usuário atual (ou null se não autenticado)
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// Provider do usuário atual (não-nulo — use apenas em rotas protegidas)
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});

// ── Notifier de Formulário de Auth ────────────────────────────────────────────

/// Estado da operação de autenticação (login/cadastro)
enum AuthStatus { idle, loading, success, error }

class AuthFormState {
  final AuthStatus status;
  final String? errorMessage;

  const AuthFormState({
    this.status = AuthStatus.idle,
    this.errorMessage,
  });

  AuthFormState copyWith({AuthStatus? status, String? errorMessage}) {
    return AuthFormState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Notifier que gerencia o estado dos formulários de login/cadastro
class AuthFormNotifier extends StateNotifier<AuthFormState> {
  final SignInUseCase _signIn;
  final SignUpUseCase _signUp;
  final SignOutUseCase _signOut;

  AuthFormNotifier({
    required SignInUseCase signIn,
    required SignUpUseCase signUp,
    required SignOutUseCase signOut,
  })  : _signIn = signIn,
        _signUp = signUp,
        _signOut = signOut,
        super(const AuthFormState());

  /// Faz login com email e senha
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _signIn.call(email: email, password: password);
      state = state.copyWith(status: AuthStatus.success);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _mapFirebaseError(e.code),
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Erro inesperado. Tente novamente.',
      );
    }
  }

  /// Cria nova conta com email e senha
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _signUp.call(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      state = state.copyWith(status: AuthStatus.success);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _mapFirebaseError(e.code),
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Erro inesperado. Tente novamente.',
      );
    }
  }

  /// Faz logout
  Future<void> signOut() async {
    await _signOut.call();
    state = const AuthFormState();
  }

  /// Traduz códigos de erro do Firebase para mensagens em português
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Usuário não encontrado. Verifique o email.';
      case 'wrong-password':
        return 'Senha incorreta. Tente novamente.';
      case 'email-already-in-use':
        return 'Este email já está cadastrado.';
      case 'weak-password':
        return 'Senha muito fraca. Use pelo menos 6 caracteres.';
      case 'invalid-email':
        return 'Email inválido. Verifique o formato.';
      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde alguns minutos.';
      case 'network-request-failed':
        return 'Sem conexão com a internet.';
      default:
        return 'Erro de autenticação. Tente novamente.';
    }
  }
}

/// Provider do notifier de formulário de auth
final authFormProvider =
    StateNotifierProvider<AuthFormNotifier, AuthFormState>((ref) {
  return AuthFormNotifier(
    signIn: ref.watch(signInUseCaseProvider),
    signUp: ref.watch(signUpUseCaseProvider),
    signOut: ref.watch(signOutUseCaseProvider),
  );
});
