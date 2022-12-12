import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:centerfascia_application/pages/home.dart';
import 'package:centerfascia_application/variables.dart';
import 'package:centerfascia_application/mqtt_client.dart';
import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:camera/camera.dart';
//import 'dart:developer';

class CameraAuth extends StatefulWidget {
  const CameraAuth({Key? key}) : super(key: key);

  @override
  _CameraAuthState createState() => _CameraAuthState();
}

mqttConnection mqtt = mqttConnection();

class _CameraAuthState extends State<CameraAuth> {
  File? _image;
  //bool user_authorized = true; //서버에서 인증받고 맞으면 홈화면으로 넘어가기
  final picker = ImagePicker();

  ///stream
  bool _iscorrect = false;
  bool _authrequest = false;
  bool _iswrong = false;

  bool _picturetaken = false;
  StreamController<bool> check = StreamController<bool>();
  /////
  ///// may be deleted
  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image; //for captured image
  int move = 0;
  //////
  late final stopwatch;
  void initState() {
    loadCamera();
    super.initState();
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![1], ResolutionPreset.max);
      //cameras[0] = first camera, change to 1 to another camera

      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("NO any camera found");
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Container(
          child: Stack(alignment: Alignment.bottomCenter, children: [
        //Spacer(flex: 5),
        Container(
            //alignment: Alignment(0.0, 0.0),
            height: 1200,
            width: 1920,
            child: controller == null
                ? Center(child: Text("Loading Camera..."))
                : !controller!.value.isInitialized
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : CameraPreview(controller!)),

        camauthResult(),
        ElevatedButton.icon(
          //image capture button
          onPressed: () async {
            try {
              if (controller != null) {
                //check if contrller is not null
                if (controller!.value.isInitialized) {
                  //check if controller is initialized
                  image = await controller!.takePicture(); //capture image

                  StreamController<bool> check = StreamController<bool>();
                  mqttConnection mqtt = mqttConnection();
                  Uint8List bytes = await File(image!.path).readAsBytes();
                  String base64bytes = base64.encode(bytes);
                  String facemsg = '{"cmd_type":0,"face_img":"${base64bytes}"}';

                  setState(() {
                    //update UI
                    _picturetaken = true;

                    _authrequest = true;
                    _iscorrect = false;
                    _iswrong = false;
                    //for (int i = 0; i < 100; i++) {
                    mqtt.cameraRequest(facemsg, check);
                    //}
                  });
                  check.stream.listen((v) => {
                        /*if (appData.count <= 100)
                          {// 테스트용도
                            if (appData.count == 1)
                              {
                                appData.count++,
                                stopwatch = Stopwatch()..start()
                              }
                            else
                              {appData.count++},
                            if (appData.count >= 100)
                              {
                                print(
                                    "\n\n\nElapsed: ${stopwatch.elapsed}\n\n\n")
                              }
                          }*/

                        setState(() {
                          _authrequest = false;
                          _iscorrect = v;
                          _iswrong = !v;
                          if (!_authrequest && _iscorrect && !_iswrong) {
                            Fluttertoast.showToast(
                              msg: "반갑습니다 ${appData.user_id}님",
                              toastLength: Toast.LENGTH_LONG,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            //여기다가 hw정보 받고 push 해주자
                            //json 길이가 0이면 걍 default (이미 설정해놓음)
                            StreamController<dynamic> hwdata =
                                StreamController();
                            String hwrequest = '{"cmd_type":8,"waiting_for":0}';
                            mqtt.hwRequest(hwrequest, hwdata);
                            hwdata.stream.listen((v) {
                              print('hhhhhhhhhhhhhhhhhhhhhhhh\n');
                              print(v);
                              //rint(v.length());
                              appData.hwjson = v;
                              if (v['sidemirror_left'] != 0) {
                                appData.gloleftang = v['sidemirror_left'];
                              }
                              if (v['sidemirror_right'] != 0) {
                                appData.glorightang = v['sidemirror_right'];
                              }
                              if (v['seat_depth'] != 0) {
                                appData.botdist = v['seat_depth'];
                              }
                              if (v['seat_angle'] != 0) {
                                appData.topang = v['seat_angle'];
                              }
                              print("test1");
                              if (v['moodlight_color'].length == 17 &&
                                  v['moodlight_color'].length != 0) {
                                int tmp;
                                String tmpstr;
                                tmpstr = v['moodlight_color']
                                    .split('(0x')[1]
                                    .split(')')[0];
                                tmp = int.parse(tmpstr, radix: 16);
                                appData.glocol = new Color(tmp);
                              }
                              print("test2");
                              if (v['backmirror_angle'] != 0) {
                                appData.glorearang = v['backmirror_angle'];
                              }
                            });
                            // TODO get youtube data from the server : wip

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home()));
                          } else {
                            //couldnt find user
                            Fluttertoast.showToast(
                              msg: "사용자인식을 하지 못했습니다. 다시 찍어주세요",
                              toastLength: Toast.LENGTH_LONG,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        }),
                      });
                }
              }
            } catch (e) {
              print(e); //show error
            }
          },
          icon: Icon(Icons.camera),
          label: Text("Capture"),
        ),
      ])),
    );
  }

  Widget camauthResult() {
    if (_authrequest) {
      return const CircularProgressIndicator();
    }
    if (_authrequest && !(_iscorrect ^ _iswrong)) {
      return const Text('');
    }
    if (!_authrequest && _iscorrect && !_iswrong) {
      //return const Text('User authorized');
    }
    if (!_authrequest && !_iscorrect && _iswrong) {
      //return const Text('FACE AUTH ERROR');
    }
    return const Text('');
  }
}
