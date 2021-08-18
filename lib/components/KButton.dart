// This button is all app button widget

import 'package:arsen/utils/color.dart';
import 'package:arsen/utils/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../translations.dart';


// ignore: must_be_immutable
class AAButton extends StatelessWidget {

  AAButton({
    @required this.onTap, // For listen button click
    @required this.hasBackground, // For defined button background
    @required this.title, // Button label (just the name in translation name
    @required this.isMiddle, // Is for defined button height
    @required this.isDashed, // Is for dashed border button
    @required this.isLogOut, // Is for logOutButton
    @required this.hasBorderRounded
  });
  bool hasBackground = false;
  bool isMiddle = false;
  bool isLogOut = false;
  bool isDashed = false;
  final GestureTapCallback onTap;
  final String title;
  bool hasBorderRounded = false;

  _buildWithBackgroundButton(context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            decoration: BoxDecoration(
                color: hasBackground ? passVIPYellow : passVipButtonNotActive,
                borderRadius: hasBorderRounded ? BorderRadius.circular(5.0) : null,
                border: !hasBackground ? Border(
                    top: BorderSide(color: Colors.white),
                    left: BorderSide(color: Colors.white),
                    right: BorderSide(color: Colors.white),
                    bottom: BorderSide(color: Colors.white)
                ): null
            ),
            height: !isMiddle ? heightTwo : heightOne,
            width: double.infinity,
            child: Center(
              child: Text(
                Translations.of(context).text(title),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: sizeOne,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none
                ),
              ),
            )
        )
    );
  }
  _buildLogOutButton(context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: !isMiddle ? heightTwo : heightOne,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Color.fromRGBO(225, 120, 127, .3),
            borderRadius: BorderRadius.circular(20.0)
        ),
        child: Center(
          child: Text(
            Translations.of(context).text(title),
            style: TextStyle(
                color: aaRed,
                fontSize: sizeOne,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none
            ),
          ),
        ),
      ),
    );
  }
  _buildDashedButton(context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          height: !isMiddle ? heightTwo : heightOne,
          width: double.infinity,
          decoration: BoxDecoration(
              color: passVIPYellow,
              borderRadius: BorderRadius.circular(20.0),
              border: Border(
                  top: BorderSide(
                    color: passVIPYellow,
                  )
              )
          ),
          child: Center(
            child: Text(
              Translations.of(context).text(title),
              style: TextStyle(
                  color: aaBlue,
                  fontSize: sizeOne,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLogOut ? _buildLogOutButton(context) : isDashed ? _buildDashedButton(context) : _buildWithBackgroundButton(context);
  }

}
