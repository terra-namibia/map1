import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  final Completer<GoogleMapController> _mapController = Completer();

  static const initialPosition = LatLng(35.6580339, 139.7016358);
  static const northEastPosition = LatLng(35.6684577, 139.7102433);
  static const southWestPosition = LatLng(35.6483480, 139.6928290);

  static const CameraPosition _home = CameraPosition(
      bearing: 0.0,
      target: LatLng(35.6580339, 139.7016358),
      // tilt: 59.440717697143555,
      zoom: 14);

  List documents = [
    {
      'itemKey': GlobalKey(),
      'markerId': 'marker_1',
      'position': const LatLng(35.6612339, 139.7003358),
      'infoWindow': const InfoWindow(title: "施設1", snippet: 'いい施設'),
      'name': '施設1',
      'address': '渋谷区1丁目',
    },
    {
      'itemKey': GlobalKey(),
      'markerId': 'marker_2',
      'position': const LatLng(35.6510339, 139.7046358),
      'infoWindow': const InfoWindow(title: "施設2", snippet: 'そこそこの施設'),
      'name': '施設2',
      'address': '渋谷区2丁目',
    }
  ];

  _goToSetting() {
    print("tapped setting!");
  }

  void markerTapped(document) {
    final context = document['itemKey'].currentContext!;
    Scrollable.ensureVisible(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: const [
          Icon(Icons.edit_location_outlined),
          Text("地図アプリ"),
        ]),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _goToSetting,
          )
        ],
      ),
      body: Builder(builder: (context) {
        return Stack(children: [
          StoreMap(
            documents: documents,
            initialPosition: initialPosition,
            northEastPosition: northEastPosition,
            southWestPosition: southWestPosition,
            mapController: _mapController,
            markerTapped: markerTapped,
          ),
          // SizedBox(
          //   height: 90,
          //   child: ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     itemCount: documents.length,
          //     itemBuilder: (context, index) {
          //       return SizedBox(
          //         width: 340,
          //         child: Padding(
          //           padding: const EdgeInsets.only(left: 8),
          //           child: Card(
          //             child: Container(
          //               height: 90,
          //               child: Center(
          //                   child: ListTile(
          //                 key: documents[index]['itemKey'],
          //                 title: Text('${documents[index]['name']}'),
          //                 subtitle: Text('${documents[index]['itemKey']}'),
          //                 onTap: () async {
          //                   final context =
          //                       documents[index]['itemKey'].currentContext!;
          //                   await Scrollable.ensureVisible(context);
          //                   final controller = await _mapController.future;
          //                   await controller.animateCamera(
          //                     CameraUpdate.newCameraPosition(
          //                       CameraPosition(
          //                         target: documents[index]['position'],
          //                         zoom: 14,
          //                       ),
          //                     ),
          //                   );
          //                 },
          //               )),
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),

          StoreCarousel(
            mapController: _mapController,
            documents: documents,
          ),
        ]);
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToHome,
        label: const Text('Home'),
        icon: const Icon(Icons.home),
      ),
    );
  }

  Future<void> _goToHome() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_home));
  }

  _handleTap(LatLng tappedPoint) {
    print("_handleTapしたよ");
    print(tappedPoint);
  }
}

class StoreCarousel extends StatelessWidget {
  const StoreCarousel({
    Key? key,
    required this.documents,
    required this.mapController,
  }) : super(key: key);

  final List documents;
  final Completer<GoogleMapController> mapController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SizedBox(
          height: 90,
          child: StoreCarouselList(
            documents: documents,
            mapController: mapController,
          ),
        ),
      ),
    );
  }
}

class StoreCarouselList extends StatelessWidget {
  StoreCarouselList({
    Key? key,
    required this.documents,
    required this.mapController,
  }) : super(key: key);

  final List documents;
  final Completer<GoogleMapController> mapController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: documents.length,
      itemBuilder: (context, index) {
        return SizedBox(
          width: 340,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Card(
              child: Center(
                child: StoreListTile(
                  document: documents[index],
                  mapController: mapController,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class StoreListTile extends StatefulWidget {
  const StoreListTile({
    Key? key,
    required this.document,
    required this.mapController,
  }) : super(key: key);

  final document;
  final Completer<GoogleMapController> mapController;

  @override
  State<StatefulWidget> createState() {
    return _StoreListTileState();
  }
}

class _StoreListTileState extends State<StoreListTile> {
  String _placePhotoUrl = '';
  var _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.document['name'] as String),
      subtitle: Text(widget.document['address'] as String),
      key: widget.document['itemKey'],
      leading: SizedBox(
        width: 100,
        height: 100,
        child: _placePhotoUrl.isNotEmpty
            ? ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                child: Image.network(_placePhotoUrl, fit: BoxFit.cover),
              )
            : Container(),
      ),
      onTap: () async {
        // await _scrollController.animateTo(
        //   0,
        //   duration: const Duration(seconds: 1),
        //   curve: Curves.linear,
        // );
        print(widget.document['itemKey']);
        final context = widget.document['itemKey'].currentContext!;
        await Scrollable.ensureVisible(context);

        final controller = await widget.mapController.future;
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: widget.document['position'],
              zoom: 14,
            ),
          ),
        );
      },
    );
  }
}

class StoreMap extends StatelessWidget {
  const StoreMap({
    Key? key,
    required this.documents,
    required this.initialPosition,
    required this.northEastPosition,
    required this.southWestPosition,
    required this.mapController,
    required this.markerTapped,
  }) : super(key: key);

  final List documents;
  final LatLng initialPosition;
  final LatLng northEastPosition;
  final LatLng southWestPosition;
  final Completer<GoogleMapController> mapController;
  final markerTapped;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 14,
      ),
      cameraTargetBounds: CameraTargetBounds(LatLngBounds(
        northeast: northEastPosition,
        southwest: southWestPosition,
      )),
      markers: documents
          .map((document) => Marker(
                markerId: MarkerId(document['markerId'] as String),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueCyan),
                position: document['position'],
                infoWindow: InfoWindow(
                  title: document['name'] as String?,
                  snippet: document['address'] as String?,
                ),
                onTap: () => {print("marker tapped"), markerTapped(document)},
              ))
          .toSet(),
      onMapCreated: (mapController) {
        this.mapController.complete(mapController);
      },
      onTap: (LatLng latLng) {
        print('map tapped');
      },
    );
  }
}
