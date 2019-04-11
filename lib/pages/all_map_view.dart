import 'package:flutter/material.dart';
import '../database/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

class AllMapViewPage extends StatefulWidget {
  static String routeName = '/view_all_mapLocation';
  @override
  State<StatefulWidget> createState() {
    return _AllMapViewPageState();
  }
}

class ShapesPainter extends CustomPainter {
  double radius;
  double yPos;
  Color k = Colors.blueAccent;

  ShapesPainter(this.radius, this.yPos);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the color property of the paint
    paint.color = Colors.blueAccent;
    // center of the canvas is (x,y) => (width/2, height/2)
    //var center = Offset(0, 0 - yPos); //---------------------------when we are displaying the device name
    var center = Offset(0, 0);

    // draw the circle on centre of canvas having radius 75.0
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _AllMapViewPageState extends State<AllMapViewPage> {
  Query _dquery;
  //double _direction;
  @override
  void initState() {
    Database.queryLocations().then((Query query) {
      setState(() {
        _dquery = query;
      });
    });

    super.initState();

    /* FlutterCompass.events.listen((double direction) {
      setState(() {
        _direction = direction;
      });
    }); */
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
                leading: Icon(Icons.home),
                title: Text('home'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/floor_list');
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
                leading: Icon(Icons.location_city),
                title: Text('Locations'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/DEVICES');
                },
              ),
              /* ListTile(
                leading: Icon(Icons.edit),
                title: Text('Gateway List'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/gateway');
                },
              ) */
            ],
          ),
        ],
      ),
    );
  }

  Widget createPoint(double posx, double posy) {
    return new Positioned(
      child: new Icon(
        Icons.location_on,
        color: Colors.red,
        size: 24,
      ),
      left: posx - 12,
      bottom: posy - 12,
    );
  }

  Positioned getTextWidgets(List<dynamic> strings, double x, double y) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < strings.length; i++) {
      list.add(new Container(
          child: Opacity(
        opacity: double.parse(strings[i]["rssi"]) < 5 ? 0.4 : 0.0,
        child: CustomPaint(
          painter: ShapesPainter(
              (double.parse(strings[i]["rssi"]) * 7) + 10, (i * 15.2)),
          child: Container(
              //decoration: BoxDecoration(color: Colors.red),
              //height: 10,
              //child: Text(strings[i]["beacon_MAC"]),///////////// we can add device name
              ),
        ),
      )));
    }
    return new Positioned(
      child: Column(
        children: list,
      ),
      bottom: y,
      left: x,
    );
  }

  Widget getData2(String gatewayMac, double x, double y) {
    if (_dquery != null) {
      return new StreamBuilder<Event>(
          stream: FirebaseDatabase.instance
              .reference()
              .child("Location")
              .child('2')
              .child("Devices")
              .onValue,
          builder: (BuildContext context, AsyncSnapshot<Event> event) {
            if (!event.hasData)
              return new Center(child: new Text('Loading...'));

            Map<dynamic, dynamic> data = event.data.snapshot.value;
            List<dynamic> list1 = data.values.toList();
            List<dynamic> list2 = new List<dynamic>();
            for (var i = 0; i < list1.length; i++) {
              String currentGMAC = list1[i]["gateway_MAC"].toString();
              String tempBMAC = list1[i]["beacon_MAC"].toString();
              if (currentGMAC.compareTo(gatewayMac) == 0) {
                list2.add(list1[i]);
              }
            }
            return getTextWidgets(list2, x, y);
          });
    } else {
      return new ListView(
        children: <Widget>[
          new ListTile(
            title: new Text("The list is empty..."),
          )
        ],
      );
    }
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    Widget body = new Stack(
      children: <Widget>[
        Hero(
          tag: 'floor',
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.dstATop),
              image: AssetImage('assets/map.jpg'),
            )),
          ),
        ),

        ////////////////////////////////////////////////////////////////////////////////////////////////// Location 1
        createPoint(160, 390),

        /* Positioned(
          child: Text(
            "B4:E6:2D:94:34:69",
            style:
                DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.3),
          ),
          left: 100,
          bottom: 400,
        ), */

        getData2("B4:E6:2D:94:34:69", 160, 390),

/////////////////////////////////////////////////////////////////////////////////////////////////////////////// Location 2
        /* Positioned(
          child: Text(
            "30:AE:A4:8F:CB:44",
            style:
                DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.3),
          ),
          left: 75,
          bottom: 70,
        ), */
        createPoint(95, 100),
        getData2("30:AE:A4:8F:CB:44", 95, 100),

////////////////////////////////////////////////////////////////////////////////////////////////////////////////// Location 3

        /*  Positioned(
          child: Text(
            "30:AE:A4:8F:7D:8C",
            style:
                DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.3),
          ),
          left: 240,
          bottom: 290,
        ), */
        createPoint(330, 330),
        getData2("30:AE:A4:8F:7D:8C", 330, 330),

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////// End location
//////////////////////////for compass

        /* Positioned(
          child: new Transform.rotate(
            angle: ((_direction ?? 0) * (math.pi / 180) * -1),
            child: new Image.asset(
              'assets/compas.png',
              height: 100,
              width: 100,
            ),
          ),
          left: 300,
          bottom: 550,
        ) */
///////////////////////////////////// end for compass
      ],
    );

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Map View"),
        ),
        drawer: _buildSideDrawer(context),
        body: body);
  }
}
