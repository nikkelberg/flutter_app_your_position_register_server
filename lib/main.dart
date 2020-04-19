import 'dart:async';
import 'dart:convert';

import 'globals.dart' as globals;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Berguglia & Picone Locator App",
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Berguglia & Picone Locator App",
          ),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              //new GetLocator("1", "1", "NB007CB"),
            ],
          ),
        ),
      ),
    );
  }
}

class GetLocator extends StatefulWidget {
  final String fTrasporto;
  final String fAutista;
  final String fTarga;

  GetLocator(this.fTrasporto, this.fAutista, this.fTarga);

  @override
  GetLocatorState createState() => new GetLocatorState();
}

class GetLocatorState extends State<GetLocator> {
  String url = 'http://scuola.weably.net/posizione.php';
  Geolocator geolocator = Geolocator();
  Position userLocation;

  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation().then((position) {
      userLocation = position;
    });
  }

  Future<String> makeRequest() async {
    print("invio");
    var response = await http.post(
      Uri.encodeFull(url),
      headers: {"Accept": "text/html"},
      body: {
        "fAppCtrFlg": "hfy6389jhg", //chiave di sicurezza per poter scrivere
        "fTrasporto": widget.fTrasporto,
        "fAutista": widget.fAutista,
        "fTarga": widget.fTarga,
        "fData": DateTime.now().toIso8601String(),
        "fLatitudine": userLocation.latitude.toString(),
        "fLongitudine": userLocation.longitude.toString(),
      },
    );
    print(response.body);
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
      print(e);
    }
    return currentLocation;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            userLocation == null
                ? CircularProgressIndicator()
                : Text("Location:" +
                    userLocation.latitude.toString() +
                    " " +
                    userLocation.longitude.toString()),
            RaisedButton(
              onPressed: () {
                _getLocation().then((value) {
                  setState(() {
                    userLocation = value;
                    makeRequest();
                  });
                });
              },
              color: Colors.blue,
              child: Text(
                "Get Location",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
