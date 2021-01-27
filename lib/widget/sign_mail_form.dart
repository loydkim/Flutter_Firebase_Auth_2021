
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauth/api/auth_mail.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MailFormDialog extends StatelessWidget {

  TextEditingController _emailTEC = TextEditingController();
  TextEditingController _passwordTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Mail Auth'),
      content: Container(
        height: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type Email and Password'),
            Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    decoration: new InputDecoration(
                      labelText: 'Type Email',
                      labelStyle: TextStyle(color: Colors.blue,fontSize: 14),
                      hintText: 'Type Email',
                      icon: Icon(Icons.mail,color: Colors.blue,)),
                    controller: _emailTEC,
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    decoration: new InputDecoration(
                      labelText: 'Type Password',
                      labelStyle: TextStyle(color: Colors.blue,fontSize: 14),
                      hintText: 'Type Password',
                      icon: Icon(Icons.security,color: Colors.blue,)),
                    controller: _passwordTEC,
                    obscureText: true,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      actions: [
        new FlatButton(
          child: Text('Cancel',style: TextStyle(color: Colors.grey[800]),),
          onPressed: () => Navigator.pop(context)),
        new FlatButton(
          color: Colors.deepOrangeAccent,
          child: Text('Submit',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          onPressed: () async{
            var requestAuthWithMail = await AuthMail().signInWithEmail(_emailTEC.text, _passwordTEC.text);
            if (requestAuthWithMail is User) {
              Navigator.pop(context,requestAuthWithMail);
            }else{
              showDialog(
                context: context,
                child: AlertDialog(
                  title: Text(requestAuthWithMail),
                ),
              );
            }
          }),
      ],
    );
  }
}
