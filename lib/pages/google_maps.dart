import 'dart:async';
import 'dart:convert';
import 'package:centerfascia_application/mqtt_client.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:centerfascia_application/services/google_map_service.dart';
import 'package:centerfascia_application/variables.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({Key? key}) : super(key: key);

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  late GoogleMapController mapController;
  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  CameraPosition _initialCameraPostion = CameraPosition(
    target: LatLng(37.382782, 127.1189054),
    zoom: 14,
  );
  Location _location = Location();
  mqttConnection mqtt = mqttConnection();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _markers.add(Marker(
      markerId: MarkerId('myInitialPosition'),
      position: LatLng(37.382782, 127.1189054),
      infoWindow: InfoWindow(title: 'My Position', snippet: 'Where am I?'),
    ));
    loadData(true);

  }
  void loadData(bool doRefresh) async{
    String id;
    String place_name;
    double latitude;
    double longitude;
    String gmap_link;
    String describe;
    StreamController<dynamic> pdata = StreamController();
    String prequest = '{"cmd_type":4, "refresh_target":2}';

    appData.places.removeRange(2, appData.places.length);
    print("print places");
    print(appData.places);
    if(doRefresh) {
      mqtt.placeRequest(prequest, pdata);
    }

    setState(() {});
    pdata.stream.listen((v){
      print('GoogleMaps listen Started');
      print(v);
      if(v != null){
      for(int k=0;k<v.length;k++){
        id = v[k]['_id'];
        place_name = v[k]['place_name']!=null ? v[k]['place_name'] : 'NONE';
        latitude = v[k]['latitude']!=null? v[k]['latitude'] : 0;
        longitude = v[k]['longitude']!=null ? v[k]['longitude'] : 0;
        gmap_link = v[k]['gmap_link']!=null ? v[k]['gmap_link'] : 'NONE';
        describe = v[k]['describe']!=null ? v[k]['describe'] : 'NONE';
        appData.places.add({'_id':id, 'describe':describe, 'latitude':latitude.toString(), 'longitude':longitude.toString(), 'place_name':place_name, 'gmap_link':gmap_link});
      }
      setState(() {
        _loading = false;
      });
    }});

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

  void addLoc(String placename, String describe, LatLng currloc, String url){
    Map<String, dynamic> dt = {
      "place_name" : placename,
      "latitude" : currloc.latitude,
      "longitude" : currloc.longitude,
      "gmap_link": url,
      "describe" : describe,
    };
    String id;
    String place_name;
    double latitude;
    double longitude;
    String gmap_link;
    StreamController<dynamic> pdata = StreamController();
    Map<String, dynamic> msgObj = {
      "cmd_type" : 5,
      "target_list" : 2,
      "item" : dt,
    };
    String msg = jsonEncode(msgObj);
    mqtt.requestToServer(msg);
    Fluttertoast.showToast(
      msg: '해당 장소가 즐겨찾기에 추가되었습니다.',
      gravity: ToastGravity.BOTTOM,

    );
    loadData(false);
  }

  void submit(LatLng currloc) async{
    _fbKey.currentState?.save();
    final inputValues = _fbKey.currentState?.value;
    final id = inputValues!['place'];
    final describe = inputValues!['describe'];
    print(id);
    print(inputValues);
    // 중복 체크 함수 here //

    final placeId = await getPlaceId(currloc.latitude, currloc.longitude);
    var detail = await getPlaceDetail(placeId);
    var url = detail['url'];
    print(url);

    addLoc(id, describe, currloc, url);

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
                                      Text("이름을 입력해주세요",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                      FormBuilderTextField(
                                        name: 'place',
                                        initialValue: "Selected Place",
                                      ),
                                      SizedBox(
                                        height:30,
                                        width:100,
                                      ),
                                      Text("설명을 입력해주세요",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      FormBuilderTextField(
                                        name: 'describe',
                                        initialValue: "Added by User",
                                      ),
                                      MaterialButton(
                                          child: Text("SUBMIT"),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          onPressed: () {
                                            submit(marker_loc);
                                          })
                                    ]),
                              ),
                            ))
                      ])));
        });
  }
  Future _future() async {
    await Future.delayed(Duration(milliseconds: 200));
    return 'WW';
  }
  //mapcreated
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  Widget build(BuildContext context) {


    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.home),
            onPressed: () async {
              getUserCurrentLocation().then((value) async {
                print(value.latitude.toString() +
                    " " +
                    value.longitude.toString());
                _createMarker("Current Location", value.latitude,
                    value.longitude, "www.naver.com");
              });
            }),
        body: Container(
          color : Colors.black87,
          child: Row(
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
                  itemCount: appData.places.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder(
                        future:  loadEvs(double.parse(appData.places[index]['latitude']!),
                            double.parse(appData.places[index]['longitude']!)),
                        builder: (context, snapshot) {
                          print("<show something> : ");
                          String adr = "";
                          if(snapshot.data == null){adr = " ";}
                          else {adr = snapshot.data as String;}
                          if (snapshot.hasData != true) {
                            return Container(
                              width: 100,
                              height: 80,);
                          } else {
                            return Container(
                               child: InkWell(
                                onTap: () {
                                  // show marker when tapped the list
                                  //_gotoSpace();
                                  _createMarker(
                                      appData.places[index]['place_name']!,
                                      double.parse(appData.places[index]['latitude']!),
                                      double.parse(appData.places[index]['longitude']!),
                                      appData.places[index]['gmap_link']!);
                                },
                                child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.black38,
                                        borderRadius: const BorderRadius.all(Radius.circular(12))
                                    ),
                                    margin: EdgeInsets.only(top: 10),
                                    width: 100,
                                    height: 80,
                                    padding: EdgeInsets.all(0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              appData.places[index]['place_name']!,

                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17.0
                                              ),
                                            ),
                                            Text(
                                              "위도 : ${appData.places[index]['longitude']!}   경도 : ${appData.places[index]['latitude']!}",
                                              textScaleFactor: 0.7,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              "$adr",
                                              textScaleFactor: 0.8,
                                              style: TextStyle(
                                                color: Colors.white60,
                                              ),
                                            ),
                                            Text(
                                              appData.places[index]['gmap_link']!,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ]),
                                    )),
                              ),
                            );
                          }
                        });
                  },
                ),
              )
            ],
          ),
        ));
  }
}
