import 'package:flutter/material.dart';

class HW_Control extends StatefulWidget{
  const HW_Control({Key? key}) : super(key: key);

  @override
  State<HW_Control> createState() => _HW_ControlState();
}


class _HW_ControlState extends State<HW_Control>{
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black45,
          centerTitle: true,
          elevation: 0,
          leading: Container(),
          title: Text('HW_Control'),
        ),
        body: Container(

        )
    );
  }
}
