import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart' as g_auth;
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final g_auth.GoogleSignIn _googleSignIn = g_auth.GoogleSignIn(
    scopes: ['email', 'profile'],
  );

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

  // 2.a Email Verification
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // 2.b Reload User
  Future<void> reloadUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
    }
  }

  // 3. Google Sign-In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final g_auth.GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) return null;

      // Obtain the ID token details from the request
      final g_auth.GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
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

  // 4. Password Reset
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      throw 'Failed to send password reset email: $e';
    }
  }

  // 5. Change Password
  Future<void> changePassword(String currentPassword, String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw 'No user is currently signed in.';
    }

    // Check if the user is authenticated via email/password
    final isPasswordProvider = user.providerData.any((info) => info.providerId == 'password');
    if (!isPasswordProvider) {
      throw 'Your account uses a different sign-in method. You cannot change your password here.';
    }

    try {
      // Re-authenticate the user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      throw 'Failed to update password: $e';
    }
  }

  // 6. Sign Out
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
      case 'invalid-credential':
        return 'Invalid credentials provided.';
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
