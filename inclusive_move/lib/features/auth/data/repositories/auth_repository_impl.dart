// ============================================================================
// features/auth/data/repositories/auth_repository_impl.dart
// ============================================================================
// Implementação concreta do AuthRepository usando Firebase Auth + Firestore.
// ============================================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._firebaseAuth)
      : _firestore = FirebaseFirestore.instance;

  @override
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return credential.user!;
  }

  @override
  Future<User> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    // Cria a conta no Firebase Auth
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user!;

    // Atualiza o displayName
    await user.updateDisplayName(name);

    // Salva dados extras no Firestore
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': name,
      'email': email.trim(),
      'phone': phone,
      'profileImageUrl': null,
      'accessibilityNeeds': [],
      'savedPlaces': [],
      'familyContacts': [],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return user;
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;
}
