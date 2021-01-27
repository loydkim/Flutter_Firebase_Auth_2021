
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthFacebook {
  AccessToken _accessToken;
  Map<String, dynamic> _userData;
  Future<dynamic> signInWithFacebook() async {
    try {
      _accessToken = await FacebookAuth.instance.login(); // by the fault we request the email and the public profile
      // loginBehavior is only supported for Android devices, for ios it will be ignored
      // _accessToken = await FacebookAuth.instance.login(
      //   permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link'],
      //   loginBehavior:
      //       LoginBehavior.DIALOG_ONLY, // (only android) show an authentication dialog instead of redirecting to facebook app
      // );

      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      String pretty = encoder.convert(_accessToken.toJson());

      print(pretty);
      // get the user data
      // by default we get the userId, email,name and picture
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      _userData = userData;
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final OAuthCredential credential =  FacebookAuthProvider.credential( _accessToken.token);
      final User user = (await _auth.signInWithCredential(credential)).user;
      return user;
    } on FacebookAuthException catch (e) {
      // if the facebook login fails
      print(e.message); // print the error message in console
      // check the error type
      var errorCode = "Facebook Error";
      switch (e.errorCode) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          print("You have a previous login operation in progress");
          errorCode = "You have a previous login operation in progress";
          break;
        case FacebookAuthErrorCode.CANCELLED:
          print("login cancelled");
          errorCode = "Login cancelled";
          break;
        case FacebookAuthErrorCode.FAILED:
          print("login failed");
          errorCode = "Login failed";
          break;
      }
      return errorCode;
    } catch (e, s) {
      // print in the logs the unknown errors
      print(e);
      print(s);
      return s;
    } finally {
      // update the view
      print('finish');
    }
  }
}