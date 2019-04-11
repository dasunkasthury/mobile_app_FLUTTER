import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class Database {

  static Future<String> createMountain() async {
    String accountKey = await _getAccountKey();

    var mountain = <String, dynamic>{
      'beacon_MAC' : '',
      'gateway_MAC':'',
      'rssi':'',
      'created': _getDateNow(),
    };

    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child("Location")
        .child(accountKey)
        .child("Devices")
        .push();

    reference.set(mountain);

    return reference.key;
  }

/////////////////////////// for floor

  static Future<String> createFloor() async {

    var floor = <String, dynamic>{
      'floor' : '',
      'side':'',
      'image':'',
      
    };

    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child("Location")
        .push();

    reference.set(floor);


    return reference.key;
  }

  static Future<StreamSubscription<Event>> getFloorNameStream(String locationKey,
      void onData(String floorName)) async {
    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child("Location")
        .child(locationKey)
        .child("floor")
        .onValue
        .listen((Event event) {
      String floorName = event.snapshot.value as String;
      if (floorName == null) {
        floorName = "";
      }
      onData(floorName);
    });

    return subscription;
  }

  static Future<StreamSubscription<Event>> getSideNameStream(String locationKey,
      void onData(String sideName)) async {
    
    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child("Location")
        .child(locationKey)
        .child("side")
        .onValue
        .listen((Event event) {
      String sideName = event.snapshot.value as String;
      if (sideName == null) {
        sideName = "";
      }
      onData(sideName);
    });

    return subscription;
  }


  static Future<StreamSubscription<Event>> getImageNameStream(String locationKey,
      void onData(String sideName)) async {
    

    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child("Location")
        .child(locationKey)
        .child("image")
        .onValue
        .listen((Event event) {
      String imageName = event.snapshot.value as String;
      if (imageName == null) {
        imageName = "";
      }
      onData(imageName);
    });

    return subscription;
  }

  static Future<void> saveFloorName(String locationKey, String name) async {
    String accountKey = await _getAccountKey();

    return FirebaseDatabase.instance
        .reference()
        .child("Location")
        .child(accountKey)
        .child('floor')
        .set(name);
  }

  static Future<void> saveSideName(String locationKey, String name) async {
    String accountKey = await _getAccountKey();

    return FirebaseDatabase.instance
        .reference()
        .child("Location")
        .child(accountKey)
        .child('side')
        .set(name);
  }

  static Future<void> saveImage(String locationKey, String name) async {
    String accountKey = await _getAccountKey();

    return FirebaseDatabase.instance
        .reference()
        .child("Location")
        .child(accountKey)
        .child('image')
        .set(name);
  }

  static Future<Query> queryFloors() async {
    
    return FirebaseDatabase.instance
        .reference()
        .child("Location");
        //.orderByChild("floor");
  }



////////////////////////////////////// end for floor
///
///////////////////////////////////////// for gateways
static Future<String> createGatewayLocation() async {
    
    var gatewayLoc = <String, dynamic>{
      'gateway_MAC':'',
      'Xlocation':'',
      'Ylocation':'',
     
    };

    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child("gateway")
        .push();

    reference.set(gatewayLoc);

    return reference.key;
  }

  static Future<void> saveGatewayName(String locationKey, String name) async {
      

      return FirebaseDatabase.instance
          .reference()
          .child("gateway")
          .child(locationKey)
          .child('gateway_MAC')
          .set(name);
    }

    static Future<void> saveGatewayXCoordinates(String locationKey, double name) async {
      

      return FirebaseDatabase.instance
          .reference()
          .child("gateway")
          .child(locationKey)
          .child('Xlocation')
          .set(name);
    }

    static Future<void> saveGatewayYCoordinates(String locationKey, double name) async {
      

      return FirebaseDatabase.instance
          .reference()
          .child("gateway")
          .child(locationKey)
          .child('Ylocation')
          .set(name);
    }

    static Future<Query> queryGateways() async {
    

    return FirebaseDatabase.instance
        .reference()
        .child("gateway")
        .orderByChild('gateway_MAC');
        
  }


/////////////////////////////////////////////// end for gareway

  static Future<void> saveName(String locationKey, String name) async {
    String accountKey = await _getAccountKey();

    return FirebaseDatabase.instance
        .reference()
        .child("Location")
        .child(accountKey)
        .child("Devices")
        .child(locationKey)
        .child('rssi')
        .set(name);
  }

  static Future<void> deleteDevice(String locationKey) async {
    String accountKey = await _getAccountKey();

    return FirebaseDatabase.instance
        .reference()
        .child("Location")
        .child(accountKey)
        .child("Devices")
        .child(locationKey)
        .remove();
  }



  static Future<StreamSubscription<Event>> getNameStream(String locationKey,
      void onData(String name)) async {
    String accountKey = await _getAccountKey();

    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child("Location")
        .child(accountKey)
        .child("Devices")
        .child(locationKey)
        .child("rssi")
        .onValue
        .listen((Event event) {
      String name = event.snapshot.value as String;
      if (name == null) {
        name = "";
      }
      onData(name);
    });

    return subscription;
  }



  static Future<void> savebName(String locationKey, String name) async {
      String accountKey = await _getAccountKey();

      return FirebaseDatabase.instance
          .reference()
          .child("Location")
          .child(accountKey)
          .child("Devices")
          .child(locationKey)
          .child('beacon_MAC')
          .set(name);
    }

    




  static Future<StreamSubscription<Event>> getBeaconNameStream(String locationKey,
      void onData(String bName)) async {
    String accountKey = await _getAccountKey();

    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child("Location")
        .child(accountKey)
        .child("Devices")
        .child(locationKey)
        .child("beacon_MAC")
        .onValue
        .listen((Event event) {
      String bName = event.snapshot.value as String;
      if (bName == null) {
        bName = "";
      }
      onData(bName);
    });

    return subscription;
  }





  static Future<void> savegName(String locationKey, String name) async {
      String accountKey = await _getAccountKey();

      return FirebaseDatabase.instance
          .reference()
          .child("Location")
          .child(accountKey)
          .child("Devices")
          .child(locationKey)
          .child('gateway_MAC')
          .set(name);
    }

  static Future<StreamSubscription<Event>> getGatewayNameStream(String locationKey,
      void onData(String gName)) async {
    String accountKey = await _getAccountKey();

    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child("Location")
        .child(accountKey)
        .child("Devices")
        .child(locationKey)
        .child("gateway_MAC")
        .onValue
        .listen((Event event) {
      String gName = event.snapshot.value as String;
      if (gName == null) {
        gName = "";
      }
      onData(gName);
    });

    return subscription;
  }


  static Future<Query> queryLocations() async {
    String accountKey = await _getAccountKey();

    return FirebaseDatabase.instance
        .reference()
        .child("Location")
        .child(accountKey)
        .child("Devices")
        .orderByChild("rssi");
  }
}
//////////////////////////////////////////////////////////////////////////////////////
Future<String> _getAccountKey() async {
  return '2';
}

/// requires: intl: ^0.15.2
String _getDateNow() {
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
  return formatter.format(now);
}

