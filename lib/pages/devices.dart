import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../database/database.dart';
import '../widgets/lists/device_list.dart';
import '../widgets/lists/gateway_list.dart';

class DevicePage extends StatefulWidget {
  static String routeName = '/devices_list';
  @override
  State<StatefulWidget> createState() {
    return _devicePage();
  }
}

class _devicePage extends State<DevicePage> {
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

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.location_searching),
            title: Text('Locations'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/DEVICES');
            },
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('View Map'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/view_all_mapLocation');
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/floor_list');
            },
          ),
        ],
      ),
    );
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
    //// for beacons
    List<dynamic> list2 = new List<dynamic>();
    List<String> beaconList = new List();

    /// for gateways
    List<dynamic> list3 = new List<dynamic>();
    List<String> gatewayList = new List();
    if (_query != null) {
      return new StreamBuilder<Event>(
          stream: FirebaseDatabase.instance
              .reference()
              .child("Location")
              .child('2')
              .child("Devices")
              .onValue,
          builder: (BuildContext context, AsyncSnapshot<Event> event) {
            if (!event.hasData)
              return new Scaffold(
                //drawer: _buildSideDrawer(context),
                appBar: new AppBar(
                  title: new Text("Device List"),
                ),
                body: Center(child: CircularProgressIndicator(),) ,
              );

            //new Center(child: new Text('Loading...'));

            Map<dynamic, dynamic> data = event.data.snapshot.value;
            List<dynamic> list1 = data.values.toList();

            for (var i = 0; i < list1.length; i++) {
              String bMac = list1[i]['beacon_MAC'] as String;
              String gMac = list1[i]['gateway_MAC'] as String;
///// for beacons
              if (beaconList.isEmpty) {
                list2.add(list1[i]);
                beaconList.add(bMac);
              }
              if (!beaconList.contains(bMac)) {
                list2.add(list1[i]);
                beaconList.add(bMac);
              }

/// for gateways
              if (gatewayList.isEmpty) {
                list3.add(list1[i]);
                gatewayList.add(gMac);
              }
              if (!gatewayList.contains(gMac)) {
                list3.add(list1[i]);
                gatewayList.add(gMac);
              }
            }

            return DefaultTabController(
              length: 2,
              child: Scaffold(
                  drawer: _buildSideDrawer(context),
                  appBar: AppBar(
                    title: Text('List'),
                    bottom: TabBar(
                      tabs: <Widget>[
                        Tab(
                          icon: Icon(Icons.phone_android),
                          text: 'Device',
                        ),
                        Tab(
                          icon: Icon(Icons.settings_input_antenna),
                          text: 'Gateway',
                        )
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: <Widget>[
                      BeaconListPage(list2),
                      GatewayListPage(list3),
                    ],
                  )),
            );
          });
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Device List"),
      ),
      body: body,
    );
  }
}
