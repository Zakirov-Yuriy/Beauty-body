import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beauty_body/data/datasources/remote/firebase_auth_data_source.dart';
import 'package:beauty_body/data/repositories/auth_repository_impl.dart';
import 'package:beauty_body/domain/repositories/auth_repository.dart';

/// Firebase Auth провайдер
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Firestore провайдер
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// RemoteAuthDataSource провайдер
final remoteAuthDataSourceProvider = Provider<FirebaseAuthDataSource>((ref) {
  return FirebaseAuthDataSource(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
  );
});

/// AuthRepository провайдер (Dependency Injection)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(remoteAuthDataSourceProvider),
  );
});
