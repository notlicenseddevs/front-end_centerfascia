import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
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
  Color glocol = HexColor("FF42A5F5");
  late final serverpublickey;
  late final pair;
  late final public;
  late final private;
  late AndroidDeviceInfo androidInfo;
  var gloleftang = 30;
  var glorightang = 30;
  var glorearang = 30;
  var topang = 90;
  var botdist = 50;
  var glowheelheight = 50;
  late dynamic facejson;
  bool pinauth = false;
  //초기화할것

  factory Appdata() {
    return _appData;
  }
  Appdata._internal();
}

final appData = Appdata();
