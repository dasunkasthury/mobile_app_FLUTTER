import 'package:flutter/material.dart';
import './pages/product.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  //final Function deleteProduct;
  //Products(this.products,{this.deleteProduct} ) {
  Products(this.products) {
    print('[Products]-constructor');
  }

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(products[index]['image']),
          Container(
            margin: EdgeInsets.only(top:10.0),
            child: Text(products[index]['title'], style: TextStyle(fontSize: 26.0,fontWeight: FontWeight.bold ),),
            ),
          
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('More details'),
                onPressed: () {
                  Navigator.pushNamed<bool>(
                    context,
                    '/product/' + index.toString(),
                  );/* .then((bool value) {
                    if (value) {
                      deleteProduct(index);
                    }
                  }); */
                  //print('/product/' + index.toString());
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    Widget productCard;
    if (products.length > 0) {
      productCard = ListView.builder(
        itemBuilder: _buildProductItem,
        itemCount: products.length,
      );
    } else {
      productCard = Center(
        child: Text('No product found'),
      );
    }
    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print('[Products]-build');
    return _buildProductList();
  }
}
