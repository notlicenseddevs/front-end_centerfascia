import 'package:flutter/material.dart';
import 'package:centerfascia_application/variables.dart';
import 'dart:async';

class HW_handle extends StatefulWidget {
  const HW_handle({Key? key}) : super(key: key);

  @override
  State<HW_handle> createState() => _HW_handleState();
}

class _HW_handleState extends State<HW_handle> {
  late Timer _timer;
  var _botdist = appData.glowheelheight;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('image/steering_wheel.png', width: 256, height: 256),
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
                        image: AssetImage('image/down-arrow.png'),
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
                Text("높이 조절",
                    style: TextStyle(fontSize: 25, color: Colors.blue)),
                GestureDetector(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('image/up-arrow.png'),
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
