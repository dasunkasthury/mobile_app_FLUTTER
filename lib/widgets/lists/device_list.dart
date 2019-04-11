import 'package:flutter/material.dart';
import '../../pages/subPages/map_view.dart';


class BeaconListPage extends StatelessWidget {
  final List<dynamic> products;

  BeaconListPage(this.products);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return /* ProductCard(products[index],index); */
            ListTile(
          title: Text(products[index]['beacon_MAC']),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return MapViewPage(beaconName: products[index]['beacon_MAC']);
                },
              ),
            );
          },
          leading: CircleAvatar(
            backgroundImage: new AssetImage('assets/Location-Icon.png'),
          ),
        );
      },
      itemCount: products.length,
    );
  }
}
