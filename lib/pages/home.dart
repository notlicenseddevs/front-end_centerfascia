import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          backgroundColor: Colors.black12,
          title: Text('Centerfeisa demo'),
          centerTitle: true,
          elevation: 0,
          leading: Container(),
        ),
        body: Column(children: [
          Expanded(
              child: Column(children: <Widget>[
            Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/hw_control', arguments: {});
                  },
                  child: Text("h/w control"),
                )),
            Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/google_maps', arguments: {});
                  },
                  child: Text("gmps control"),
                )),
            Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/youtube_playlist',
                        arguments: {});
                  },
                  child: Text("ytp control"),
                )),
          ]))
        ]));
  }
}
