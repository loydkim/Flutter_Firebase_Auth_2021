import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseauth/api/auth_apple.dart';
import 'package:firebaseauth/api/auth_facebook.dart';
import 'package:firebaseauth/api/auth_github.dart';
import 'package:firebaseauth/api/auth_google.dart';
import 'package:firebaseauth/widget/sign_phone_form.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'widget/sign_mail_form.dart';
import 'widget/youtubepromotion.dart';

enum SignInType{
  mail,
  google,
  facebook,
  apple,
  phone,
  github
}
class AuthListData{
  final SignInType signInType;
  final Color fillColor;
  final IconData iconData;

  AuthListData(this.signInType, this.fillColor, this.iconData);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Test',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  FirebaseAuth _auth;
  User _user;
  bool _isLoading = false;

  final _authListFirstRowData =[
    AuthListData(SignInType.mail,Colors.amber[900],FontAwesomeIcons.solidEnvelope),
    AuthListData(SignInType.facebook,Colors.blue[900],FontAwesomeIcons.facebookF),
    AuthListData(SignInType.google,Colors.red[900],FontAwesomeIcons.google),
  ];

  final _authListSecondRowData =[
    AuthListData(SignInType.github,Colors.black,FontAwesomeIcons.githubAlt),
    AuthListData(SignInType.phone,Colors.green[900],FontAwesomeIcons.phone),
    Platform.isIOS ? AuthListData(SignInType.apple,Colors.black,FontAwesomeIcons.apple) : null,
  ];
  @override
  void initState() {
    _initialization.whenComplete(() {
      _auth = FirebaseAuth.instance;
      _auth.authStateChanges().listen((User user) {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          print('User is signed in!');
          setState(() {
            _user = user;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Authentication'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {return Center(child: Text('Error, Can not use firebase.'));}
          if (snapshot.connectionState == ConnectionState.done) {
            return _isLoading ? Center(child: CircularProgressIndicator()) : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("User status",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                      FlatButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          setState(() {_user = null;});},
                        child: Text('Sign Out',style: TextStyle(color: Colors.white),),
                        color: Colors.purple,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    child: Container(
                      width: double.infinity,
                      height: size.height*0.12,
                      child: _user == null ? Center(child: Text('Please try Sign In',style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),)) :
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(8.0,8,12,8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[200],
                                  child: Center(child: _user.photoURL != null ? Image.network(_user.photoURL) : FaIcon(FontAwesomeIcons.userAlt,color: Colors.grey[800],))//Icon(Icons.add)
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('UID: ',style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold),),
                                    Text(' ${_user == null ? 'No Data' : _user.uid.substring(0,18)}...',style: TextStyle(fontSize: 14),),
                                  ],
                                ),
                                _user.email != null && _user.email.isNotEmpty ? Row(
                                  children: [
                                    Text('Email: ',style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold),),
                                    Text(' ${_user == null ? 'No Data' : _user.email}',style: TextStyle(fontSize: 14),),
                                  ],
                                ) : Container(),
                                _user.phoneNumber != null && _user.phoneNumber.isNotEmpty ? Row(
                                  children: [
                                    Text('Phone: ',style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold),),
                                    Text(' ${_user == null ? 'No Data' : _user.phoneNumber}',style: TextStyle(fontSize: 14),),
                                  ],
                                ) : Container(),
                              ],
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                ),

                Row(mainAxisAlignment: MainAxisAlignment.center,children: _authListFirstRowData.map(_authButton).toList(),),
                Row(mainAxisAlignment: MainAxisAlignment.center,children: _authListSecondRowData.map(_authButton).toList(),),
                youtubePromotion()
              ],
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget _authButton(AuthListData data){
    return data == null ? Container() :
     Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: RawMaterialButton(
        onPressed: () async{
          setState(() {
            _isLoading = true;
          });
          var user;
          switch (data.signInType){
            case SignInType.mail: {
              user = await showDialog(context: context, child: MailFormDialog());
            }break;
            case SignInType.facebook:{
              user = await AuthFacebook().signInWithFacebook();
            }break;
            case SignInType.google:{
              user = await AuthGoogle().signInWithGoogle();
            }break;
            case SignInType.apple:{
              user = await AuthApple().signInWithApple();
            }break;
            case SignInType.github:{
              user = await AuthGithub().signInWithGitHub(context);
            }break;
            case SignInType.phone:{
              user = await showDialog(context: context, child: PhoneFormDialog());
            }break;
          }
          if (user != null) {
            setState(() {
              if(user is User){
                this._user = user;
              }else{
                showDialog(context: context, child: AlertDialog(title: Text(user),),);
              }
            });
          }
          setState(() {
            _isLoading = false;
          });
        },
        elevation: 2.0,
        fillColor: data.fillColor,
        child: FaIcon(data.iconData,color: Colors.white,size: 34,),
        padding: EdgeInsets.all(15.0),
        shape: CircleBorder(),
      ),
    );
  }
}