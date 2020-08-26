import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

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
  double _direction;
  BitmapDescriptor carIcon;
  Set<Marker> markers = Set();
  Geolocator _geolocator;
  Position _position;
  int x = 0;
  LatLng location;

  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(-33.4479439, -70.598717),
    zoom: 16.4746,
  );

  void checkPermission() {
    _geolocator.checkGeolocationPermissionStatus().then((status) {
      print('status: $status');
    });
    _geolocator
        .checkGeolocationPermissionStatus(
            locationPermission: GeolocationPermission.locationAlways)
        .then((status) {
      print('always status: $status');
    });
    _geolocator.checkGeolocationPermissionStatus(
        locationPermission: GeolocationPermission.locationWhenInUse)
      ..then((status) {
        print('whenInUse status: $status');
      });
  }

  void updateLocation() async {
    try {
      Position newPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .timeout(new Duration(seconds: 5));
      setState(() {
        _position = newPosition;
        if (_position != null) {
          location = new LatLng(_position.latitude, _position.longitude);
        }
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(platform: TargetPlatform.android),
            "assets/car.png")
        .then((onValue) {
      carIcon = onValue;
    });
    FlutterCompass.events.listen((double direction) {
      setState(() {
        _direction = direction;
      });
    });
      location = new LatLng(0, 0);

    _geolocator = Geolocator();
    LocationOptions locationOptions = LocationOptions(
        accuracy: LocationAccuracy.high, distanceFilter: 1, timeInterval: 500);

    checkPermission();
    updateLocation();


    _geolocator.getPositionStream(locationOptions).listen((Position position) {
      _position = position;
      print("asdasdsadasdsadsad********************");
      setState(() {
        _position = position;
        if (_position != null) {
          location = new LatLng(_position.latitude, _position.longitude);
          x = x + 1;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    markers.addAll([
      Marker(
          markerId: MarkerId('value'),
          position: location,
          icon: carIcon,
          rotation: _direction),
    ]);
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              initialCameraPosition: _initialCameraPosition,
              markers: markers),
          Center(
            child: Text(
                'Latitude: ${_position != null ? _position.latitude.toString() : '0'},'
                ' Longitude: ${_position != null ? _position.longitude.toString() : '0'} x: ${x.toString()}'),
          )
        ],
      ),
    );
  }
}
