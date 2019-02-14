import 'package:flutter/material.dart';
import './products.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage>{
  String _emailValue;
  String _password;
  bool _acceptTerms = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: ListView(children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Email' ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (String value){
              setState(() {
               _emailValue= value; 
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Password' ),
            obscureText: true,
            onChanged: (String value){
              setState(() {
               _password= value; 
              });
            },
          ),
          SwitchListTile(
            value:_acceptTerms,
            onChanged: (bool value){

            },
          )
          RaisedButton(
          child: Text('LOGIN'),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/PRODUCTS');
          },
        ),

        ],),)
        
        
      );
    
  }
}
