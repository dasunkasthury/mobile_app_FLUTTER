import 'package:flutter/material.dart';
import './products_manager.dart';
import './pages/home.dart';

//import 'package:flutter/rendering.dart';
void main() {
  //debugPaintSizeEnabled = true;
  //debugPaintBaselinesEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  //List<String> _products = ['food tester'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepOrange,
        brightness: Brightness.light

      ),
        home: HomePage(),
        );
  }
}
