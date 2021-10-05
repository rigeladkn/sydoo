// This is just for check Session;

import 'package:sydoo/screens/onboardingScreen.dart';
import 'package:sydoo/screens/splashScreen.dart';
import 'package:sydoo/services/session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class CheckCurrentUser extends StatefulWidget {
  _CheckCurrentUserState createState() => _CheckCurrentUserState();
}

class _CheckCurrentUserState extends State<CheckCurrentUser> {
  String token;

  void getToken() async {
    var tok = await Session().getSessionToken();
    setState(() {
      token = tok;
    });
  }
  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return token == null ? Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CupertinoActivityIndicator(),),
    ) : token == "" ? Onboarding() : Onboarding();
  }

}
