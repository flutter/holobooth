import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';

/// Thrown when signing in anonymously process fails.
class SignInAnonymouslyException implements Exception {}

/// {@template authentication_repository}
/// Repository which manages user authentication using Firebase Authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  const AuthenticationRepository({
    required firebase_auth.FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  final firebase_auth.FirebaseAuth _firebaseAuth;

  /// Logs in into the app as an anonymous user.
  ///
  /// Throws [SignInAnonymouslyException] when operation fails.
  Future<void> signInAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }

      throw SignInAnonymouslyException();
    }
  }
}
