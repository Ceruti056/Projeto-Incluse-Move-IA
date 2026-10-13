// ============================================================================
// features/auth/domain/usecases/sign_in_usecase.dart
// ============================================================================

import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _repository;
  SignInUseCase(this._repository);

  Future<User> call({required String email, required String password}) {
    return _repository.signInWithEmail(email: email, password: password);
  }
}
