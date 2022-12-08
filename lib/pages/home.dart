import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:centerfascia_application/variables.dart';
import 'dart:convert' as convert;
import 'package:centerfascia_application/mqtt_client.dart';
import 'package:restart_app/restart_app.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

//logout button 만들기. usercommand 10 + hwinfo -> usercommand 11 -> app restart
class _HomeState extends State<Home> {
  mqttConnection mqtt = mqttConnection();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return Scaffold(
        backgroundColor: Colors.grey[850],
        body: Column(children: [
          Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      //logout
                      mqtt.hwsendRequest();
                      mqtt.turnoffRequest();
                      Restart.restartApp();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 253, 0, 232),
                      fixedSize: const Size(30, 30),
                    ),
                    //child: Column(children: [
                    //Image.asset('image/car_pic.png'),
                    child: Text("LOG\nOUT"),
                    //])
                  ),
                ),
                Spacer(flex: 5),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/hw_control',
                          arguments: {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff003984),
                      fixedSize: const Size(216, 429),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    //child: Column(children: [
                    //Image.asset('image/car_pic.png'),
                    child: Text("hw control"),
                    //])
                  ),
                ),
                Spacer(flex: 2),
                Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                    child: ElevatedButton(
                        onPressed: () {
                          if (appData.pinauth == false) {
                            Navigator.pushNamed(context, '/pinauth',
                                arguments: {});
                          } else {
                            Navigator.pushNamed(context, '/google_maps',
                                arguments: {});
                          }
                        },
                        child: Text("gmps control"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffF6CF65),
                          fixedSize: const Size(216, 429),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ))),
                Spacer(flex: 2),
                Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/youtube_playlist',
                              arguments: {});
                        },
                        child: Text("ytp control"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffff0000),
                          fixedSize: const Size(216, 429),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ))),
                Spacer(flex: 5),
              ])),
        ]));
  }
}
