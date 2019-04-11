import 'package:flutter/material.dart';
import './pages/auth.dart';
import './database/edit_location.dart';
import './pages/gateway.dart';
import './pages/subPages/map_view.dart';
import './pages/devices.dart';
import './pages/all_map_view.dart';
import './pages/locations.dart';
import './pages/Floorpage.dart';

//////////////////////////////////////////////////////////////

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepOrange,
        brightness: Brightness.light,
      ),
      //fontFamily: 'Oswald'),
      home: AuthPage(),
      routes: {
        '/DEVICES': (BuildContext context) => LocationsPage(),
        '/admin': (BuildContext context) => EditLocationPage(),
        '/view_mapLocation': (BuildContext context) => MapViewPage(),
        '/gateway': (BuildContext context) => GatewayListPage(),
        '/devices_list': (BuildContext context) => DevicePage(),
        '/view_all_mapLocation': (BuildContext context) => AllMapViewPage(),
        '/floor_list': (BuildContext context) => FloorPage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElement = settings.name.split('/');
        if (pathElement[0] != '') {
          return null;
        }
        
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute<bool>(
          builder: (BuildContext context) => FloorPage(),
        );
      },
    );

    ////////////////////////////////////////////////////

  }
}
