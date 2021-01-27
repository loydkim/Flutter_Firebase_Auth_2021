import 'package:firebase_auth/firebase_auth.dart';

class AuthMail {
  Future<dynamic> signInWithEmail(String email, String password) async{
    try {
      UserCredential _userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return _userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return e.code;
    } catch (e) {
      print(e);
      return e;
    }
  }
}