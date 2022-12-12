//import 'dart:html';

import 'dart:async';

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
        //body: Column(children: [
        body: Row(children: [
          Expanded(
              //child: Row(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                Text(
                  "반갑습니다, ${appData.user_id}님",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                Spacer(flex: 2),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                  child: ElevatedButton.icon(
                    label: Text('HW Control'),
                    icon: ImageIcon(AssetImage('image/car_pic.png')),

                    onPressed: () {
                      Navigator.pushNamed(context, '/hw_control',
                          arguments: {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff003984),
                      //fixedSize: const Size(216, 429),
                      fixedSize: const Size(429, 100),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    //child: Column(children: [
                    //Image.asset('image/car_pic.png'),
                    //child: Text("hw control"),

                    //])
                  ),
                ),
                Spacer(flex: 2),
                Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                    child: ElevatedButton.icon(
                        label: Text('GPS'),
                        //icon: ImageIcon(AssetImage('image/google_maps.png')),
                        icon: Icon(Icons.location_on, color: Colors.red),
                        onPressed: () {
                          if (appData.pinauth == false) {
                            Navigator.pushNamed(context, '/pinauth',
                                arguments: {});
                          } else {
                            Navigator.pushNamed(context, '/google_maps',
                                arguments: {});
                          }
                        },
                        //child: Text("gmps control"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffF6CF65),
                          //fixedSize: const Size(216, 429),
                          fixedSize: const Size(429, 100),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ))),
                Spacer(flex: 2),
                Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                    child: ElevatedButton.icon(
                        label: Text('Youtube'),
                        //icon: ImageIcon(AssetImage('image/google_maps.png')),
                        icon: Icon(Icons.play_circle_fill, color: Colors.black),
                        onPressed: () {

                          StreamController<dynamic> pldata = StreamController();
                          String plrequest = '{"cmd_type":4, "refresh_target":1}';
                          String id;
                          String playlistName;
                          String playlistUrl;

                          mqtt.PlaylistRequest(plrequest, pldata);
                          pldata.stream.listen((v){
                            print('Youtube Playlist listen Started');
                            for(int k=0;k<v['playlist'].length;k++){
                              id = v['playlist'][k]['_id'];
                              playlistName = v['playlist'][k]['name'];
                              playlistUrl = v['playlist'][k]['url'];
                              appData.playlist.add({'_id':id, 'name':playlistName, 'url':playlistUrl});
                            }
                            print(appData.playlist);
                          });





                          Navigator.pushNamed(context, '/youtube_playlist',
                              arguments: {});
                        },
                        //child: Text("Youtube"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffff0000),
                          //fixedSize: const Size(216, 429),
                          fixedSize: const Size(429, 100),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ))),
                Spacer(flex: 2),
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
                      backgroundColor: Color.fromARGB(255, 134, 128, 134),
                      fixedSize: const Size(429, 100),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    //child: Column(children: [
                    //Image.asset('image/car_pic.png'),
                    child: Text("LOGOUT"),
                    //child: Text("${appData.user_id}"),
                    //])
                  ),
                ),
                Spacer(flex: 2),
              ])),
        ]));
  }
}
