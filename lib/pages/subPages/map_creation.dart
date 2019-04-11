import 'package:flutter/material.dart';
import '../../database/database.dart';
import '../locations.dart';

class MapCreatePage extends StatefulWidget {

  static String routeName = '/set_mapLocation';

  final String locationKey;
  final String gatewayName;

  MapCreatePage({Key key, this.locationKey ,this.gatewayName}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _mapCreatePageState();
  }
}

class _mapCreatePageState extends State<MapCreatePage> {
  double posx = 100.0;
  double posy = 100.0;

  String _selectedText;

  void onTapDown(BuildContext context, TapDownDetails details) {
    print('${details.globalPosition}');
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    setState(() {
      posx = localOffset.dx;
      posy = localOffset.dy;
    });
  }


  _buildTextField() {
    return TextFormField(
      decoration:
          InputDecoration(labelText: 'Product title', icon: Icon(Icons.label)),
      /* onChanged: (String value) {
                  setState(() {
                    _titleValue = value;
                  });
                }); */
      //autovalidate: true,
    
      //onSaved: () {}
    );
  }

  @override
  Widget build(BuildContext context) {
    

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('map'),
      ),
      bottomSheet: Row(children: <Widget>[
        RaisedButton(child: Text("SAVE"), onPressed: (){
          
          Database.createGatewayLocation().then((String locationKey) {
            Database.saveGatewayName(locationKey, widget.gatewayName);
            Database.saveGatewayXCoordinates(locationKey, posx);
            Database.saveGatewayYCoordinates(locationKey, posy-80);
          });
          
        },),
        Text(widget.gatewayName),
        RaisedButton(child: Text("back"), onPressed: (){
          Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context){
                  return LocationsPage();//ProductCreatePage(products[index]);
                },),
              );
        },),
       ],) ,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    /* 
    return new Container(
        constraints: new BoxConstraints.expand(
          height: 200.0,
        ),
        padding: new EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('assets/chair.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: new Stack(
          children: <Widget>[
            new Positioned(
              left: 0.0,
              bottom: 0.0,
              child: new Text('Title',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  )
              ),
            ),
            new Positioned(
              right: 0.0,
              bottom: 0.0,
              child: new Icon(Icons.star,color:Colors.red),
            ),
          ],
        )
    ); */

    return new 
    GestureDetector(
      onTapDown: (TapDownDetails details) => onTapDown(context, details),
      child: new Stack(fit: StackFit.expand, children: <Widget>[
        // Hack to expand stack to fill all the space. There must be a better
        // way to do it.
        new Container(decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('assets/chair.jpg')
          )
          ),),
        new Positioned(
          child: new Icon(Icons.star,color:Colors.red),
          left: posx,
          top: posy-80,
        )
      ]),
    );
  }

///////////////////////

  /* double posx = 0.0;
  double posy = 100.0;

  void onTapDown(BuildContext context, TapDownDetails details) {
    print('${details.globalPosition}');
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    setState(() {
      posx = localOffset.dx;
      posy = localOffset.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTapDown: (TapDownDetails details) => onTapDown(context, details),
      child: new Stack(fit: StackFit.expand, children: <Widget>[
        // Hack to expand stack to fill all the space. There must be a better
        // way to do it.
        new Container(color: Colors.white),
        new Positioned(
          child: new Text('hello'),
          left: posx,
          top: posy,
        )
      ]),
    );
  } */
}
