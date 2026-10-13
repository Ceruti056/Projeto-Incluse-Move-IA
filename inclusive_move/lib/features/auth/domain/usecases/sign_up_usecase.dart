// ============================================================================
// features/auth/domain/usecases/sign_up_usecase.dart
// ============================================================================

import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;
  SignUpUseCase(this._repository);

  Future<User> call({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    return _repository.signUpWithEmail(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );
  }
}
