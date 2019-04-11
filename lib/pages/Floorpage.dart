import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../database/database.dart';
import '../database/editFloorPage.dart';

class FloorPage extends StatefulWidget {
  static String routeName = '/floor_list';
  @override
  State<StatefulWidget> createState() {
    return _floorPage();
  }
}

class _floorPage extends State<FloorPage> {
  Query _query;

  @override
  void initState() {
    Database.queryFloors().then((Query query) {
      setState(() {
        _query = query;
      });
    });

    super.initState();
  }

  _buildActionButton(BuildContext context, String fName) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.view_module),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            if (fName.compareTo("Second Floor") == 0) {
              Navigator.pushReplacementNamed(context, '/view_all_mapLocation');
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('No devices found'),
                      content: Text(
                          'This floor has no devices please check for another floor '),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.favorite_border),
          color: Colors.red,
          onPressed: () {},
        )
      ],
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
          String floorName = map['floor'] as String;
          String side = map['side'] as String;
          String image = map['image'] as String;
          String keys = snapshot.key;

          return Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            //elevation: 15,
            child: Column(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Hero(
                    tag: 'floor',
                    child: FadeInImage(
                      fadeInCurve: Curves.bounceIn,
                      fadeInDuration: Duration(milliseconds: 10),
                      image: NetworkImage(image),
                      height: 300.0,
                      fit: BoxFit.fill,
                      placeholder: AssetImage('assets/temp_map.jpg'),
                    ),
                  ),
                )
                    //Image.asset(products['image']),
                    ,
                Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //TitleDefault(products['floor']),
                        Text(
                          floorName,
                          style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Oswald'),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                      ],
                    )),
                //AddressTag('Sri Lanka'),
                _buildActionButton(context, floorName),
              ],
            ),
          );
        },
      );
    }

    return new Scaffold(
      //drawer: _buildSideDrawer(context),
      appBar: new AppBar(
        title: new Text("Floor List"),
      ),
      body: body,
      /* floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          _createFloor();
        },
      ), */
    );
  }

  void _createFloor() {
    Database.createFloor().then((String locationKey) {
      _editFloor(locationKey);
    });
  }

  void _editFloor(String locationKey) {
    var route = new MaterialPageRoute(
      builder: (context) => new EditFloorPage(locationKey: locationKey),
    );
    Navigator.of(context).push(route);
  }
}
