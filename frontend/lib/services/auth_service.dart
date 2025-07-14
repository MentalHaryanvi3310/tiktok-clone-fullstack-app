import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Sign up with email and password
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential result =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      await _storeToken(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Login with email and password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      await _storeToken(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with phone number (OTP)
  Future<void> signInWithPhone(
      String phoneNumber,
      Function(String verificationId, int? resendToken) codeSent,
      Function(FirebaseAuthException) verificationFailed,
      Function(String) codeAutoRetrievalTimeout) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  // Verify OTP code for phone sign-in
  Future<User?> verifyOTP(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential =
          PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;
      await _storeToken(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null; // User cancelled the sign-in
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;
      await _storeToken(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _secureStorage.delete(key: 'firebase_token');
  }

  // Store token securely
  Future<void> _storeToken(User? user) async {
    if (user != null) {
      String? token = await user.getIdToken();
      if (token != null) {
        await _secureStorage.write(key: 'firebase_token', value: token);
      }
    }
  }

  // Get stored token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'firebase_token');
  }

  // Refresh token
  Future<String?> refreshToken() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String token = await user.getIdToken(true);
      await _secureStorage.write(key: 'firebase_token', value: token);
      return token;
    }
    return null;
  }
}
