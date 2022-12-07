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
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
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
                          Navigator.pushNamed(context, '/google_maps',
                              arguments: {});
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
              ]))
        ]));
  }
}
