import 'package:flutter/material.dart';


class GatewayListPage extends StatelessWidget {
  final List<dynamic> products;

  GatewayListPage(this.products);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          
          title: Text(products[index]['gateway_MAC']),
          trailing: new Icon(
            Icons.location_on,
            color: Colors.red[500],
            size: 24,
          ),
        );
      },
      itemCount: products.length,
    );
  }
}
