import 'package:sydoo/components/SAnimatedDotsInChat.dart';
import 'package:sydoo/translations.dart';
import 'package:sydoo/utils/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatMessage extends StatefulWidget {
  String message;
  String writer;
  String date;
  bool isAFirstMessage;
  String typeOfTheMessage;
  var endParameter;

  ChatMessage(
      {
        //this.avatar,
        this.date,
        this.message,
        this.writer,
        this.isAFirstMessage,
        this.typeOfTheMessage,
        this.endParameter,});

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage>
    with TickerProviderStateMixin {
  bool isLoading = false;
  Animation<double> animation;
  Animation<double> indicatorSpaceAnimation;
  AnimationController animationController;

  @override
  void initState() {
    animationController = new AnimationController(vsync: this)
      ..addListener(() {
        setState(() {});
      });

    animation = CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.elasticInOut),
      reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    indicatorSpaceAnimation = CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      reverseCurve: const Interval(0.0, 1.0, curve: Curves.easeOut),
    ).drive(Tween<double>(
      begin: 0.0,
      end: 60.0,
    ));

    setState(() {
      isLoading = true;
    });

    widget.writer == "bot" && widget.isAFirstMessage
        ? Future.delayed(Duration(milliseconds: 3000), () {
      setState(() {
        isLoading = false;
        startAnimation();
      });
    })
        : widget.writer == "bot" && !widget.isAFirstMessage
        ? Future.delayed(Duration(milliseconds: 3000), () {
      setState(() {
        isLoading = false;
        startAnimation();
      });
    })
        : widget.writer != "bot" && widget.isAFirstMessage
        ? Future.delayed(Duration(milliseconds: 0), () {
      setState(() {
        isLoading = false;
        startAnimation();
      });
    })
        : Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        isLoading = false;
        startAnimation();
      });
    });
    super.initState();
  }

  startAnimation() {
    animationController
      ..duration = const Duration(milliseconds: 1000)
      ..forward()
      ..addListener(() {
        setState(() {});
      });
  }

  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  _buildSimpleChatMessage(BuildContext context) {
    return widget.writer == "bot"
        ? Row(
      children: [
        widget.isAFirstMessage
            ? Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
          child: CircleAvatar(
              backgroundColor: primaryBlueColor,
              radius: 18.0,
              child: new SvgPicture.asset(
                "assets/svg/ic_logo.svg",
                height: 21.83,
                width: 21.83,
                color: Colors.white,
              )),
        )
            : Container(
          width: 50,
        ),
        //le contenu
        Expanded(
            flex: 4,
            child: AnimatedBuilder(
                animation: indicatorSpaceAnimation,
                builder: (BuildContext context, Widget child) {
                  return new Transform.scale(
                      scale: animation.value,
                      alignment: Alignment.topLeft,
                      child: new Container(
                        padding: EdgeInsets.all(15.0),
                        //width: MediaQuery.of(context).size.width * 0.8,
                        margin: const EdgeInsets.fromLTRB(
                            0.0, 13.0, 0.0, 0.0),
                        decoration: BoxDecoration(
                            color: chatGreyColor,
                            borderRadius: widget.isAFirstMessage
                                ? BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            )
                                : BorderRadius.all(
                                Radius.circular(10.0))),
                        child: new Text(
                          Translations.of(context).text(widget.message) +
                              " " +
                              widget.endParameter,
                          //textAlign: TextAlign.center,
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Hellix",
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ));
                })),

        Spacer(),
      ],
    )

    //si ce n'est pas le bot
        : Row(
      children: [
        Spacer(),
        //le contenu
        new AnimatedBuilder( animation: indicatorSpaceAnimation,
            builder: (BuildContext context, Widget child) {
              return new Transform.scale(
                scale: animation.value,
                alignment: Alignment.bottomRight,
                child: new Container(
                    padding: EdgeInsets.all(15.0),
                    //width: MediaQuery.of(context).size.width * 0.8,
                    margin:  const EdgeInsets.fromLTRB(5.0, 13.0, 10.0, 0.0),
                    decoration: BoxDecoration(
                        color:   primaryBlueColor,
                        borderRadius: widget.isAFirstMessage && widget.writer != "bot"
                            ? BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        )
                            : BorderRadius.all(Radius.circular(10.0))),
                    child:  new Text(
                      widget.message,
                      //textAlign: TextAlign.center,
                      style: new TextStyle(
                          color:   Colors.white,
                          fontFamily: "Hellix",
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                    )
                ), );
            }),
      ],
    );
  }


  _buildSimpleChatMessageWithMiddleParam(BuildContext context) {
    return Row(
      children: [
        widget.isAFirstMessage
            ? Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
          child: CircleAvatar(
              backgroundColor: primaryBlueColor,
              radius: 16.0,
              child: new SvgPicture.asset(
                "assets/svg/ic_logo.svg",
                height: 21.83,
                width: 21.83,
                color: Colors.white,
              )),
        )
            : Container(
          width: 50,
        ),
        //le contenu
        Expanded(
            flex: 4,
            child: AnimatedBuilder(
                animation: indicatorSpaceAnimation,
                builder: (BuildContext context, Widget child) {
                  return new Transform.scale(
                      scale: animation.value,
                      alignment: Alignment.topLeft,
                      child: new Container(
                        padding: EdgeInsets.all(15.0),
                        //width: MediaQuery.of(context).size.width * 0.8,
                        margin: const EdgeInsets.fromLTRB(
                            0.0, 13.0, 0.0, 0.0),
                        decoration: BoxDecoration(
                            color: chatGreyColor,
                            borderRadius: widget.isAFirstMessage
                                ? BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            )
                                : BorderRadius.all(
                                Radius.circular(10.0))),
                        child: new Text(
                          Translations.of(context)
                              .text(widget.message)
                              + " " +
                              widget.endParameter
                             ,
                          //textAlign: TextAlign.center,
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Hellix",
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ));
                })),

        Spacer(),
      ],
    );
  }


/*  AnimationController animationController;
  Animation<double> animation;*/
//---------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    //int supDelay = generateRamdomDelay();

    // return isLoading == false ? widget.typeOfTheMessage == "simple" ? _buildSimpleChatMessage(context) : widget.typeOfTheMessage == "editMessage" ? _buildMessageWithEdit(context) : AnimatedDots(numberOfDots: 3,) : AnimatedDots(numberOfDots: 3,);
    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return !isLoading
              ? widget.typeOfTheMessage == "simple"
              ? _buildSimpleChatMessage(context)

              : widget.typeOfTheMessage ==
              "simpleWithMiddleParam"
              ? _buildSimpleChatMessageWithMiddleParam(
              context)
              : Container(
            height: 0.0,
          )
              : widget.writer == "bot"
              ? new AnimatedDotsInChat(
            numberOfDots: 3,
          )
              : new Container(
            height: 0,
          );
        });

    //     : Container(
    //   height: 0.0,
    // ) ;
  }
}