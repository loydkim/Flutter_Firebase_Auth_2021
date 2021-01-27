
import 'package:firebase_auth/firebase_auth.dart';
import 'package:github_sign_in/github_sign_in.dart';

class AuthGithub{
  Future<dynamic> signInWithGitHub(context) async {
    try{
      // Create a GitHubSignIn instance
      final GitHubSignIn gitHubSignIn = GitHubSignIn(
          clientId: '666c689fc177df5c5d7c',
          clientSecret: '955eb3c1bef454c339f44dcba69f8fec3ab84cdb',
          redirectUrl: 'https://fir-practice-3f194.firebaseapp.com/__/auth/handler');

      // Trigger the sign-in flow
      final result = await gitHubSignIn.signIn(context);

      if(result.token != null) {
        // Create a credential from the access token
        final AuthCredential githubAuthCredential = GithubAuthProvider.credential(result.token);

        // Once signed in, return the UserCredential
        // return await FirebaseAuth.instance.signInWithCredential(githubAuthCredential);

        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(githubAuthCredential);

        // Once signed in, return the User
        return userCredential.user;
      }
    }on Exception catch(e){
      return e.toString();
    }
  }
}