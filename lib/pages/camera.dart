import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:centerfascia_application/pages/home.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CameraAuth extends StatefulWidget {
  const CameraAuth({Key? key}) : super(key: key);

  @override
  _CameraAuthState createState() => _CameraAuthState();
}

class _CameraAuthState extends State<CameraAuth> {
  File? _image;
  bool user_authorized = false; //서버에서 인증받고 맞으면 홈화면으로 넘어가기
  final picker = ImagePicker();

  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    setState(() {
      _image = File(image!.path); // 가져온 이미지를 _image에 저장
    });

    if (user_authorized == true) {
      //유저인증 완료시 다음페이지로 이동
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      Fluttertoast.showToast(
        msg: "사용자 식별을 하지 못했습니다. 다시 찍어주세요",
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  // 이미지를 보여주는 위젯
  Widget showImage() {
    return Container(
        color: Color.fromARGB(0, 128, 34, 34),
        width: MediaQuery.of(context).size.height,
        height: MediaQuery.of(context).size.width,
        child: Center(
            child: _image == null
                ? Text('No image selected.')
                : Image.file(File(_image!.path))));
  }

  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    return Scaffold(
        backgroundColor: const Color(0x303030),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 25.0),
            showImage(),
            SizedBox(
              height: 50.0,
            ),
            Column(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: (
                      // 카메라 촬영 버튼
                      FloatingActionButton(
                    child: Icon(Icons.add_a_photo),
                    tooltip: 'pick Iamge',
                    onPressed: () {
                      getImage(ImageSource.camera);
                    },
                  )),
                ),

                // 갤러리에서 이미지를 가져오는 버튼
                /*FloatingActionButton(
                  child: Icon(Icons.wallpaper),
                  tooltip: 'pick Iamge',
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                ),*/
              ],
            ),
          ],
        ));
  }
}
