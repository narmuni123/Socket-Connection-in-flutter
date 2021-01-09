import 'dart:async';
import 'dart:convert';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:geolocator/geolocator.dart';

class SocketConnection {
  SocketIO socketIO;
  dynamic retResp;

  void initState() {
    //Creating the socket
    socketIO = SocketIOManager().createSocketIO(
      '',  // please put your server url here for devices , for emulator use (10.0.2.2:portnumber) as url
      '/',
    );

    // subscribes to an emit event in server change the string i.e. event name according to server
    socketIO.subscribe('', (jsonData){
      Map<String, dynamic> data = json.decode(jsonData);
      print("Printing emit data : " + data.toString());
    });
    //Call init before doing anything with socket
    socketIO.init();
    socketIO.connect();
  }

  // sending message to server with location
  Future<void> sendUpdateLocation(String body) async{
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print(position);
      String lat = (position.latitude).toString();
      String long = (position.longitude).toString();
      String body = jsonEncode({
        "location": {"lat": lat, "long": long} // add the same name location in server
      });

      socketIO.sendMessage('send_message', body, onUpdateLocationResponse);
      await Future.delayed(Duration(seconds: 5));
      // print(body);
      // socketIO.subscribe('teamLeader', onSubscribeResponse);
  }

  Future<void> onUpdateLocationResponse(dynamic response) {
    // print("Response from Server $response");
    // this will act as callback function in sendmessage , which will receive response from server
  }


  Future<void> updateLocation(String lat, String long) async {

    try {
      String body = jsonEncode({
        "location": {"lat": lat, "long": long}
      });
      sendUpdateLocation(body);
    } catch (e) {
      print(e);
      // throw e;
    }
  }


}