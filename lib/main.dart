import 'package:centerfascia_application/pages/camera.dart';
import 'package:flutter/material.dart';
import 'package:centerfascia_application/pages/home.dart';
import 'package:centerfascia_application/pages/hw_control.dart';
import 'package:centerfascia_application/pages/google_maps.dart';
import 'package:centerfascia_application/pages/youtube_playlist.dart';
import 'package:centerfascia_application/pages/logo.dart';
import 'package:centerfascia_application/pages/pin_auth.dart';
import 'mqtt_client.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom, //This line is used for showing the bottom bar
  ]);
  mqttConnection mqtt = mqttConnection();
  try {
    await mqtt.connect().then((e) => {
          runApp(MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: '/camera', //test
              routes: {
                '/home': (context) => Home(),
                '/youtube_playlist': (context) => YoutubePlaylist(),
                '/hw_control': (context) => HW_Control(),
                '/google_maps': (context) => GoogleMaps(),
                '/logo': (context) => Logo(),
                '/camera': (context) => CameraAuth(),
                '/pinauth': (context) => pinAuth(),
              }))
        });
  } catch (e, s) {
    print(s);
  }
}
