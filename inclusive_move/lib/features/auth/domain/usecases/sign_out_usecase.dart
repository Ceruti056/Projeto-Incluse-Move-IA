// ============================================================================
// features/auth/domain/usecases/sign_out_usecase.dart
// ============================================================================

import '../repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _repository;
  SignOutUseCase(this._repository);

  Future<void> call() => _repository.signOut();
}
