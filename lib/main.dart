import 'package:flutter/material.dart';
import'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socket_connection/socketConnection.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SocketConnection socketConn = SocketConnection();
  String _locationMessage = "";

  void getCurrentLocation() async {
    socketConn.initState();
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);

    String lat = (position.latitude).toString();
    String long = (position.longitude).toString();

    setState(() {
      _locationMessage = "$lat, $long";
    });

    socketConn.updateLocation(lat, long);

  }
  @override
  Widget build(BuildContext context) {
     return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Location using socket io',
        home: Scaffold(
            appBar: AppBar(
                title: Text("Location Sending")
            ),
            body: Align(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(_locationMessage),
                    FlatButton(
                        onPressed: () {
                          getCurrentLocation();
                        },
                        color: Colors.blue,
                        child: Text("Find Location")
                    )
                  ]),
            )
        )
    );
  }
}
