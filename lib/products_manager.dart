import 'package:flutter/material.dart';
import './products.dart';


class ProductManager extends StatelessWidget {
 /*  final Map<String ,String> StartingProduct;

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
 */
  final List<Map<String ,dynamic>> products ;
  //final Function addProduct;
  //final Function deleteProduct;

  //ProductManager (this.products,this.addProduct,this.deleteProduct);
  ProductManager (this.products);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print('[Product_manager]-build');
    return Column(
      children: [
        /* Container(
          margin: EdgeInsets.all(10.0),
          child: ProductControl(addProduct),
        ), */
        //Container (height: 300.0 ,child:Products(_products))
        //Expanded (child:Products(products, deleteProduct: deleteProduct))
        Expanded (child:Products(products))
      ],
    );
  }
}
  