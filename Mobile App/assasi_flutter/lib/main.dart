import 'package:flutter/material.dart';
import 'package:asaasi/screens/HomeScreen.dart';
import 'package:asaasi/screens/WmsScreen.dart';

void main() => runApp(MyApp());

String url = "https://3dc8e8e1.ngrok.io/geoserver/www/map_online.html";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asaase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      initialRoute: '/google',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/google': (context) => HomeScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/wms_google': (context) =>  WmsScreen(websiteUrl: url),
      },
    );
  }
}
