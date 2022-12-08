import 'package:centerfascia_application/constant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../constant.dart';

  Future<String?> loadEvs(double lat, double lng) async {
    // 좌표로 주소 구하기
    String gpsUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat'
        ',$lng&key=$API_KEY';
    final responseGps = await http.get(Uri.parse(gpsUrl));
    var gpsjson = convert.jsonDecode(responseGps.body);
    var placeId = gpsjson['candidates'][0]['placeid']  as String;

    return placeId;
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  Future<List<String>?> getPlaceDetail(String placeId, String token) async {
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/details/json';
    String url =
        '$baseUrl?key=$API_KEY&place_id=$placeId&language=ko&sessiontoken=$token';

    final http.Response response = await http.get(Uri.parse(url));
    final responseData = convert.jsonDecode(response.body);
    final result = responseData['result'];
  }

  Future<List<String>?> getAddrFromLocation(double lat, double lng) async {
    final String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
    String url = '$baseUrl?latlng=$lat,$lng&key=$API_KEY&language=ko';

    final http.Response response = await http.get(Uri.parse(url));
    final responseData = convert.jsonDecode(response.body);
    final formattedAddr = responseData['results'][0]['formatted_address'];
  }

  String getStaticMap(double latitude, double longitude) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$API_KEY';
  }
