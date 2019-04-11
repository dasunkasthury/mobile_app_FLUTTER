import 'dart:async';
import 'package:flutter/material.dart';
import './database.dart';

class EditLocationPage extends StatefulWidget {
  static String routeName = '/edit_mountain';

  final String locationKey;

  EditLocationPage({Key key, this.locationKey}) : super(key: key);

  @override
  _EditLocationPageState createState() => new _EditLocationPageState();
}

class _EditLocationPageState extends State<EditLocationPage> {
  final _rssiFieldTextController = new TextEditingController();
  final _bNameFieldTextController = new TextEditingController();
  final _gNameFieldTextController = new TextEditingController();

  StreamSubscription _subscriptionName;
  StreamSubscription _beaconSubscriptionName;
  StreamSubscription _gatewaySubscriptionName;

  @override
  void initState() {
    _rssiFieldTextController.clear();
    _bNameFieldTextController.clear();
    _gNameFieldTextController.clear();

    Database.getNameStream(widget.locationKey, _updateName)
        .then((StreamSubscription l) => _subscriptionName = l);

    Database.getBeaconNameStream(widget.locationKey, _updatebName)
        .then((StreamSubscription k) =>_beaconSubscriptionName = k);

    Database.getGatewayNameStream(widget.locationKey, _updategName)
        .then((StreamSubscription n) =>_beaconSubscriptionName = n);

    super.initState();
  }

  @override
  void dispose() {
    if (_subscriptionName != null) {
      _subscriptionName.cancel();
    }

    if (_beaconSubscriptionName != null) {
      _beaconSubscriptionName.cancel();
    }

    if (_gatewaySubscriptionName != null) {
      _gatewaySubscriptionName.cancel();
    }


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Edit Location"),
      ),
      body: new ListView(
        children: <Widget>[
          new ListTile(
            title: new TextField(
              controller: _rssiFieldTextController,
              decoration: new InputDecoration(
                icon: new Icon(Icons.edit),
                labelText: "RSSI",
                hintText: "Enter the RSSI value..."
              ),
              onChanged: (String value) {
                Database.saveName(widget.locationKey, value);
                //Database.savebName(widget.locationKey, value);
              },
            ),
          ),
          new ListTile(
            title: new TextField(
              controller: _bNameFieldTextController,
              decoration: new InputDecoration(
                icon: new Icon(Icons.edit),
                labelText: "Beacon Name",
                hintText: "Enter the beacon name..."
              ),
              onChanged: (String value) {
                Database.savebName(widget.locationKey, value);
                //Database.savebName(widget.locationKey, value);
              },
            ),
          ),
          new ListTile(
            title: new TextField(
              controller: _gNameFieldTextController,
              decoration: new InputDecoration(
                icon: new Icon(Icons.edit),
                labelText: "Gateway Name",
                hintText: "Enter the gateway name..."
              ),
              onChanged: (String value) {
                Database.savegName(widget.locationKey, value);
                //Database.savebName(widget.locationKey, value);
              },
            ),
          )
        ],
      ),
    );
  }

  void _updateName(String name) {
    _rssiFieldTextController.value = _rssiFieldTextController.value.copyWith(
      text: name,
    );
  }

  void _updatebName(String name) {
    _bNameFieldTextController.value = _bNameFieldTextController.value.copyWith(
      text: name,
    );
  }

    void _updategName(String name) {
    _gNameFieldTextController.value = _gNameFieldTextController.value.copyWith(
      text: name,
    );
  }
}