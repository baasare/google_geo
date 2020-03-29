import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const kGoogleApiKey = "AIzaSyCzLf_rx6fMgUPbOOHW4IRhdLDwiBB-UVc";

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController mapController;
  static const LatLng _center = const LatLng(5.6549934, -0.1842592);
  MapType _currentMapType = MapType.normal;
  final Map<String, Marker> _myMarkers = {};
  LatLng _lastMapPosition = _center;

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
//    _controller.complete(controller);
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    setState(() {
      _myMarkers.clear();
      final marker = Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Current Location'),
      );
      _myMarkers["Current Location"] = marker;
    });

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            tilt: 50.0,
            bearing: 45.0,
            zoom: 30.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('Asaase'),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.threesixty,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/wms_google');
                  }
              )
            ],
          ),
          body: Stack(
            children: <Widget>[
              GoogleMap(
                onCameraMove: _onCameraMove,
                onMapCreated: _onMapCreated,
                mapType: _currentMapType,
                markers: _myMarkers.values.toSet(),
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
              ),
            ],
          ),
          floatingActionButton: SpeedDial(
            // both default to 16
            marginRight: 18,
            marginBottom: 20,
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            // this is ignored if animatedIcon is non null
            // child: Icon(Icons.add),
            visible: true,
            // If true user is forced to close dial manually
            // by tapping main button and overlay is not rendered.
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            onOpen: () => print('OPENING DIAL'),
            onClose: () => print('DIAL CLOSED'),
            tooltip: 'Speed Dial',
            heroTag: 'speed-dial-hero-tag',
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 8.0,
            shape: CircleBorder(),
            children: [
              SpeedDialChild(
                  child: Icon(Icons.map),
                  backgroundColor: Colors.red,
                  label: 'Layers',
                  labelStyle: TextStyle(fontSize: 18.0),
                  onTap: _onMapTypeButtonPressed),
              SpeedDialChild(
                child: Icon(Icons.my_location),
                backgroundColor: Colors.blue,
                label: 'Location',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: _getLocation,
              ),
            ],
          ),
        ));
  }
}
