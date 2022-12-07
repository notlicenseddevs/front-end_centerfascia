import 'package:centerfascia_application/pages/hw_control.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
//https://github.com/sanifhimani/flutter_pin_code_fields
import 'package:flutter/material.dart';
import 'package:centerfascia_application/mqtt_client.dart';
import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:centerfascia_application/pages/google_maps.dart';
import 'package:centerfascia_application/variables.dart';

class pinAuth extends StatefulWidget {
  _pinAuthState createState() => _pinAuthState();
}

class _pinAuthState extends State<pinAuth> {
  TextEditingController newTextEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  bool _iscorrect = false;
  bool _authrequest = false;
  bool _iswrong = false;

  void dispose() {
    newTextEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[850],
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            Text(
              'Pin번호를 입력해 주세요',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[400]),
            ),
            SizedBox(
              height: 40.0,
            ),
            PinCodeFields(
              length: 4,
              controller: newTextEditingController,
              focusNode: focusNode,
              onComplete: (result) {
                // Your logic with code
                StreamController<bool> pincheck = StreamController<bool>();
                mqttConnection mqtt = mqttConnection();
                print(result.runtimeType);
                var sender = int.parse(result);
                //need to encrypt sender later
                String pinmsg = '{"cmd_type":3,"pin_number":$sender}';
                setState(() {
                  _authrequest = true;
                  _iscorrect = false;
                  _iswrong = false;
                  mqtt.pinRequest(pinmsg, pincheck);
                });
                pincheck.stream.listen((v) => {
                      setState(() {
                        _authrequest = false;
                        _iscorrect = v;
                        _iswrong = !v;
                        if (!_authrequest && _iscorrect && !_iswrong) {
                          //if pin is correct
                          appData.pinauth = true;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GoogleMaps()));
                        } else {
                          Fluttertoast.showToast(
                            msg: "Pin번호가 올바르지 않습니다. 다시 입력해주세요",
                            toastLength: Toast.LENGTH_LONG,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      }),
                    });
              },
            ),
            SizedBox(
              height: 80.0,
            ),
            SizedBox(
              height: 50.0,
            ),
          ],
        ));
  }
}
