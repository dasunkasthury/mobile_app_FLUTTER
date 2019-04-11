import 'package:flutter/material.dart';
import '../database/database.dart';
import '../database/edit_location.dart';
import '../widgets/tags/rssiTag.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:http/http.dart' as http;

class LocationsPage extends StatefulWidget {
  @override
  _locationsPageState createState() => new _locationsPageState();
}

class _locationsPageState extends State<LocationsPage> {
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

  _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.map),
                title: Text('View Map'),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, '/view_all_mapLocation');
                },
              ),
              ListTile(
                leading: Icon(Icons.device_unknown),
                title: Text('Devices'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/devices_list');
                },
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/floor_list');
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  void deleteProduct(final key) {
    
    http.delete('https://flutter-products-e3986.firebaseio.com/Location/12345678/Devices/${key}.json',)
     .then((http.Response response) {
       
      
    //_selProductIndex = null;
    
    });
    
  }

  _showWarninigs(BuildContext context , String key) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure'),
            content: Text('This action can not be undone!'),
            actions: <Widget>[
              FlatButton(
                child: Text('DELETE'),
                onPressed: () {
                  Navigator.pop(context);
                  //Navigator.pop(context, true);
                  //Database.deleteDevice(key);
                  //Navigator.pushReplacementNamed(context, '/DEVICES');
                  //Navigator.pop(context, true);
                },
              ),
              FlatButton(
                child: Text('DISCARD'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

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
          String rssi = map['rssi'] as String;
          String bMac = map['beacon_MAC'] as String;
          

          return Dismissible(
            key: Key(snapshot.key),
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.endToStart) {
                              
                _showWarninigs(context,snapshot.key);
              }
              
              Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text(" dismissed")));
            },
            background: Container(
              color: Colors.red,
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(bMac),
                  subtitle: Text(gMac),
                  onTap: () {
                    _edit(snapshot.key);
                  },
                  leading: new Icon(
                    Icons.important_devices,
                    color: Colors.red[500],
                    size: 24,
                  ),
                  trailing: RssiTag(rssi),
                ),
                Divider(),
              ],
            ),
          );
         

          
        },
      );
    }

    return new Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: new AppBar(
        title: new Text("All locations"),
      ),
      body: body,
      /* floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          _createMountain();
        },
      ), */
    );
  }

  void _createMountain() {
    Database.createMountain().then((String locationKey) {
      _edit(locationKey);
    });
  }

  void _edit(String locationKey) {
    var route = new MaterialPageRoute(
      builder: (context) => new EditLocationPage(locationKey: locationKey),
    );
    Navigator.of(context).push(route);
  }

}