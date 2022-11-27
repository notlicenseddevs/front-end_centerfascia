//import 'dart:html';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';


class GoogleMaps extends StatefulWidget{
  const GoogleMaps({Key? key}) : super(key: key);

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}


class _GoogleMapsState extends State<GoogleMaps>{
  late GoogleMapController mapController;
  //init state, sogang_university
  final LatLng _center = const LatLng(37.556909,126.9378836);

  Set<Marker> _markers = Set();
  GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  CameraPosition _initialCameraPostion = CameraPosition(
    target: LatLng(37.382782, 127.1189054),
    zoom: 14,
  );
  Location _location = Location();


  static const List<List<String>> productList = [
    ['집', '10', '20', 'www.naver.com' ],
    ['학교', '20', '30', 'www.google.com' ],
    ['맛집', '30', '40', 'www.daum.com' ],
    ['맛집', '60', '90', 'www.daum.com' ],
    ['맛집', '70', '70', 'www.daum.com' ],
    ['맛집', '80', '50', 'www.daum.com' ],
    ['맛집', '90', '10', 'www.daum.com' ],
    ['맛집', '100', '20', 'www.daum.com' ],
    ['종점', '40', '50', 'www.bing.com' ]
  ];


  @override
  void initState() {
    super.initState();

    _markers.add(
      Marker(markerId: MarkerId('myInitialPosition'), position: LatLng(37.382782, 127.1189054),
        infoWindow: InfoWindow(title: 'My Position', snippet: 'Where am I?'),)
    );

  }

  //mapcreated
  void _onMapCreated(GoogleMapController controller){
    mapController = controller;/*
    _location.onLocationChanged.listen((l) {
      l.latitude;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom:15),
          ),
        );
    });*/
  }


  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GoogleMap(
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 14.0,
                  ),
                  markers: _markers,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: ListView.builder(
                  itemCount: productList.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                      margin: EdgeInsets.only(top: 10),
                      color: Colors.cyanAccent,
                      width:100,
                      height:70,
                      padding:EdgeInsets.all(0),
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(productList[index][0]),
                          Text(productList[index][1]),
                          Text(productList[index][2]),
                          Text(productList[index][3]),
                        ]
                      )
                    );
                  },

              ),

            )
          ],
        )
    );
  }
}
