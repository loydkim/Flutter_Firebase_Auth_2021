import 'package:firebase_auth/firebase_auth.dart';

class AuthPhone{
  String verificationId;
  void requestSMSCodeUsingPhoneNumber(String phoneNumber) async{
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) => print('Sign up with phone complete'),
      verificationFailed: (FirebaseAuthException e) => print('error message is ${e.code}'),
      codeSent: (String verificationId, int resendToken) {
        print('verificationId is $verificationId');
        this.verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<dynamic> signInWithPhoneNumberAndSMSCode(String verificationId, String smsCode) async{
    try{
      final authCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      final credential = (await FirebaseAuth.instance.signInWithCredential(authCredential));
      return credential.user;
    }on Exception catch(e){
      return e.toString();
    }
  }
}