import 'dart:async';
import 'package:flutter/material.dart';
import 'package:centerfascia_application/variables.dart';

class HW_Seat extends StatefulWidget {
  const HW_Seat({Key? key}) : super(key: key);

  @override
  State<HW_Seat> createState() => _HW_SeatState();
}

class _HW_SeatState extends State<HW_Seat> {
  late Timer _timer;
  var _topang = appData.topang;
  var _botdist = appData.botdist;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "$_topang",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
            //////////////등받이 조절////////////////
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
                      if (_topang > 0) _topang--;
                    });
                  },
                  onTapDown: (TapDownDetails details) {
                    //use timer to decrement value when long-pressed
                    //print('down'); //used for debug
                    _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                      setState(() {
                        if (_topang > 0) _topang--;
                      });
                      //print('value $_topang'); //used for debug
                    });
                  },
                  onTapUp: (TapUpDetails details) {
                    //finish timer when "unpressing" button
                    //print('up'); //used for debug
                    _timer.cancel();
                    appData.topang = _topang;
                  },
                  onTapCancel: () {
                    //몰?루
                    //print('cancel');
                    _timer.cancel();
                    appData.topang = _topang;
                  },
                ),
                Text("등받이", style: TextStyle(fontSize: 25, color: Colors.blue)),
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
                    setState(() {
                      if (_topang > 0) _topang++;
                    });
                  },
                  onTapDown: (TapDownDetails details) {
                    //print('down');
                    _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                      setState(() {
                        if (_topang > 0) _topang++;
                      });
                      //print('value $_topang');
                    });
                  },
                  onTapUp: (TapUpDetails details) {
                    //print('up');
                    _timer.cancel();
                    appData.topang = _topang;
                  },
                  onTapCancel: () {
                    //print('cancel');
                    _timer.cancel();
                    appData.topang = _topang;
                  },
                ),
              ],
            ),
            ////////////////여기까지 등받이 조절/////////////////
            Image.asset('image/seat.png'),
            ////여기는 의자앞뒤 거리 조절//////////////////////
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
                    setState(() {
                      if (_botdist > 0) _botdist--;
                    });
                  },
                  onTapDown: (TapDownDetails details) {
                    //print('down');
                    _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                      setState(() {
                        if (_botdist > 0) _botdist--;
                      });
                      //print('value $_botdist');
                    });
                  },
                  onTapUp: (TapUpDetails details) {
                    //print('up');
                    _timer.cancel();
                    appData.botdist = _botdist;
                  },
                  onTapCancel: () {
                    //print('cancel');
                    _timer.cancel();
                    appData.botdist = _botdist;
                  },
                ),
                Text("앞뒤 조절",
                    style: TextStyle(fontSize: 25, color: Colors.blue)),
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
                    setState(() {
                      if (_botdist > 0) _botdist++;
                    });
                  },
                  onTapDown: (TapDownDetails details) {
                    //print('down');
                    _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                      setState(() {
                        if (_botdist > 0) _botdist++;
                      });
                      //print('value $_botdist');
                    });
                  },
                  onTapUp: (TapUpDetails details) {
                    //print('up');
                    _timer.cancel();
                    appData.botdist = _botdist;
                  },
                  onTapCancel: () {
                    // print('cancel');
                    _timer.cancel();
                    appData.botdist = _botdist;
                  },
                ),
              ],
            ),
            Text(
              "$_botdist",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),

            ///여기까지 의자앞뒤 거리 조절////////////////////
          ],
        ),
      ),
    );
  }
}
