// This is AA Text field

import 'package:arsen/utils/color.dart';
import 'package:arsen/utils/size.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../translations.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}


// ignore: must_be_immutable
class AATextField extends StatefulWidget {
  bool isPassword;
  final Function(String) onValueChanged;
  FocusNode onFocus;
  TextEditingController controller;
  String label;
  bool isEmail;
  String hintText;
  bool hasLabel;
  bool isAmount;
  bool isM;
  int maxLength;
  bool isMultiline;
  bool isForModification;
  String defautText;
  bool isPlaq;
  bool isDisable;
  bool hasBackground;
  bool isTextCenter;

  AATextField({
    this.label,
    this.isPassword,
    this.isEmail,
    this.onValueChanged,
    this.hintText,
    this.hasLabel,
    this.isAmount,
    this.maxLength = 100,
    this.isMultiline = false,
    this.isM = false,
    this.isForModification = false,
    this.defautText,
    this.onFocus,
    this.controller,
    this.isPlaq = false,
    this.isDisable = false,
    this.hasBackground = false,
    this.isTextCenter = false,
  });

  _AATextFieldState createState() => _AATextFieldState();
}

class _AATextFieldState extends State<AATextField> {

  bool isPassword = false;
  bool isLook = false;
  bool showEyes = false;
  bool isEmail = false;
  String hintText = '';
  bool hasLabel = true;
  bool isAmount = false;
  bool isForModification;
  String tfText;
  TextEditingController _controller;

  _buildTextField(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        hasLabel ? Text(
          Translations.of(context).text(widget.label),
          style: TextStyle(
            color: aaGreyVeryLight,
            fontSize: sizeOneMin,
          ),
        ) : SizedBox(height: 0,),
        SizedBox(
          height: 5.0,
        ),
        Container(
          height: widget.isMultiline == true ? MediaQuery.of(context).size.width * 0.4 : heightTwo,
          decoration: BoxDecoration(
              color: isForModification ? Color(0xffE8E8E8) : Colors.transparent,
              borderRadius: BorderRadius.circular(5.0),
              border: !widget.hasBackground ?  Border(
                top: BorderSide(
                    color: aaGreyVeryLight,
                    width: 1
                ),
                left: BorderSide(
                    color: aaGreyVeryLight,
                    width: 1
                ),
                right: BorderSide(
                    color: aaGreyVeryLight,
                    width: 1
                ),
                bottom: BorderSide(
                    color: aaGreyVeryLight,
                    width: 1
                ),
              ) : Border()
          ),
          child: Padding(
            padding: !widget.hasBackground ? EdgeInsets.only(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0) : EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: TextFormField(
                      inputFormatters: widget.isPlaq ? [UpperCaseTextFormatter()] : [],
                      controller: widget.controller != null ? widget.controller : _controller,
                      enabled: widget.isDisable ? !widget.isDisable : !isForModification,
                      maxLength: widget.isMultiline ? null : widget.maxLength,
                      obscureText: isPassword,
                      keyboardType: isEmail ? TextInputType.emailAddress : isAmount || widget.isM ? TextInputType.number : widget.isMultiline ? TextInputType.multiline : TextInputType.text,
                      style: TextStyle(
                          fontSize: sizeOne
                      ),
                      decoration: InputDecoration(
                        border: widget.hasBackground ?  OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ) : InputBorder.none,
                        hintText: hintText,
                        hintStyle: TextStyle(color: aaGreyDark, fontSize: 16.0),
                        counterText: "",
                        fillColor: widget.hasBackground ? aaGreyBackground : Colors.transparent,
                        filled: widget.hasBackground ? true : false,
                        focusedBorder: widget.hasBackground ?  OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                        ) : InputBorder.none,
                        enabledBorder: widget.hasBackground ?  OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                        ) : InputBorder.none,
                      ),
                      onChanged: widget.onValueChanged,
                      //controller: widget.controller,
                      focusNode: widget.onFocus,
                      maxLines: widget.isMultiline == true ? 8 : 1,
                      textAlign: widget.isTextCenter ?  TextAlign.center : TextAlign.start,

                    )
                ),
                showEyes && !isForModification  ? Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      splashColor: Colors.white,
                      onTap: () {
                        setState(() {
                          isPassword = !isPassword;
                          isLook = !isLook;
                        });
                      },
                      child: !isLook ? SvgPicture.asset("assets/svg/ic_eye_lock.svg",
                        color: aaGreyDark,) : SvgPicture.asset("assets/svg/ic_eye.svg",
                        color: aaGreyDark,)
                  ),
                ) : SizedBox(height: 0,),
                isAmount ? Center(
                  child: Chip(label: Text("F CFA",
                    style: TextStyle(
                        color: aaGreyDark,
                        fontWeight: FontWeight.bold
                    ),)),
                ) : widget.isM ? Center(
                  child: Chip(label: Text("m2",
                    style: TextStyle(
                        color: aaGreyDark,
                        fontWeight: FontWeight.bold
                    ),)),
                ) : SizedBox(height: 0,),
                isForModification ? Center(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isForModification = !isForModification;
                      });
                    },
                    child: SvgPicture.asset("assets/svg/ic_update_profile.svg"),
                  ),
                ) : SizedBox(height: 0,)
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    _controller = TextEditingController();
    if (widget.isPassword != null) {
      isPassword = true;
      isLook = true;
      showEyes = true;
    }
    if (widget.isEmail != null) {
      isEmail = widget.isEmail;
    }
    if (widget.hintText != null) {
      hintText = widget.hintText;
    }
    if (widget.hasLabel != null) {
      hasLabel = widget.hasLabel;
    }
    if (widget.isAmount != null) {
      isAmount = widget.isAmount;
    }
    if (widget.defautText != null) {
      _controller.text = widget.defautText;
    }
    setState(() {
      isForModification = widget.isForModification;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _buildTextField(context);
  }

}
