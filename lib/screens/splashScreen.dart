// Splash Screen

import 'package:sydoo/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import '../translations.dart';
import 'checkCurrentUser.dart';
import 'loginScreen.dart';

class SplashScreen extends StatefulWidget {
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreenView(
        navigateRoute: CheckCurrentUser(),
        duration: 3000,
        imageSize: 100,
        imageSrc: "assets/png/img_logo_with_name.png",
        // text: "Skydoo",
        // textType: TextType.ColorizeAnimationText,
        textStyle: TextStyle(
          fontSize: 20.0,
        ),
        // colors: [
        //   Colors.purple,
        //   Colors.blue,
        //   Colors.yellow,
        //   Colors.red,
        // ],
        backgroundColor: primaryBlueColor,
      )
    );
  }

}