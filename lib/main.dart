import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_compass/flutter_compass.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uber Car Rotation Sample',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  double _direction;
  BitmapDescriptor carIcon;
  Set<Marker> markers = Set();

  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(-33.4479439, -70.598717),
    zoom: 16.4746,
  );

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(platform: TargetPlatform.android), "assets/car.png")
        .then((onValue) {
      carIcon = onValue;
    });
    FlutterCompass.events.listen((double direction) {
      setState(() {
        _direction = direction;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    markers.addAll([
      Marker(
          markerId: MarkerId('value'),
          position: LatLng(-33.4479439, -70.598717),
          icon: carIcon,
          rotation: _direction),
    ]);
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
