import 'package:flutter/material.dart';
import './products_manager.dart';
import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';

//import 'package:flutter/rendering.dart';
void main() {
  //debugPaintSizeEnabled = true;
  //debugPaintBaselinesEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}



class _MyAppState extends State<MyApp>{
  //List<String> _products = ['food tester'];
  List<Map<String ,dynamic>> _products = [];

  void _addProduct(Map<String ,dynamic> product) {
    setState(() {
      _products.add(product);
    });
  }

  void _deleteProduct(int index){
    setState(() {
      _products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.deepOrange,
          brightness: Brightness.light),
      home: AuthPage(),
      routes: {
        '/PRODUCTS': (BuildContext context) => ProductsPage(_products,),
        '/admin': (BuildContext context) => ProductsAdminPage(_addProduct, _deleteProduct ),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElement = settings.name.split('/');
        if (pathElement[0] != '') {
          //print('____________null');
          return null;
          
        }
        if (pathElement[1] == 'product') {
          final int index = int.parse(pathElement[2]);
          //print(pathElement[1] + '-----------------' );
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ProductPage(_products[index]['title'],_products[index]['image'], ),
          );
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings){
        return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ProductsPage(_products),
          );

      },
    );
  }
}
