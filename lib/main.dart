import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(35.6580339, 139.7016358),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 0.0,
      target: LatLng(35.6580339, 139.7016358),
      // tilt: 59.440717697143555,
      zoom: 14.4746);

  static const LatLng _marker1 = LatLng(35.6510339, 139.7046358);
  static const LatLng _marker2 = LatLng(35.6612339, 139.7003358);

  Set<Marker> _createMarker() {
    return {
      const Marker(
        markerId: MarkerId("marker_1"),
        position: _marker1,
        infoWindow: InfoWindow(title: "施設1", snippet: 'よい施設'),
      ),
      const Marker(
        markerId: MarkerId("marker_2"),
        position: _marker2,
        infoWindow: InfoWindow(title: "施設2", snippet: 'そこそこの施設'),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        buildingsEnabled: false,
        markers: _createMarker(),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToHome,
        label: const Text('Home'),
        icon: const Icon(Icons.home),
      ),
    );
  }

  Future<void> _goToHome() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
