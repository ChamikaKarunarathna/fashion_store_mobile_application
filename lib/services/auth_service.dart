import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Service for handling Firebase Authentication operations.
///
/// Provides methods for user registration, login, logout,
/// and password reset. Automatically creates a Firestore
/// user profile document on registration.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream of authentication state changes.
  /// Emits the current [User] when logged in, or `null` when logged out.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Returns the currently signed-in [User], or `null` if not signed in.
  User? get currentUser => _auth.currentUser;

  /// Signs in a user with email and password.
  ///
  /// Throws [FirebaseAuthException] on failure.
  /// Returns the [UserCredential] on success.
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Registers a new user with email, password, and full name.
  ///
  /// Creates a Firestore user profile document at `users/{uid}`
  /// with the user's email, full name, and creation timestamp.
  /// Throws [FirebaseAuthException] on failure.
  Future<UserCredential> register(
    String email,
    String password,
    String fullName,
  ) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    // Create user profile document in Firestore
    if (credential.user != null) {
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'email': email.trim(),
        'fullName': fullName.trim(),
        'photoUrl': null,
        'phone': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    return credential;
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Sends a password reset email to the specified email address.
  ///
  /// Firebase will send an email with a link to reset the password.
  /// Does not throw if the email doesn't exist (by Firebase design,
  /// to prevent email enumeration).
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// Returns a user-friendly error message for Firebase Auth exceptions.
  ///
  /// Maps Firebase error codes to readable messages for display in UI.
  static String getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'invalid-credential':
        return 'Invalid email or password. Please try again.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
