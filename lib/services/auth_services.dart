import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> verifyMobileNumber(
      String mobileNumber, Function(String) onCodeSent) async {
    if (mobileNumber.isEmpty) {
      throw Exception("Mobile Number cannot be empty");
    }
    String formattedNumber =
        mobileNumber.startsWith("+") ? mobileNumber : "+$mobileNumber";

    await _auth.verifyPhoneNumber(
      phoneNumber: formattedNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException exception) {
          print("Verification failed: ${exception.message}");
          throw exception;
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  Future<void> signInWithOtp(String otp, String verificationId) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    await _auth.signInWithCredential(credential);
  }

  User? get currentUser => _auth.currentUser;
}
