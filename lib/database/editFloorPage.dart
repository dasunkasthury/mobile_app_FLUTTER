import 'dart:async';

import 'package:flutter/material.dart';
import './database.dart';

class EditFloorPage extends StatefulWidget {
  static String routeName = '/edit_floor';

  final String locationKey;

  EditFloorPage({Key key, this.locationKey}) : super(key: key);

  @override
  _EditFloorPageState createState() => new _EditFloorPageState();
}

class _EditFloorPageState extends State<EditFloorPage> {

  final _floorTextController = new TextEditingController();
  final _sideTextController = new TextEditingController();
  final _imageTextController = new TextEditingController();

  StreamSubscription _floorSubscriptionName;
  StreamSubscription _sideSubscriptionName;
  StreamSubscription _imageSubscriptionName;

  @override
  void initState() {
    _floorTextController.clear();
    _sideTextController.clear();
    _imageTextController.clear();

    Database.getFloorNameStream(widget.locationKey, _updateFloorName)
        .then((StreamSubscription l) => _floorSubscriptionName = l);

    Database.getSideNameStream(widget.locationKey, _updateSideName)
        .then((StreamSubscription k) =>_sideSubscriptionName = k);

    Database.getImageNameStream(widget.locationKey, _updateImage)
        .then((StreamSubscription n) =>_imageSubscriptionName = n);

    super.initState();
  }

  @override
  void dispose() {
    if (_floorSubscriptionName != null) {
      _floorSubscriptionName.cancel();
    }

    if (_sideSubscriptionName != null) {
      _sideSubscriptionName.cancel();
    }

    if (_imageSubscriptionName != null) {
      _imageSubscriptionName.cancel();
    }


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Edit Floor"),
      ),
      body: new ListView(
        children: <Widget>[
          new ListTile(
            title: new TextField(
              controller: _floorTextController,
              decoration: new InputDecoration(
                icon: new Icon(Icons.edit),
                labelText: "Floor",
                hintText: "Enter the floor name..."
              ),
              onChanged: (String value) {
                Database.saveFloorName(widget.locationKey, value);
                //Database.savebName(widget.locationKey, value);
              },
            ),
          ),
          new ListTile(
            title: new TextField(
              controller: _sideTextController,
              decoration: new InputDecoration(
                icon: new Icon(Icons.edit),
                labelText: "Side Name",
                hintText: "Enter the side..."
              ),
              onChanged: (String value) {
                Database.saveSideName(widget.locationKey, value);
                //Database.savebName(widget.locationKey, value);
              },
            ),
          ),
          new ListTile(
            title: new TextField(
              controller: _imageTextController,
              decoration: new InputDecoration(
                icon: new Icon(Icons.edit),
                labelText: "Floor Image",
                hintText: "Enter the floor image..."
              ),
              onChanged: (String value) {
                Database.saveImage(widget.locationKey, value);
                //Database.savebName(widget.locationKey, value);
              },
            ),
          )
        ],
      ),
    );
  }

  void _updateFloorName(String name) {
    _floorTextController.value = _floorTextController.value.copyWith(
      text: name,
    );
  }

  void _updateSideName(String name) {
    _sideTextController.value = _sideTextController.value.copyWith(
      text: name,
    );
  }

    void _updateImage(String name) {
    _imageTextController.value = _imageTextController.value.copyWith(
      text: name,
    );
  }
}