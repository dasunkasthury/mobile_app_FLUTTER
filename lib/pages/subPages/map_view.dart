import 'package:flutter/material.dart';
import '../../database/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import '../../anim.dart';

import 'package:flutter_compass/flutter_compass.dart';

class MapViewPage extends StatefulWidget {
  static String routeName = '/view_mapLocation';

  final String beaconName;

  MapViewPage({this.beaconName});

  @override
  State<StatefulWidget> createState() {
    return _MapViewPageState();
  }
}

class Point {
  double x;
  double y;

  Point(this.x, this.y);

  double getX() {
    return x;
  }

  double getY() {
    return y;
  }
}

class Circle {
  Point center;
  double radius;

  Circle(this.center, this.radius);

  double getRadius() {
    return radius;
  }

  Point getCenter() {
    return center;
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
    var center = Offset(0, 0 - yPos);

    // draw the circle on centre of canvas having radius 75.0
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _MapViewPageState extends State<MapViewPage> {
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

  /* @override
  void dispose() {
    if (_direction != null) {
      _direction==null;
    }

  


    super.dispose();
  } */
/////////////////////////////////////////// for trilateration....

  getTwoPointsDistance(Point p1, Point p2) {
    double powdifference1 = pow(p1.getX() - p2.getX(), 2);
    double powdifference2 = pow(p1.getY() - p2.getY(), 2);

    double dis = sqrt(powdifference1 + powdifference2);

    double avdDIS = double.parse(dis.toStringAsFixed(2));

    return avdDIS;
  }

  Widget createPoint(double posx, double posy) {
    return new Positioned(
      child: new Icon(
        Icons.location_on,
        color: Colors.red[500],
        size: 24,
      ),
      left: posx - 12,
      bottom: posy - 12,
    );
  }

  Widget createPointTemp(double posx, double posy) {
    return new Positioned(
      child: new Icon(
        Icons.add_circle,
        color: Colors.red,
        size: 24,
      ),
      left: posx - 12,
      bottom: posy - 12,
    );
  }

  getTwoCirclesIntersectingPoints(Circle c1, Circle c2) {
    Point p1 = c1.getCenter();
    Point p2 = c2.getCenter();
    double r1 = c1.getRadius();
    double r2 = c2.getRadius();

    double d = getTwoPointsDistance(p1, p2);

    if (d >= (r1 + r2) || d <= sqrt(pow((r1 - r2), 2))) {
      return null;
    }

    double a = (pow(r1, 2) - pow(r2, 2) + pow(d, 2)) / (2 * d);
    double h = sqrt(pow(r1, 2) - pow(a, 2));
    double x0 = p1.getX() + a * (p2.getX() - p1.getX()) / d;
    double y0 = p1.getY() + a * (p2.getY() - p1.getY()) / d;
    double rx = -(p2.getY() - p1.getY()) * (h / d);
    double ry = -(p2.getX() - p1.getX()) * (h / d);
    return [Point(x0 + rx, y0 - ry), Point(x0 - rx, y0 + ry)];
  }

  getAllIntersectingPoints(List<Circle> circles) {
    List<Point> points = new List();
    int num = circles.length;
    for (var i = 0; i < num; i++) {
      int j = i + 1;
      for (var k = j; k < num; k++) {
        List<Point> res =
            getTwoCirclesIntersectingPoints(circles[i], circles[k]);
        print("res is ========================================");
        //
        if (res == null) {}
        if (res != null) {
          points.addAll(res);
          print(
              "intersection points are **********************************************************************************");
          print(res[0].x);
          print(res[0].y);
          print(res[1].x);
          print(res[1].y);
        }
      }
    }
    return points;
  }

  bool isContainedInCircles(Point point, List<Circle> circles) {
    bool isInside = true;
    for (var i = 0; i < circles.length; i++) {
      print("distsnce between center of the circle and point = " +
          getTwoPointsDistance(point, circles[i].center).toString());
      print("radius of the circle = " + circles[i].radius.toString());
      print("end");
      if (getTwoPointsDistance(point, circles[i].center) >
          (circles[i].radius)) {
        //return false;
        isInside = false;
      }
      //return true;
    }
    return isInside;
  }

  getPolygonCenter(List<Point> points) {
    Point center = Point(0, 0);
    int num = points.length;
    //print("# elements in getPolygonCenter " + num.toString());
    for (var i = 0; i < num; i++) {
      center.x += points[i].x;
      center.y += points[i].y;
    }
    center.x /= num;
    center.y /= num;
    return center;
  }

////////////////////////////////////////////////////////////

  Positioned getTextWidgets(List<dynamic> devices, double x, double y) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < devices.length; i++) {
      list.add(
          // new Text(devices[i]["rssi"]),
          new Container(
              //height: 1,
              //decoration: BoxDecoration(color: Colors.blue),
              child: Opacity(
        opacity: double.parse(devices[i]["rssi"]) < 5 ? 0.4 : 0.1,
        child: CustomPaint(
          //foregroundPainter: Colors.black,
          painter: ShapesPainter(
              (double.parse(devices[i]["rssi"]) * 7).round() + 10.0,
              (i * 15.2)),
          child: Container(
              //decoration: BoxDecoration(color: Colors.red),
              //height: 10,
              //child: Text(devices[i]["beacon_MAC"]), /////////////////////////////////////here we can add device name
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
/////////////////////////////////////// for trilateration

  Widget getTrilaterationPoint() {
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
              String tempBMAC = list1[i]["beacon_MAC"].toString();
              if (tempBMAC.compareTo("12:3b:6a:1b:75:9a") == 0) {
                list2.add(list1[i]);
              }
            }

            return getActualPoint(list2);
            //return getTextWidgets(list2);
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

  List<Circle> circles = new List(3);
  Positioned getActualPoint(List<dynamic> devices) {
    print("getActualPoint is called");
    Point p1 = new Point(160, 390);
    Point p2 = new Point(95, 100);
    Point p3 = new Point(330, 330);

    for (var i = 0; i < devices.length; i++) {
      String gMac = devices[i]["gateway_MAC"].toString();
      if (gMac.compareTo("B4:E6:2D:94:34:69") == 0) {
        //print(devices[i]["gateway_MAC"].toString());
        //circles.insert(0, new Circle(p1,double.parse(devices[i]["rssi"])));
        double radius = double.parse(devices[i]["rssi"]);
        double returnRadius = 0.0;
        if (radius <= 5) {
          returnRadius = (radius * 7).round() + 10.0;
        }
        circles[0] = Circle(p1, returnRadius);
        //print(circles[0].center.getX());
      }
      if (gMac.compareTo("30:AE:A4:8F:CB:44") == 0) {
        //print(devices[i]["gateway_MAC"].toString());
        //circles.insert(1,  new Circle(p2,double.parse(devices[i]["rssi"]))) ;
        double radius = double.parse(devices[i]["rssi"]);
        double returnRadius = 0.0;
        if (radius <= 5) {
          returnRadius = (radius * 7).round() + 10.0;
        }
        circles[1] = Circle(p2, returnRadius);
      }
      if (gMac.compareTo("30:AE:A4:8F:7D:8C") == 0) {
        //print(devices[i]["gateway_MAC"].toString());
        //circles.insert(2, new Circle(p3,double.parse(devices[i]["rssi"]))) ;
        double radius = double.parse(devices[i]["rssi"]);
        double returnRadius = 0.0;
        if (radius <= 5) {
          returnRadius = (radius * 7).round() + 10.0;
        }
        circles[2] = Circle(p3, returnRadius);
      }
    }
     print("circles /////////////////////////");
    print(circles[0].radius);
    print(circles[1].radius);
    print(circles[2].radius);
    print(" END circles /////////////////////////"); 

    List<Circle> circleList = new List();
    List<double> circleRadiudList = new List();
    for (var i = 0; i < circles.length; i++) {
      circleRadiudList.add(circles[i].radius);
      for (var l = i + 1; l < circles.length; l++) {
        if (getTwoCirclesIntersectingPoints(circles[i], circles[l]) != null) {
          if (circleList.isEmpty) {
            circleList.add(circles[i]);
            circleList.add(circles[l]);
          } else if (!circleList.contains(circles[i])) {
            circleList.add(circles[i]);
          } else if (!circleList.contains(circles[l])) {
            circleList.add(circles[l]);
          }
        }
      }
    }

    List<Point> innerPoints = new List();
    //for (var i = 0; i < circles.length; i++) {
    List<Point> p = getAllIntersectingPoints(circles);
    print("getAllIntersectingPoints length =" + p.length.toString());
    //print(circleList[0].center.x);
    //print(circleList[1].center.x);
    if (p.length == 0) {
      print("circleRadiudList length " + circleRadiudList.length.toString());
      circleRadiudList.remove(0);
      circleRadiudList.remove(0);
      circleRadiudList.remove(0);
      print("circleRadiudList length " + circleRadiudList.length.toString());
      if (circleRadiudList.length == 0) {
        Point k = Point(10, 10);
        Point k1 = Point(20, 20);
        innerPoints.add(k);
        innerPoints.add(k1);
      } else {
        double minRadius = circleRadiudList.reduce(min);
        var minCircle1 = circles.where((circle) => circle.radius == minRadius);
        List<Circle> minCircle = minCircle1.toList();
        print("minCircle.length");
        print(minCircle.length);

        double kX = minCircle[0].center.x - 20;
        double kY = minCircle[0].center.y;

        double k1X = minCircle[0].center.x;
        double k1Y = minCircle[0].center.y + 20;

        Point k = Point(kX, kY);
        Point k1 = Point(k1X, k1Y);
        innerPoints.add(k);
        innerPoints.add(k1);
      }
    } else {
      for (var j = 0; j < p.length; j++) {
        //innerPoints.add(p[j]);
        if (isContainedInCircles(p[j], circleList)) {
          innerPoints.add(p[j]);
          print("inner point ----------------------------- " + j.toString());
          print(p[j].x);
          print(p[j].y);
        }
      }
      if (innerPoints.length == 0) {
        innerPoints.add(p1);
        innerPoints.add(p2);
        innerPoints.add(p3);
      }
    }

    //}

    Point center = getPolygonCenter(innerPoints);
    print("/****///////////////////////////////////////////***********");
    print(center.x);
    print(center.y);

    double xA = center.x - 10;
    double yA = center.y - 10;

    double devicewidth = MediaQuery.of(context).size.width;
    double deviceheight = MediaQuery.of(context).size.height;

    return new Positioned(
      //height: 50,
      //width: 50,
      //decoration: BoxDecoration(color: Colors.blue),
      child: new Transform.translate(
        offset: Offset(xA, -yA),
        child: new Icon(
          Icons.accessibility_new,
          color: Colors.red[500],
          size: 24,
        ),
      ), //new Container(height: 10,width: 10,decoration: BoxDecoration(color: Colors.black),),//
      left: 0,
      bottom: 0,
    );
  }

///////////////////////////////////// end for trilateration
  ///
  ///
///////////////////////////////////////// for min radius circle
  Widget getMinCircle() {
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
            List<dynamic> allDeviceList = data.values.toList();

            List<dynamic> selectedDeviceList = new List<dynamic>();
            for (var i = 0; i < allDeviceList.length; i++) {
              String tempBMAC = allDeviceList[i]["beacon_MAC"].toString();
              if (tempBMAC.compareTo(widget.beaconName) == 0) {
                selectedDeviceList.add(allDeviceList[i]);
              }
            }

            return getMinPoint(selectedDeviceList);
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

  List<Circle> circlesMin = new List(3);
  Positioned getMinPoint(List<dynamic> devices) {
    Point p1 = new Point(160, 390);
    Point p2 = new Point(95, 100);
    Point p3 = new Point(330, 330);

    for (var i = 0; i < devices.length; i++) {
      String gMac = devices[i]["gateway_MAC"].toString();
      if (gMac.compareTo("B4:E6:2D:94:34:69") == 0) {
        double radius = double.parse(devices[i]["rssi"]);
        double returnRadius = 0.0;
        if (radius <= 15) {
          returnRadius = (radius * 7).round() + 10.0;
        }
        circlesMin[0] = Circle(p1, returnRadius);
      }
      if (gMac.compareTo("30:AE:A4:8F:CB:44") == 0) {
        double radius = double.parse(devices[i]["rssi"]);
        double returnRadius = 0.0;
        if (radius <= 15) {
          returnRadius = (radius * 7).round() + 10.0;
        }
        circlesMin[1] = Circle(p2, returnRadius);
      }
      if (gMac.compareTo("30:AE:A4:8F:7D:8C") == 0) {
        double radius = double.parse(devices[i]["rssi"]);
        double returnRadius = 0.0;
        if (radius <= 15) {
          returnRadius = (radius * 7).round() + 10.0;
        }
        circlesMin[2] = Circle(p3, returnRadius);
      }
    }

    if (circlesMin[0] == null) {
      circlesMin[0] = Circle(p1, 0);
    }
    if (circlesMin[1] == null) {
      circlesMin[1] = Circle(p2, 0);
    }
    if (circlesMin[2] == null) {
      circlesMin[2] = Circle(p3, 0);
    }

    print(circlesMin[0].center.x );
    print( circlesMin[0].radius);
    print(circlesMin[1].center.x );
    print( circlesMin[1].radius);
    print(circlesMin[2].center.x );
    print(circlesMin[2].radius);

    List<double> circlesRadiusList = new List();
    for (var i = 0; i < circlesMin.length; i++) {
      circlesRadiusList.add(circlesMin[i].radius);
    }

    circlesRadiusList.remove(0);
    circlesRadiusList.remove(0);
    circlesRadiusList.remove(0);

    List<Point> minCirclePoints = new List();
    if (circlesRadiusList.length == 0) {
      return Positioned(
        child: DeleteCheck(deviceName: widget.beaconName),
      );
      /* minCirclePoints.add(Point(10, 10));
      minCirclePoints.add(Point(20, 20)); */
    } else {
      double minRadius = circlesRadiusList.reduce(min);
      var minimumCircle =
          circlesMin.where((circle) => circle.radius == minRadius);
      List<Circle> minCircleList = minimumCircle.toList();

      double kXpoint = minCircleList[0].center.x - 30;
      double kYpoint = minCircleList[0].center.y;

      double k1Xpoint = minCircleList[0].center.x;
      double k1Ypoint = minCircleList[0].center.y + 30;

      minCirclePoints.add(Point(kXpoint, kYpoint));
      minCirclePoints.add(Point(k1Xpoint, k1Ypoint));
    }

    Point center = getPolygonCenter(minCirclePoints);

    double xAPoint = center.x - 10;
    double yAPoint = center.y - 10;

    return Positioned(
      child: new Transform.translate(
        offset: Offset(xAPoint, -yAPoint),
        child: new Icon(
            Icons.accessibility_new,
            color: Colors.limeAccent[900],
            size: 24,
          ),
      ),
      bottom: 0,
      left: 0,
    );
  }

//////////////////////////////////////////// end for min circle
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
              return new Center(child: new CircularProgressIndicator());
            /* if (event.hasError)
              return new Center(child:(event.error)); */

            Map<dynamic, dynamic> data = event.data.snapshot.value;
            List<dynamic> list1 = data.values.toList();
            List<dynamic> list2 = new List<dynamic>();
            for (var i = 0; i < list1.length; i++) {
              String currentGMAC = list1[i]["gateway_MAC"].toString();
              String tempBMAC = list1[i]["beacon_MAC"].toString();
              if (currentGMAC.compareTo(gatewayMac) == 0 &&
                  tempBMAC.compareTo(widget.beaconName) == 0) {
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
        Container(
          decoration: BoxDecoration(
              //color: Colors.black,
              image: DecorationImage(
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop),
            image: AssetImage('assets/map.jpg'),
          )),
        ),

        //////////////////////////////////////////////////////////////////////////// location 1

        /* Positioned(
          child: Text(
            "B4:E6:2D:94:34:69",
            style://TextStyle(color: Colors.deepOrange,fontSize: 15,fontFamily: 'Oswald',letterSpacing: 1.5)
                DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.3),
          ),
          left: 100,
          bottom: 400,
        ), */

        createPoint(160, 390),

        getData2("B4:E6:2D:94:34:69", 160, 390),

/////////////////////////////////////////////////////////////////////////////////// location 2
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

////////////////////////////////////////////////////////////////////////////// location 3

        /* Positioned(
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

///////////////////////////////////////////////////////////////////////////////////////// for trilateration point

        //getTrilaterationPoint(), ///////////////////////////////////////////////////////////////////////////////////////to get trilateration exact point

//////////////////////////////////////////// for transform

        getMinCircle(),

////////////////////////////////////////////// end for transform
        ///
/////////////////////////////////////////////////test
        // DeleteCheck()
//////////////////////////////////////////////// end test
      ],
    );

    return new Scaffold(
        //drawer: _buildSideDrawer(context),
        appBar: new AppBar(
          title: new Text(widget.beaconName + " Location"),
        ),
        /* bottomSheet: Row(
          children: <Widget>[
            RaisedButton(
              child: Text("BACK"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return MyHomePage(); //ProductCreatePage(products[index]);
                    },
                  ),
                );
              },
            )
          ],
        ), */
        body: body);
  }
}
