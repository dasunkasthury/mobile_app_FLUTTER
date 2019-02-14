import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {

  final Function addProduct;
  ProductCreatePage(this.addProduct);
  @override
  State<StatefulWidget> createState() {
    return _productCreatePageState();
  }
}

class _productCreatePageState extends State<ProductCreatePage> {
  String _titleValue = '';
  String _description = '';
  double _priceValue;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    /* Center(
      child: RaisedButton(
        child: Text('Save'),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: Text('this is a modal'),
                );
              });
        },
      ),
    ) */

    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          TextField(
              decoration: InputDecoration(
                  labelText: 'Product title', icon: Icon(Icons.label)),
              onChanged: (String value) {
                setState(() {
                  _titleValue = value;
                });
              }),
          //Text(titleValue),
          TextField(
            decoration: InputDecoration(
                  labelText: 'Product description', icon: Icon(Icons.list)),
              maxLines: 4,
              onChanged: (String value) {
                setState(() {
                  _description = value;
                });
              }),
          TextField(
            decoration: InputDecoration(
                  labelText: 'Product value', icon: Icon(Icons.local_atm)),
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                setState(() {
                  _priceValue = double.parse(value);
                });
              }),
              SizedBox(
                height:10.0,
              ),
              RaisedButton(
                child: Text('SAVE'),
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                onPressed: (){
                final Map<String,dynamic> product={
                  'title': _titleValue,
                  'description': _description,
                  'price':_priceValue,
                  'image': 'assets/chair.jpg'

                };

                widget.addProduct(product);
                Navigator.pushReplacementNamed(context, '/PRODUCTS');
              },)
        ],
      ),
    );
  }
}
