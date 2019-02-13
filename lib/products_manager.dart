import 'package:flutter/material.dart';
import './products.dart';
import './product_control.dart';

class ProductManager extends StatefulWidget {
  final Map<String ,String> StartingProduct;

  ProductManager({this.StartingProduct }) {
    print('[Product_manager]-constructor');
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    print('[Product_manager]-createState');
    return _ProductManagerState();
  }
}

class _ProductManagerState extends State<ProductManager> {
  List<Map<String ,String>> _products = [];

  @override
  void initState() {
    if(widget.StartingProduct != null){
      _products.add(widget.StartingProduct);
    }
    
    print('[Product_manager]-initState');
    super.initState();
  }

  @override
  void didUpdateWidget(ProductManager oldWidget) {
    print('[Product_manager]-didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  void _addProduct(Map<String ,String> product) {
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
    // TODO: implement build
    print('[Product_manager]-build');
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          child: ProductControl(_addProduct),
        ),
        //Container (height: 300.0 ,child:Products(_products))
        Expanded (child:Products(_products, deleteProduct: _deleteProduct))
      ],
    );
  }
}
  