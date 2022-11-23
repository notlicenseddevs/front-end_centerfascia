import 'package:flutter/material.dart';

class Logo extends StatefulWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  void setupLogo() async{
    Future<void> wait = justforwait();
    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> justforwait(){
    return Future<void>.delayed(Duration(seconds : 3), (){
    });
  }

  void initState(){
    super.initState();
    print('LOGO waiting\n');
    setupLogo();

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Center(
            child:Text(
                "L O G O"
            )
        )
    );
  }
}