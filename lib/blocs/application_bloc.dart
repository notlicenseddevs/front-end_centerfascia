import 'package:centerfascia_application/services/geolocator_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ApplicationBloc with ChangeNotifier{
  final geoLocatorService = GeolocatorService();

  //variables
  late Position currentLocation;

  ApplicationBloc(){
    setCurrentLocation();
  }

  setCurrentLocation() async{
    currentLocation = await geoLocatorService.getCurrentLocation();
    notifyListeners();
  }
}

