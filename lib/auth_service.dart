import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart' as gAuth;
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final gAuth.GoogleSignIn _googleSignIn = gAuth.GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;

  // Stream to listen to authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // 1. Email & Password Sign Up
  Future<UserCredential?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // 2. Email & Password Login
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // 3. Google Sign-In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (!_isGoogleSignInInitialized) {
        await _googleSignIn.initialize();
        _isGoogleSignInInitialized = true;
      }

      // Trigger the authentication flow
      final gAuth.GoogleSignInAccount googleUser = await _googleSignIn
          .authenticate(scopeHint: ['email', 'profile']);

      // Obtain the ID token details from the request
      final gAuth.GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      // Obtain the authorization details to get the access token
      final gAuth.GoogleSignInClientAuthorization authz =
          await googleUser.authorizationClient.authorizationForScopes([
            'email',
            'profile',
          ]) ??
          await googleUser.authorizationClient.authorizeScopes([
            'email',
            'profile',
          ]);

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authz.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      debugPrint(
        'Firebase Auth Exception during Google Sign-In: ${e.code} - ${e.message}',
      );
      throw _handleFirebaseAuthError(e);
    } catch (e, stack) {
      debugPrint('Unknown Google Sign-In Error: $e\n$stack');
      if (e.toString().contains('[16]')) {
        throw 'Firebase Setup required! Missing SHA-1 certificate in Firebase Console OR google-services.json not updated.';
      }
      if (e.toString().contains('canceled')) {
        return null;
      }
      throw 'Failed to sign in with Google: $e';
    }
  }

  // 4. Sign Out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Helper method to translate Firebase error codes into user-friendly messages
  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'weak-password':
        return 'The password provided is too weak (min 6 characters).';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      default:
        return e.message ?? 'An unknown authentication error occurred.';
    }
  }
}
