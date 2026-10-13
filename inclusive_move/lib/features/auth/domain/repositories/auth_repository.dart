// ============================================================================
// features/auth/domain/repositories/auth_repository.dart
// ============================================================================
// Contrato (interface) do repositório de autenticação — Clean Architecture.
// ============================================================================

import 'package:firebase_auth/firebase_auth.dart';

/// Interface que define as operações de autenticação disponíveis
abstract class AuthRepository {
  /// Realiza login com email e senha
  Future<User> signInWithEmail({
    required String email,
    required String password,
  });

  /// Cria uma nova conta com email, senha, nome e telefone
  Future<User> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
  });

  /// Realiza logout do usuário atual
  Future<void> signOut();

  /// Stream que emite o usuário atual (ou null)
  Stream<User?> get authStateChanges;

  /// Retorna o usuário autenticado atualmente (ou null)
  User? get currentUser;
}
