
import 'package:firebaseauth/api/auth_phone.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PhoneFormDialog extends StatelessWidget {

  TextEditingController _phoneNumberTEC = TextEditingController();
  TextEditingController _verifyTEC = TextEditingController();
  AuthPhone authPhone = AuthPhone();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Phone Auth'),
      content:
        Container(
          height: 300,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type your phone number'),
                Row(
                  children: <Widget>[
                    new Expanded(
                      child: new TextField(
                        decoration: new InputDecoration(
                            labelText: 'Type Phone number',
                            labelStyle: TextStyle(color: Colors.blue,fontSize: 14),
                            hintText: 'Type Phone number',
                            icon: Icon(Icons.phone,color: Colors.blue,)),
                        controller: _phoneNumberTEC,
                        keyboardType: TextInputType.phone,
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    new Expanded(
                      child: new TextField(
                        decoration: new InputDecoration(
                            labelText: 'Type Verify Number',
                            labelStyle: TextStyle(color: Colors.blue,fontSize: 14),
                            hintText: 'Type Verify Number',
                            icon: Icon(Icons.security,color: Colors.blue,)),
                        controller: _verifyTEC,
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(16),
                    textColor: Colors.black,
                    color: Colors.white ,
                    onPressed: () => authPhone.requestSMSCodeUsingPhoneNumber(_phoneNumberTEC.text),
                    child: Text('Request SMS Code', style: TextStyle(fontSize: 16),),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(16),
                    textColor: Colors.white,
                    color: Colors.blue[900],
                    onPressed: () async {
                      var requestAuthWithPhone = await authPhone.signInWithPhoneNumberAndSMSCode(authPhone.verificationId,_verifyTEC.text);
                      Navigator.pop(context,requestAuthWithPhone);
                    },
                    child: Text('Sign in with SMS Code', style: TextStyle(fontSize: 16),),
                  ),
                )
              ],
            ),
          ),
        ),
      actions: [
        FlatButton(
          child: Text('Close',style: TextStyle(color: Colors.grey[800]),),
          onPressed: () => Navigator.pop(context)),
      ],
    );
  }
}
