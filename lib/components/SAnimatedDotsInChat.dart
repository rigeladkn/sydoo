import 'package:sydoo/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

//Utilisé à l'intérieur du chatbot pour ralentir l'affichage des messages

class AnimatedDotInChat extends AnimatedWidget {
  AnimatedDotInChat({Animation<double> animation}) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    return new Container(
      height: animation.value,
      //duration: new Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 9.0),
      //curve: Curves.bounceInOut,
      width: 9.0,
      child: new CircleAvatar(
        radius: 1.0,
        backgroundColor: indicatorColor,
      ),
    );
  }
}

class AnimatedDotsInChat extends StatefulWidget  {

  final int numberOfDots;
  AnimatedDotsInChat({this.numberOfDots});
  final double beginTweenValue = 0;
  final double endTweenValue = 10;

  @override
  _AnimatedDotsInChatState createState() => _AnimatedDotsInChatState(numberOfDots: numberOfDots);
}

class _AnimatedDotsInChatState extends State<AnimatedDotsInChat> with TickerProviderStateMixin{

  int numberOfDots;
  _AnimatedDotsInChatState({this.numberOfDots});

  List<AnimationController> controllers = [];
  List<Animation<double>>  animations = [];
  List<Widget> widgets = [];

  @override
  void initState() {
    for(int i=0; i< numberOfDots; i++){
      AnimationController animationContr = new AnimationController(vsync: this, duration: Duration(milliseconds: 250) );
      //ajout des controllers
      controllers.add(animationContr);
      
      //ajout des animations
      animations.add(
        Tween(begin: widget.beginTweenValue, end: widget.endTweenValue).animate(controllers[i])..addStatusListener((status) {
          if(status == AnimationStatus.completed){
            controllers[i].reverse();
          }
          if(i == numberOfDots -1 && status == AnimationStatus.dismissed){
              controllers[0].forward();
          }
          if(animations[i].value > widget.endTweenValue*0.5 && i != numberOfDots -1){
            controllers[i+1].forward();
          }
        })
      );

      //ajout des widgets
      widgets.add(
        new AnimatedDotInChat(animation: animations[i],)
      );

      //on lance le premier dot
      controllers[0].forward();
    }
    super.initState();

  }

  @override
  void dispose() {
    for (int i = 0; i < numberOfDots; i++) {
      controllers[i].dispose();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new Row(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 20.0, 8.0, 20.0),
          child: CircleAvatar(
              backgroundColor: primaryBlueColor,
              radius: 16.0,
              child: new SvgPicture.asset(
                "assets/svg/ic_logo.svg",
                height: 19.2,
                width: 18.6,
                color: Colors.white,
              )),
        ),
        new Container(
            width: 85.0,
            height: 44.0,
            padding: EdgeInsets.only(
              left: 18,
            ),
            //margin: EdgeInsets.only(right: 50.0),
            decoration: BoxDecoration(
                color: chatGreyColor,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0))),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children:  widgets,
            )),
        Spacer(),
      ],
    );
  }
}

