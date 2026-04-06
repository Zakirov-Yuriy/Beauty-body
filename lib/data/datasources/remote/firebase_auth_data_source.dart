import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import 'remote_auth_data_source.dart';

class FirebaseAuthDataSource implements RemoteAuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDataSource({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Обновить display name
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();

      // Создать профиль в Firestore
      if (userCredential.user != null) {
        await createUserProfile(
          uid: userCredential.user!.uid,
          email: email,
          name: name,
        );
      }

      return _userFromFirebase(userCredential.user!);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebase(userCredential.user!);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<UserModel?> loginWithGoogle() async {
    // Реализуется позже
    return null;
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  UserModel? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    return user != null ? _userFromFirebase(user) : null;
  }

  @override
  Future<void> updateUserProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }
      await user.reload();

      // Обновить в Firestore тоже
      await _firestore.collection('users').doc(user.uid).update({
        if (displayName != null) 'displayName': displayName,
        if (photoUrl != null) 'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Stream<UserModel?> getAuthStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) {
      return user != null ? _userFromFirebase(user) : null;
    });
  }

  @override
  Future<void> createUserProfile({
    required String uid,
    required String email,
    required String name,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'displayName': name,
      'photoUrl': null,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<UserModel> getUserProfile({required String uid}) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    throw Exception('User profile not found');
  }

  /// Вспомогательный метод для преобразования Firebase User в UserModel
  UserModel _userFromFirebase(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
      updatedAt: user.metadata.lastSignInTime,
    );
  }
}
