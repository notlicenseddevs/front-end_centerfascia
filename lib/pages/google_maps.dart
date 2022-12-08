import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:centerfascia_application/services/google_map_service.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({Key? key}) : super(key: key);

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  late GoogleMapController mapController;
  //init state, sogang_university
  final LatLng _center = const LatLng(37.556909, 126.9378836);

  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  CameraPosition _initialCameraPostion = CameraPosition(
    target: LatLng(37.382782, 127.1189054),
    zoom: 14,
  );
  Location _location = Location();

  static const List<List<String>> productList = [
    ['집', '10', '20', 'www.naver.com'],
    ['학교', '37.5509442', '126.9410023', 'www.sogang.ac.kr'],
    ['맛집', '30', '40', 'www.daum.com'],
    ['최가 돈까스', '37.3689003', '127.1064754', 'null'],
    ['찰리스 버거', '37.3686529', '127.1122212', 'null'],
    ['다이호시', '37.384143', '127.1116396', 'www.daum.com'],
  ];

  @override
  void initState() {
    super.initState();
    _markers.add(Marker(
      markerId: MarkerId('myInitialPosition'),
      position: LatLng(37.382782, 127.1189054),
      infoWindow: InfoWindow(title: 'My Position', snippet: 'Where am I?'),
    ));
  }

  var Marker_1 = LatLng(37.898989, 129.362536);

  late final Set<Marker> _markers = {};
  void _addMarker(LatLng pos) async {
    setState(() {
      var _origin = Marker(
        markerId: const MarkerId("origin"),
        infoWindow: const InfoWindow(title: "Origin"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: pos,
      );
    });
  }

  void _createMarker(
      String markerID, double lat, double lng, String url) async {
    var marker_loc = LatLng(lat, lng);
    setState(() {
      _initialCameraPostion = CameraPosition(
        target: marker_loc,
        zoom: 14,
      );
      mapController
          .animateCamera(CameraUpdate.newCameraPosition(_initialCameraPostion));
      var _origin = Marker(
        markerId: MarkerId(markerID),
        position: marker_loc,
        onTap: () {
          _gotoSpace(marker_loc);
        },
        infoWindow: InfoWindow(title: markerID),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
      _markers.clear();
      _markers.add(_origin);
    });
  }

  void submit(){
    _fbKey.currentState?.save();
    final inputValues = _fbKey.currentState?.value;
    final id = inputValues!['place'];
    print(id);
    // 중복 체크 함수 here //

    final placeId = loadEvs(1.0, 1.0);


    Navigator.of(context).pop();
  }
  void _gotoSpace(LatLng marker_loc) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        )),
        builder: (context) {
          return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(
                              top: 30,
                              bottom: 20,
                              right: 20,
                              left: 20,
                            ),
                            child: FormBuilder(
                              key: _fbKey,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("장소를 입력해주세요"),
                                      FormBuilderTextField(name: 'place',
                                        initialValue: "장소 이름",

                                      ),
                                      MaterialButton(
                                        child:Text("SUBMIT"),
                                        color: Colors.blue,
                                        textColor: Colors.white,
                                        onPressed:(){
                                          submit();
                                        }
                                      )
                                    ]),
                              ),
                            ))
                      ])));
        });
  }

  //mapcreated
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black12,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.home),
            onPressed: () async {
          getUserCurrentLocation().then((value) async {
            print(value.latitude.toString() + " " + value.longitude.toString());
            _createMarker("Current Location", value.latitude, value.longitude,
                "www.naver.com");
          });
        }),
        body: Row(
          children: [
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GoogleMap(
                  // 메인 구글 맵스 표시
                  onCameraIdle: () {},
                  onCameraMoveStarted: () {},
                  onTap: (currloc) {
                    _createMarker(
                        "현재위치", currloc.latitude, currloc.longitude, "");
                  },
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: _initialCameraPostion,

                  markers: _markers,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: ListView.builder(
                itemCount: productList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      // show marker when tapped the list
                      //_gotoSpace();
                      _createMarker(
                          productList[index][0],
                          double.parse(productList[index][1]),
                          double.parse(productList[index][2]),
                          productList[index][3]);
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 100,
                        height: 70,
                        padding: EdgeInsets.all(0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productList[index][0],
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                "Lat : ${productList[index][1]} / Lng : ${productList[index][2]}",
                                textScaleFactor: 0.7,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "서울특별시 마포구 백범로 35",
                                textScaleFactor: 0.8,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                productList[index][3],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ])),
                  );
                },
              ),
            )
          ],
        ));
  }
}
