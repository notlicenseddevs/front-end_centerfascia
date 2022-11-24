import 'package:flutter/material.dart';
import 'package:centerfascia_application/pages/home.dart';
import 'package:centerfascia_application/pages/hw_control.dart';
import 'package:centerfascia_application/pages/google_maps.dart';
import 'package:centerfascia_application/pages/youtube_playlist.dart';
import 'package:centerfascia_application/pages/logo.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/logo',
      routes: {
        '/home': (context) => Home(),
        '/youtube_playlist': (context) => YoutubePlaylist(),
        '/hw_control': (context) => HW_Control(),
        '/google_maps': (context) => GoogleMaps(),
        '/logo': (context) => Logo(),
      }));
}
