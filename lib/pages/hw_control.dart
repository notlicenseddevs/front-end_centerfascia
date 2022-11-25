import 'package:flutter/material.dart';
import 'package:centerfascia_application/pages/hw_settings/hw_light.dart';
import 'package:centerfascia_application/pages/hw_settings/hw_mirror.dart';
import 'package:centerfascia_application/pages/hw_settings/hw_seat.dart';

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
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite_border),
                  selectedIcon: Icon(Icons.favorite),
                  label: Text('Favourites'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.face),
                  label: Text('Profile'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
              ],
            ),
            Expanded(child: buildPages()),
          ],
        ),
      );

  Widget buildPages() {
    switch (index) {
      case 0:
        return HW_Control(); //매뉴로 돌아가기
      case 1:
        return HW_Seat(); //하트
      case 2:
        return HW_Control(); //톱니 위에
      default:
        return HW_Seat();
    }
  }
}
