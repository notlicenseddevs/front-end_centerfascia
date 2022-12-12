import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';

import 'package:rsa_encrypt/rsa_encrypt.dart';
//global variable들 저장해놓는곳
//variables.dart import 한뒤에
//appData.변수명 쓰면 사용 가능하다

class HexColor extends Color {
  //Color color1 = HexColor("b74093");
//Color color2 = HexColor("#b74093");
//Color color3 = HexColor("#88b74093"); // If you wish to use ARGB format
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class Appdata {
  static final _appData = new Appdata._internal();
  //초기화할것
  Color glocol = Color(0xFF42A5F5); //HexColor("FF42A5F5");
  String user_id = '';
  late final RSAPublicKey serverpublickey;
  late final pair;
  late final RSAPublicKey public;
  late final RSAPrivateKey private;
  late String androidID;
  var gloleftang = 30;
  var glorightang = 30;
  var glorearang = 30;
  var topang = 90;
  var botdist = 50;
  var glowheelheight = 50;
  var hwjson;
  late dynamic facejson;
  bool pinauth = false;
  //초기화할것

  //Youtube Playlist Variables

  List<Map<String, String>> places = [
    {
      "_id" : "",
      "place_name" : "Sogang University",
      "describe" : "Shared by GoogleMaps",
      "latitude" : "37.5509442",
      "longitude" : "126.9410023",
      "gmap_link": "https://www.google.com/maps/place/%EC%84%9C%EA%B0%95%EB%8C%80%ED%95%99%EA%B5%90/data=!3m1!4b1!4m5!3m4!1s0x357c9914ca252349:0x715875d4af1d5974!8m2!3d37.5509442!4d126.9410023",
    },{
      "_id" : "",
      "place_name" : "Choiga",
      "describe" : "Shared by GoogleMaps",
      "latitude" : "37.3689003",
      "longitude" : "127.1064754",
      "gmap_link": "https://www.google.com/maps/place/%EC%B5%9C%EA%B0%80%EB%8F%88%EA%B9%8C%EC%8A%A4/data=!3m1!4b1!4m5!3m4!1s0x357b58365aba8a8f:0x433be9720ba13dbc!8m2!3d37.3689003!4d127.1064754",
    },
  ];
  //Google Maps Variables

  List<Map<String, String>> playlist = [
    {
      "_id" : "",
      "name" : "Driving Playlist",
      "url" : "https://youtube.com/playlist?list=PLny_cRknRBbU2gE1T7qZUCzE8YLguLCrF",
    },
    {
      "_id" : "",
      "name" : "Famoust Pop Playlist",
      "url" : "https://youtube.com/playlist?list=PLCg-HiP2W_KNOp1aFXms57EH2teADOSqD",
    },
  ];

  factory Appdata() {
    return _appData;
  }
  Appdata._internal();
}

final appData = Appdata();
