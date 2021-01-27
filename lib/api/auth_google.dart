

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthGoogle{
  Future<dynamic> signInWithGoogle() async {
    try{
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      if(googleUser != null) {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Create a new credential
        final GoogleAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        // Once signed in, return the User
        return userCredential.user;
      }else{
        return null;
      }
    } on PlatformException catch(e){
      print('message is ${e.message}');
      print('code is ${e.code}');
      print('details is ${e.details}');
      // check the error type
      var errorCode = "Google Sign In Error";
      switch (e.message) {
        case "sign_in_canceled":{
          errorCode = "Sign In Canceled";
        }break;
      }
      return errorCode;
    } catch(e){
      return e.toString();
    }
  }
}