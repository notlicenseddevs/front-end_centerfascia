import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:centerfascia_application/pages/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:centerfascia_application/variables.dart';
import 'package:centerfascia_application/mqtt_client.dart';
import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';

import 'package:camera/camera.dart';

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
    return Scaffold(
      body: Container(
          child: Row(children: [
        Container(
            height: 500,
            width: 600,
            child: controller == null
                ? Center(child: Text("Loading Camera..."))
                : !controller!.value.isInitialized
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : CameraPreview(controller!)),
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
                    mqtt.cameraRequest(facemsg, check);
                  });
                  check.stream.listen((v) => {
                        setState(() {
                          _authrequest = false;
                          _iscorrect = v;
                          _iswrong = !v;
                          if (!_authrequest && _iscorrect && !_iswrong) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home()));
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
        camauthResult(),
        /*Container(
          //show captured image
          padding: EdgeInsets.all(30),
          child: image == null
              ? Text("No image captured")
              : Image.file(File(image!.path), height: 500, width: 300),
          //display captured image
        )*/
      ])),
    );
  }

  Widget camauthResult() {
    if (_authrequest) {
      return const CircularProgressIndicator();
    }
    if (_authrequest && !(_iscorrect ^ _iswrong)) {
      print("HHHHHHHHIIIIIIIIIIIIII\n");
      return const Text('');
    }
    if (!_authrequest && _iscorrect && !_iswrong) {
      print("CORRRERAERAJWOER\n");
      move = 1;
      //sleep(const Duration(seconds: 10));
      //Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
      //Navigator.pushReplacementNamed(context, '/home');
      //Navigator.of(context).pushNamed("/home");
      //GetX.(() => Home());
      return const Text('User authorized');
    }
    if (!_authrequest && !_iscorrect && _iswrong) {
      /*Fluttertoast.showToast(
        msg: "사용자 식별을 하지 못했습니다. 다시 찍어주세요",
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,s
      );*/
      print("ERRRRRRRRRRRORRRRRRRR\n");
      return const Text('FACE AUTH ERROR');
    }
    print("몰ㄹㄹㄹㄹㄹㄹㄹ루ㅜㅜㅜㅜㅜㅜ");
    return const Text('');
  }
}
