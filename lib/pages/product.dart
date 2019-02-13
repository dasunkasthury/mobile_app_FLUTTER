import 'package:flutter/material.dart';
import 'dart:async';

class ProductPage extends StatelessWidget {
  final String title;
  final String imgURL;

  ProductPage(this.title, this.imgURL);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () {
        print('back button has been pressed');
        Navigator.pop(context, false); 
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(imgURL),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(title),
              ),
              RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text('DELETE'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
