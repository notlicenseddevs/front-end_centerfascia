import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class HW_Light extends StatefulWidget {
  const HW_Light({Key? key}) : super(key: key);

  @override
  State<HW_Light> createState() => _HW_LightState();
}

class _HW_LightState extends State<HW_Light> {
  Color _color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text(widget.title),
      ),*/
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                color: _color,
                child: const Center(
                  child: Text(
                    "Lighting",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ColorPicker(
                pickerColor: _color,
                onColorChanged: (Color color) {
                  setState(() {
                    _color = color;
                  });
                },
                pickerAreaHeightPercent: 0.9,
                enableAlpha: true,
                paletteType: PaletteType.hsvWithHue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}