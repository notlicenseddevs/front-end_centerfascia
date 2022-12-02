import 'package:flutter/material.dart';

//global variable들 저장해놓는곳
//variables.dart import 한뒤에
//appData.변수명 쓰면 사용 가능하다

class Appdata {
  static final _appData = new Appdata._internal();
  Color glocol = Colors.red;
  var gloleftang = 30;
  var glorightang = 30;
  var glorearang = 30;
  var topang = 90;
  var botdist = 50;

  bool user_auth = true;
  factory Appdata() {
    return _appData;
  }
  Appdata._internal();
}

final appData = Appdata();
