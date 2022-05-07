import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'TestPage2.dart';

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
  final _pageController = PageController(viewportFraction: 0.80);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  static const initialPosition = LatLng(35.6580339, 139.7016358);
  static const northEastPosition = LatLng(35.6684577, 139.7102433);
  static const southWestPosition = LatLng(35.6200000, 139.6200000);

  static const CameraPosition _homePosition = CameraPosition(
      bearing: 0.0,
      target: LatLng(35.6580339, 139.7016358),
      // tilt: 59.440717697143555,
      zoom: 14);

  List documents = [
    {
      'itemKey': GlobalKey(),
      'markerId': '1',
      'position': const LatLng(35.6612339, 139.7003358),
      'infoWindow': const InfoWindow(title: "施設1", snippet: 'いい施設'),
      'name': '施設1',
      'address': '渋谷区1丁目',
      'rate': '4.0',
    },
    {
      'itemKey': GlobalKey(),
      'markerId': '2',
      'position': const LatLng(35.6510339, 139.6996358),
      'infoWindow': const InfoWindow(title: "施設2", snippet: 'そこそこの施設'),
      'name': '施設2',
      'address': '渋谷区2丁目',
      'rate': '3.0',
    },
    {
      'itemKey': GlobalKey(),
      'markerId': '3',
      'position': const LatLng(35.6510339, 139.7043358),
      'infoWindow': const InfoWindow(title: "施設3", snippet: 'そこそこの施設'),
      'name': '施設3',
      'address': '渋谷区3丁目',
      'rate': '3.0',
    },
    {
      'itemKey': GlobalKey(),
      'markerId': '4',
      'position': const LatLng(35.6410339, 139.7046358),
      'infoWindow': const InfoWindow(title: "施設4", snippet: 'そこそこの施設'),
      'name': '施設4',
      'address': '渋谷区4丁目',
      'rate': '5.0',
    },
    {
      'itemKey': GlobalKey(),
      'markerId': '5',
      'position': const LatLng(35.6310339, 139.6746358),
      'infoWindow': const InfoWindow(title: "施設5", snippet: 'そこそこの施設'),
      'name': '施設5',
      'address': '渋谷区5丁目',
      'rate': '2.0',
    },
  ];

  _goToSetting() {
    print("tapped setting!");
  }

  void markerTapped(index) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 100),
          curve: Curves.bounceInOut);
    }
  }

  int _selectedIndex = 0;
  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              // margin: const EdgeInsets.only(top: 6),
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 150,
              child: SizedBox(
                child: PageView.builder(
                  // scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          print('GestureDetector on tap card to detail page');
                          print(documents[index]);
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return PlaceDetail(
                                index: index, document: documents[index]);
                          }));
                        },
                        child: Container(
                            // fit: BoxFit.fitHeight,
                            // width: 240,
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Material(
                                color: Colors.white,
                                elevation: 14.0,
                                borderRadius: BorderRadius.circular(24.0),
                                shadowColor: Color(0x802196F3),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 180,
                                      height: 180,
                                      padding: const EdgeInsets.only(
                                          top: 14,
                                          bottom: 14,
                                          left: 14,
                                          right: 0),
                                      child: ClipRRect(
                                        borderRadius:
                                            new BorderRadius.circular(24.0),
                                        child: Image(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              'https://images.unsplash.com/photo-1504940892017-d23b9053d5d4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60'),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 14,
                                            bottom: 14,
                                            left: 12,
                                            right: 8),
                                        child: cardDetail(
                                          documents[index]['name'],
                                          documents[index]['rate'],
                                          documents[index]['address'],
                                        ),
                                      ),
                                    ),
                                  ],
                                ))));
                  },
                  onPageChanged: (index) async {
                    print('onPageChanged card');
                    print(documents[index]['name']);
                    print(documents[index]['itemKey']);

                    final controller = await _mapController.future;
                    controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: documents[index]['position'],
                          zoom: 14,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ]);
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToHome,
        label: const Text('Home'),
        icon: const Icon(Icons.home),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_location_alt_outlined),
            activeIcon: Icon(Icons.edit_location_alt),
            label: 'マップ',
            tooltip: "This is a Map Page",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            activeIcon: Icon(Icons.business),
            label: 'リスト',
            tooltip: "This is a List Page",
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            activeIcon: Icon(Icons.person),
            label: 'マイページ',
            tooltip: "This is a My Page",
            backgroundColor: Colors.pink,
          ),
        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        enableFeedback: true,
        iconSize: 17,
        // landscapeLayout: 省略
        selectedFontSize: 18,
        selectedIconTheme: const IconThemeData(size: 30, color: Colors.white),
        selectedLabelStyle: const TextStyle(color: Colors.white),
        selectedItemColor: Colors.white,
        unselectedFontSize: 15,
        unselectedIconTheme:
            const IconThemeData(size: 25, color: Colors.white70),
        unselectedLabelStyle: const TextStyle(color: Colors.white70),
        unselectedItemColor: Colors.white70,
      ),
    );
  }

  Widget cardDetail(String restaurantName, String rate, String address) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Container(
              alignment: Alignment.topLeft,
              child: Text(
                restaurantName,
                style: const TextStyle(
                    color: Color.fromARGB(255, 17, 1, 41),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              )),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                child: Text(
              rate,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15.0,
              ),
            )),
            for (int i = 1; i < 6; i++)
              // if (i == 0) Text("a") else Text("b"),
              if (i <= double.parse(rate))
                Container(
                  child: const Icon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                )
              else
                Container(
                  child: const Icon(
                    FontAwesomeIcons.solidStar,
                    color: Color.fromARGB(255, 207, 207, 207),
                    size: 15.0,
                  ),
                ),
            // コメント数
            // Container(
            //     child: const Text(
            //   "(946)",
            //   style: TextStyle(
            //     color: Colors.black54,
            //     fontSize: 18.0,
            //   ),
            // )),
          ],
        )),
        const SizedBox(height: 5.0),
        Container(
            child: Text(
          address,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 15.0,
          ),
        )),
        const SizedBox(height: 5.0),
        Container(
            child: const Text(
          "9:00-17:00",
          style: TextStyle(
              color: Colors.black54,
              fontSize: 15.0,
              fontWeight: FontWeight.bold),
        )),
      ],
    );
  }

  Future<void> _goToHome() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_homePosition));
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
          .asMap()
          .keys
          .toList()
          .map((index) => Marker(
                markerId: MarkerId(documents[index]['markerId'] as String),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueCyan),
                position: documents[index]['position'],
                // infoWindow: InfoWindow(
                //   title: documents[index]['name'] as String?,
                //   snippet: documents[index]['address'] as String?,
                // ),
                onTap: () => {print("marker tapped"), markerTapped(index)},
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

class PlaceDetail extends StatefulWidget {
  const PlaceDetail({
    Key? key,
    required this.document,
    required this.index,
  }) : super(key: key);

  final index;
  final document;

  @override
  State<StatefulWidget> createState() {
    return _PlaceDetailState();
  }
}

class _PlaceDetailState extends State<PlaceDetail> {
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("施設詳細"),
        ),
        body: Column(
          children: [
            Text(widget.document['name'] as String),
            Text(widget.document['address'] as String),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(8),
              child: Text(widget.document['rate'] as String),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                  onPressed: () => {Navigator.of(context).pop()},
                  child: const Text("戻る", style: TextStyle(fontSize: 30))),
            ),
          ],
        ));
  }
}
