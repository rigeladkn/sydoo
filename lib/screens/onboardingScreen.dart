import 'package:flutter_svg/flutter_svg.dart';
import 'package:sydoo/components/SButton.dart';
import 'package:sydoo/screens/welcomeChatScreen.dart';
import 'package:sydoo/utils/color.dart';
import 'package:flutter/material.dart';

import '../translations.dart';

List<Map<String, String>> _onBoardingScreenData = [
  //to contain onBoardingScreen's texts and image content
  {
    "title": "firstOnboardingTitle",
    "introduction": "firstOnboardingIntroduction",
    "image": "assets/svg/ic_logo.svg"
  },
  {
    "title": "secondOnboardingTitle",
    "introduction": "secondOnboardingIntroduction",
    "image": "assets/svg/ic_logo.svg"
  },
  {
    "title": "thirdOnboardingTitle",
    "introduction": "thirdOnboardingIntroduction",
    "image": "assets/svg/ic_logo.svg"
  },
];

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class DropItem {
  String value;
  Row row;
  DropItem(this.value, this.row);
}

List<DropItem> dropdownItems = [
  DropItem(
    "English",
    new Row(children: [
      new SvgPicture.asset("assets/svg/ic_english.svg", height: 30, width: 32.0,),
      new Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
      ),
      new Text(
        "English",
        style: new TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: "Hellix",
          fontSize: 16.0,
        ),
      ),
    ]),
  ),
  DropItem(
    "French",
    new Row(children: [
      new SvgPicture.asset("assets/svg/ic_french.svg", height: 30, width: 32.0,),
      new Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
      ),
      new Text(
        "French",
        style: new TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: "Hellix",
          fontSize: 16.0,
        ),
      ),
    ]),
  ),
];

class _OnboardingState extends State<Onboarding> {
  PageController _pageController; //onboarding's controller
  int _currentPage = 0; //to store the current onBoarding index
  int _activeDot = 0; //to know which dot must be colored primaryColor
  bool isTheFirstTime = true;
  String userLanguage = "English";

  DropItem dropDownValue =  dropdownItems[0] ;
  bool focus = false;

  @override
  void initState() {
    _pageController = new PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Column(
      children: [
        new SizedBox(
          height: MediaQuery.of(context).size.height * 0.07,
        ),
        Container(
          padding: EdgeInsets.only(left: 25.0,),
          alignment: Alignment.bottomLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // padding: EdgeInsets.only(bottom: 15.0),
                height: MediaQuery.of(context).size.height*0.075,
                width: 120.0,
                child: new DropdownButton<DropItem>(
                  icon: new Container(
                    height: 0,
                  ),
                  isExpanded: true,
                  elevation: 8,
                  underline: Container(
                    color: Colors.white,
                    height: 0,
                  ),
                  value: dropDownValue,
                  style: TextStyle(color: Colors.black),
                  items: dropdownItems
                      .map<DropdownMenuItem<DropItem>>((DropItem value) => DropdownMenuItem(
                            child: value.row,
                            value: value,
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      dropDownValue = newValue;
                      userLanguage = newValue.value;
                      focus = true;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        new SizedBox(
          height: MediaQuery.of(context).size.height*0.04,
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
          height: MediaQuery.of(context).size.height * 0.7,
          child: new PageView.builder(
            controller: _pageController,
            itemCount: _onBoardingScreenData.length,
            itemBuilder: (context, index) {
              return new Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: new Text(
                      Translations.of(context).text(
                        _onBoardingScreenData[index]["title"],
                      ),
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          color: Colors.black,
                          fontFamily: "Hellix",
                          fontSize: 28.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Center(
                    child: new Text(
                      Translations.of(context).text(
                        _onBoardingScreenData[index]["introduction"],
                      ),
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          color: primaryGreyColor,
                          fontFamily: "Hellix",
                          fontSize: 16.0,
                          height: 1.5,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  new Spacer(),
                  Container(
                    height: 160,
                    width: 160,
                    child: new SvgPicture.asset(
                      _onBoardingScreenData[index]["image"],
                      fit: BoxFit.contain,
                    ),
                  ),
                  //Buttons
                  new Spacer(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0.0),
                    child: Column(
                      children: [
                        new WikiChatButton(
                          text: _currentPage != _onBoardingScreenData.length - 1
                              ? Translations.of(context).text("next")
                              : Translations.of(context).text("letsGetIn"),
                          isColoredBlue: true,
                          onTap: () {
                            if (_currentPage <
                                _onBoardingScreenData.length - 1) {
                              setState(() {
                                _currentPage = _currentPage + 1;
                              });
                              _pageController.animateToPage(_currentPage,
                                  duration: Duration(milliseconds: 800), curve: Curves.easeOut);
                            }
                            else{
                              Navigator.pushReplacement(context,
                                  new MaterialPageRoute(builder: (context) {
                                    return new WelcomeChatScreen();
                                  }));
                            }
                          },
                        ),
                        new Padding(padding: EdgeInsets.only(top: 20.0)),
                        new GestureDetector(
                          child: Container(
                            height: 50.0,
                            width: 100.0,
                            child: new Center(
                              child: new Text(
                                Translations.of(context).text(
                                  "startNow",
                                ),
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                    color: primaryGreyColor,
                                    fontFamily: "Hellix",
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    wordSpacing: 2),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.pushReplacement(context,
                                new MaterialPageRoute(builder: (context) {
                              return new WelcomeChatScreen();
                            }));
                          },
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
            onPageChanged: (value) {
              setState(() {
                _currentPage = value;
                print("currentPage => " + _currentPage.toString());
              });
              // _pageController.nextPage(
              //     duration: Duration(milliseconds: 60), curve: Curves.bounceIn);
              _pageController.animateToPage(_currentPage,
                  duration: Duration(milliseconds: 800), curve: Curves.easeOut);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 25.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                _onBoardingScreenData.length,
                (index) => new AnimatedContainer(
                      duration: new Duration(milliseconds: 200),
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        color: _currentPage == index
                            ? primaryOrangeColor
                            : primaryGreyColor,
                      ),
                      margin: EdgeInsets.only(right: 5.0),
                      height: 4.0,
                      curve: Curves.easeIn,
                      width: _currentPage == index ? 42.0 : 7.0,
                    )),
          ),
        )
      ],
    ));
  }
}
