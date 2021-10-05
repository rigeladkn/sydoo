import 'package:sydoo/utils/color.dart';
import 'package:flutter/material.dart';

class WikiChatButton extends StatefulWidget {
  bool isColoredBlue = true;
  String text = "";
  GestureTapCallback onTap;

  WikiChatButton({this.isColoredBlue, this.text, this.onTap});

  @override
  _WikiChatButtonState createState() => _WikiChatButtonState();
}

class _WikiChatButtonState extends State<WikiChatButton> {
  Widget coloredBlueButton(BuildContext context) {
    return new GestureDetector(
      child: new Container(
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryBlueColor,
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: new Center(
          child: new Text(
            widget.text,
            style: new TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: "Hellix"),
          ),
        ),
      ),
      onTap: widget.onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return coloredBlueButton(context);
  }
}
