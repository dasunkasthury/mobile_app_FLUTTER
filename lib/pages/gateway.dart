import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../database/database.dart';
import './subPages/map_creation.dart';

class GatewayListPage extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return _gatewayListPageState();
  }
}

class _gatewayListPageState extends State<GatewayListPage> {

  Query _query;

  @override
  void initState() {
    Database.queryLocations().then((Query query) {
      setState(() {
        _query = query;
      });
    });

    super.initState();
  }

String preGMac ="kk";
  @override
  Widget build(BuildContext context) {
    
    
    Widget body = new ListView(
      children: <Widget>[
        
        new ListTile(
          title: new Text("The list is empty..."),
        )
      ],
    );

    if (_query != null) {
      body = new FirebaseAnimatedList(
        query: _query,
        itemBuilder: (
            BuildContext context,
            DataSnapshot snapshot,
            Animation<double> animation,
            int index,
            ) {

                Map map = snapshot.value;

                String gMac = map['gateway_MAC'] as String;

              return ListTile(
          //contentPadding: EdgeInsets.all(10.0),
          //leading: Image.asset(products[index]['image']),
          title : Text(gMac),
          trailing: 
            IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){
              _setMapLocation(snapshot.key,gMac);
            },
            ),
            
          );

        },
      );
    }

    return new Scaffold(
      //drawer: _buildSideDrawer(context),
      appBar: new AppBar(
        title: new Text("Gateway List"),
      ),
      body: body,
    );
  }

  void _setMapLocation(String locationKey,String gName) {
    var route = new MaterialPageRoute(
      builder: (context) => new MapCreatePage(locationKey: locationKey,gatewayName: gName,),
    );
    Navigator.of(context).push(route);
  }
}