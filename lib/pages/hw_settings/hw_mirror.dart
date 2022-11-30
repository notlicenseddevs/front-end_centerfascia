import 'package:flutter/material.dart';
import 'dart:async';
import 'package:centerfascia_application/variables.dart';

class HW_Mirror extends StatefulWidget {
  const HW_Mirror({Key? key}) : super(key: key);

  @override
  State<HW_Mirror> createState() => _HW_MirrorState();
}

class _HW_MirrorState extends State<HW_Mirror> {
  late Timer _timer;
  var _leftang = appData.gloleftang;
  var _rightang = appData.glorightang;
  var _rearang = appData.glorearang;
  final mirrors = Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('image/side-mirror-flipped.png'),
        Image.asset('image/rear-mirror.png', scale: 2),
        Image.asset('image/side-mirror.png'),
      ],
    ),
  );
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Center(
        child: Container(
          child: Column(
            children: [
              mirrors,
              ///////////화살표들 드걔쟤
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('image/left-arrow.png'),
                        ),
                      ),
                    ),
                    onTap: () {
                      //decrement once when pressed
                      setState(() {
                        if (_leftang > 0) _leftang--;
                      });
                    },
                    onTapDown: (TapDownDetails details) {
                      //use timer to decrement value when long-pressed
                      //print('down'); //used for debug
                      _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                        setState(() {
                          if (_leftang > 0) _leftang--;
                        });
                        //print('value $_topang'); //used for debug
                      });
                    },
                    onTapUp: (TapUpDetails details) {
                      //finish timer when "unpressing" button
                      //print('up'); //used for debug
                      _timer.cancel();
                      appData.gloleftang = _leftang;
                    },
                    onTapCancel: () {
                      //몰?루
                      //print('cancel');
                      _timer.cancel();
                      appData.gloleftang = _leftang;
                    },
                  ),
                  Text(
                    "$_leftang",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('image/right-arrow.png'),
                        ),
                      ),
                    ),
                    onTap: () {
                      //decrement once when pressed
                      setState(() {
                        if (_leftang > 0) _leftang++;
                      });
                    },
                    onTapDown: (TapDownDetails details) {
                      //use timer to decrement value when long-pressed
                      //print('down'); //used for debug
                      _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                        setState(() {
                          if (_leftang > 0) _leftang++;
                        });
                        //print('value $_topang'); //used for debug
                      });
                    },
                    onTapUp: (TapUpDetails details) {
                      //finish timer when "unpressing" button
                      //print('up'); //used for debug
                      _timer.cancel();
                      appData.gloleftang = _leftang;
                    },
                    onTapCancel: () {
                      //몰?루
                      //print('cancel');
                      _timer.cancel();
                      appData.gloleftang = _leftang;
                    },
                  ),
                  //leftmirror finishes

                  //RearMirror begins
                  GestureDetector(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('image/left-arrow.png'),
                        ),
                      ),
                    ),
                    onTap: () {
                      //decrement once when pressed
                      setState(() {
                        if (_rearang > 0) _rearang--;
                      });
                    },
                    onTapDown: (TapDownDetails details) {
                      //use timer to decrement value when long-pressed
                      //print('down'); //used for debug
                      _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                        setState(() {
                          if (_rearang > 0) _rearang--;
                        });
                        //print('value $_topang'); //used for debug
                      });
                    },
                    onTapUp: (TapUpDetails details) {
                      //finish timer when "unpressing" button
                      //print('up'); //used for debug
                      _timer.cancel();

                      appData.glorearang = _rearang;
                    },
                    onTapCancel: () {
                      //몰?루
                      //print('cancel');
                      _timer.cancel();
                      appData.glorearang = _rearang;
                    },
                  ),
                  Text(
                    "$_rearang",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('image/right-arrow.png'),
                        ),
                      ),
                    ),
                    onTap: () {
                      //decrement once when pressed
                      setState(() {
                        if (_rearang > 0) _rearang++;
                      });
                    },
                    onTapDown: (TapDownDetails details) {
                      //use timer to decrement value when long-pressed
                      //print('down'); //used for debug
                      _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                        setState(() {
                          if (_rearang > 0) _rearang++;
                        });
                        //print('value $_topang'); //used for debug
                      });
                    },
                    onTapUp: (TapUpDetails details) {
                      //finish timer when "unpressing" button
                      //print('up'); //used for debug
                      _timer.cancel();
                      appData.glorearang = _rearang;
                    },
                    onTapCancel: () {
                      //몰?루
                      //print('cancel');
                      _timer.cancel();
                      appData.glorearang = _rearang;
                    },
                  ),
                  //RearMirror Finishes

                  ////Right Mirror starts
                  GestureDetector(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('image/left-arrow.png'),
                        ),
                      ),
                    ),
                    onTap: () {
                      //decrement once when pressed
                      setState(() {
                        if (_rightang > 0) _rightang--;
                      });
                    },
                    onTapDown: (TapDownDetails details) {
                      //use timer to decrement value when long-pressed
                      //print('down'); //used for debug
                      _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                        setState(() {
                          if (_rightang > 0) _rightang--;
                        });
                        //print('value $_topang'); //used for debug
                      });
                    },
                    onTapUp: (TapUpDetails details) {
                      //finish timer when "unpressing" button
                      //print('up'); //used for debug
                      _timer.cancel();
                      appData.glorightang = _rightang;
                    },
                    onTapCancel: () {
                      //몰?루
                      //print('cancel');
                      _timer.cancel();
                      appData.glorightang = _rightang;
                    },
                  ),
                  Text(
                    "$_rightang",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('image/right-arrow.png'),
                        ),
                      ),
                    ),
                    onTap: () {
                      //decrement once when pressed
                      setState(() {
                        if (_rightang > 0) _rightang++;
                      });
                    },
                    onTapDown: (TapDownDetails details) {
                      //use timer to decrement value when long-pressed
                      //print('down'); //used for debug
                      _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                        setState(() {
                          if (_rightang > 0) _rightang++;
                        });
                        //print('value $_topang'); //used for debug
                      });
                    },
                    onTapUp: (TapUpDetails details) {
                      //finish timer when "unpressing" button
                      //print('up'); //used for debug
                      _timer.cancel();
                      appData.glorightang = _rightang;
                    },
                    onTapCancel: () {
                      //몰?루
                      //print('cancel');
                      _timer.cancel();
                      appData.glorightang = _rightang;
                    },
                  ),
                  ///////////////Right Mirror Finishes
                ],
              ),
              ////////////화살표들 끝
            ],
          ),
        ),
      ),
    );
  }
}
