import 'package:flutter/material.dart';
import 'package:centerfascia_application/pages/hw_settings/hw_light.dart';
import 'package:centerfascia_application/pages/hw_settings/hw_mirror.dart';
import 'package:centerfascia_application/pages/hw_settings/hw_seat.dart';
import 'package:centerfascia_application/pages/hw_settings/hw_handle.dart';
//import 'package:centerfascia_application/pages/hw_settings/hw_pop.dart';

class HW_Control extends StatefulWidget {
  const HW_Control({Key? key}) : super(key: key);

  @override
  State<HW_Control> createState() => _HW_ControlState();
}

class _HW_ControlState extends State<HW_Control> {
  int index = 1;
  bool isExtended = false;

  final selectedColor = Colors.white;
  final unselectedColor = Colors.white60;
  final labelStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

  void leave() {
    Navigator.popUntil(context, ModalRoute.withName("/home"));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: Theme.of(context).primaryColor,
              //labelType: NavigationRailLabelType.all,
              selectedIndex: index,
              extended: isExtended,
              //groupAlignment: 0,
              selectedLabelTextStyle: labelStyle.copyWith(color: selectedColor),
              unselectedLabelTextStyle:
                  labelStyle.copyWith(color: unselectedColor),
              selectedIconTheme: IconThemeData(color: selectedColor, size: 50),
              unselectedIconTheme:
                  IconThemeData(color: unselectedColor, size: 50),
              onDestinationSelected: (index) =>
                  setState(() => this.index = index),
              leading: Material(
                clipBehavior: Clip.hardEdge,
                shape: CircleBorder(),
                child: Ink.image(
                  width: 62,
                  height: 62,
                  fit: BoxFit.fitHeight,
                  image: NetworkImage(
                    'https://media.tenor.com/jHvyFefhKmcAAAAd/mujikcboro-seriymujik.gif',
                  ),
                  child: InkWell(
                    onTap: () => setState(() => isExtended = !isExtended),
                  ),
                ),
              ),
              destinations: [
                NavigationRailDestination(
                  icon: Image.asset('image/car_seat.png'),
                  label: Text('?????????'),
                ),
                NavigationRailDestination(
                  icon: Image.asset(
                    'image/side-mirror-256.png',
                  ),
                  label: Text('?????????/?????? ??????'),
                ),
                NavigationRailDestination(
                  icon: Image.asset('image/steering_wheel.png'),
                  label: Text('??????'),
                ),
                NavigationRailDestination(
                  icon: Image.asset('image/lighting.png'),
                  label: Text('?????? ?????????'),
                ),
              ],
            ),
            Expanded(child: buildPages()),
          ],
        ),
      );

  Widget buildPages() {
    //????????? ?????? ???????????? ?????? ?????????
    switch (index) {
      case 0:
        //checkindex();
        return HW_Seat(); //????????? ????????????
      case 1:
        return HW_Mirror(); //??????
      case 2:
        return HW_handle(); //?????? ??????
      case 3:
        return HW_Light(); //??????
      default:
        return HW_Light();
    }
  }
}
///////////?????? ????????? ??????????????? ?????? ?????? ?????????????????? ??????