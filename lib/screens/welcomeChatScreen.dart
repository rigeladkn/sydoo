import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sydoo/components/SButton.dart';
import 'package:sydoo/components/SChatMessage.dart';
import 'package:sydoo/pages/chatRoomPage.dart';
import 'package:sydoo/translations.dart';
import 'package:sydoo/utils/color.dart';
import 'dart:io' show Platform;

class WelcomeChatScreen extends StatefulWidget {
  @override
  _WelcomeChatScreenState createState() => _WelcomeChatScreenState();
}

List<ChatMessage> listOfMessages = [];


class _WelcomeChatScreenState extends State<WelcomeChatScreen> {
  FocusNode _focusNode = new FocusNode();
  TextEditingController textEditingController = new TextEditingController();
  bool showEmojis = false;
  String message = "";
  int currentBotMessage = 0;
  ScrollController scrollController = new ScrollController();
  String firstName = "";


  void addFirstMessages() async {
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        listOfMessages.add(ChatMessage(
          isAFirstMessage: true,
          writer: "bot",
          date: "",
          typeOfTheMessage: "simple",
          endParameter: "",
          message: "sinceWeAreGoingToBeFriend",
        ));
      });
    });
    Future.delayed(Duration(milliseconds: 5500), () {
      setState(() {
        listOfMessages.add(ChatMessage(
          isAFirstMessage: false,
          writer: "bot",
          date: "",
          typeOfTheMessage: "simple",
          endParameter: "",
          message: "whatIsYourName",
        ));
      });
    });
    setState(() {
      currentBotMessage = 2;
    });
  }

  @override
  void initState() {
    listOfMessages.clear();
    addFirstMessages();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Delay to make sure the frames are rendered properly
    Future.delayed(const Duration(milliseconds: 300));
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 1300), curve: Curves.fastOutSlowIn);
    });


    return Scaffold(
      body: WillPopScope(
        onWillPop: onBackPressed,
        child: Stack(
          children: [
            Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    controller: scrollController,
                      padding: EdgeInsets.fromLTRB(10.0, 80.0, 0.0, 70),
                      itemCount: listOfMessages.length,
                      itemBuilder: (context, index) {
                        return index == 0
                            ? new Column(children: [
                                buildWelcomeMessage(),
                                listOfMessages[0],
                              ])
                            : listOfMessages[index];
                      }),
                ),
                new Container(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.035),
                  decoration: BoxDecoration(
                    color: inputTextContainerColor,
                  ),
                  height: 103.0,
                  child: buildEditingField(),
                ),
                showEmojis
                    ? buildEmojisKeyBoard()
                    : Container(
                        height: 0,
                      ),
              ],
            ),
          ],
          alignment: Alignment.bottomCenter,
        ),
      ),
    );
  }

  buildEditingField() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(29.0))),
          width: MediaQuery.of(context).size.width * 0.7,
          padding: EdgeInsets.symmetric(vertical: 6.0),
          child: new TextFormField(
            focusNode: _focusNode,
            controller: textEditingController,
            onTap: () {
              setState(() {
                showEmojis = false;
                // _focusNode.canRequestFocus = true;
              });
            },
            onChanged: (value) {
              setState(() {
                message = value;
                // _focusNode.requestFocus();
              });
            },
            onFieldSubmitted: (value) {
              setState(() {
                message = textEditingController.text;
              });
              handleSubmission(message);
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: primaryBlueColor,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(29.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0.0,
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(29.0)),
                ),
                prefixIcon: new IconButton(
                    onPressed: () {
                      setState(() {
                        if(_focusNode.hasFocus){
                          _focusNode.canRequestFocus = false;
                        }
                        showEmojis = true;
                        setState(() {
                          _focusNode.requestFocus();
                        });
                      });
                    },
                    icon: SvgPicture.asset(
                      "assets/svg/ic_emoji.svg",
                      height: 25,
                      width: 25,
                      color: indicatorColor,
                    )),
                hintText: "Type your message here",
                hintStyle: new TextStyle(
                    color: Colors.grey,
                    fontFamily: "Hellix",
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400)),
          ),
        ),
        Spacer(),
        new IconButton(
          color: Colors.red,
          iconSize: 58,
          icon: CircleAvatar(
            radius: 25,
            backgroundColor: primaryBlueColor,
            child: new SvgPicture.asset(
              "assets/svg/ic_send.svg",
              color: Colors.white,
              width: 24.03,
              height: 24.0,
            ),
          ),
          onPressed: () async {
            setState(() {
              message = textEditingController.text;
              _focusNode.canRequestFocus = false;
              _focusNode.unfocus();
            });
            if(message != ""){
              if(listOfMessages.length == 2){
                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.setString("firstName", message);
                setState(() {
                  firstName = message;
                });
              }
              handleSubmission(message);
            }
          },
        )
      ],
    );
  }

  buildEmojisKeyBoard() {
    return Container(
      height: 200.0,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          setState(() {
            textEditingController.text =
                textEditingController.text + emoji.emoji;
            _focusNode.nextFocus()  ;
          });
        },
        onBackspacePressed: (){
          _backspace();
          // setState(() {
          //   textEditingController.text = textEditingController.text.substring(0,textEditingController.text.length);
          //   final textSelection = textEditingController.selection;
          //   final selectionLength = textSelection.end - textSelection.start;
          //
          // });
        },
        config: Config(
            columns: 8,
            emojiSizeMax: 25 * (Platform.isIOS ? 1.30 : 1.0),
            verticalSpacing: 0,
            horizontalSpacing: 0,
            initCategory: Category.RECENT,
            bgColor: Color(0xFFF2F2F2),
            // indicatorColor: Colors.blue,
            iconColor: Colors.grey,
            // iconColorSelected: Colors.blue,
            // progressIndicatorColor: Colors.blue,
            // showRecentsTab: true,
            recentsLimit: 28,
            // noRecentsText: "No Recents",
            noRecentsStyle:
                const TextStyle(fontSize: 20, color: Colors.black26),
            tabIndicatorAnimDuration: kTabScrollDuration,
            categoryIcons: const CategoryIcons(),
            buttonMode: ButtonMode.MATERIAL),
      ),
    );
  }

  Future<bool> onBackPressed() {
    if (showEmojis) {
      setState(() {
        showEmojis = false;
      });
    } else {
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  void handleSubmission(String newMessage) async {
    textEditingController.clear();

    ChatMessage chatMessage = new ChatMessage(
      writer: "",
      typeOfTheMessage: "simple",
      endParameter: "",
      date: "",
      isAFirstMessage: true,
      message: newMessage,
    );

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        listOfMessages.add(chatMessage);
        print("MESSAGE =>" + newMessage);
        print("Length =>" + listOfMessages.length.toString());
        // _focusNode.requestFocus();
      });
    });

    goToNextBotMessage(listOfMessages.length);
  }


  goToNextBotMessage(int listLength) {
   print("LIst length " + listOfMessages.length.toString());
    switch (listLength+1) {
      case 3:
        ChatMessage chatMessage = new ChatMessage(
          writer: "bot",
          typeOfTheMessage: "simpleWithMiddleParam",
          endParameter: firstName +
              ". " +
              Translations.of(context).text("whatIsYourLastName"),
          date: "",
          isAFirstMessage: true,
          message: "niceToMeetYou",
        );
        Future.delayed(Duration(milliseconds: 3000), () {
          setState(() {
            listOfMessages.add(chatMessage);
          });
        });
        setState(() {
          currentBotMessage = 3;
        });

        break;
      case 5:
        ChatMessage chatMessage2 = new ChatMessage(
          writer: "bot",
          typeOfTheMessage: "simple",
          endParameter: "",
          date: "",
          isAFirstMessage: true,
          message: "whatIsYourBirthDate",
        );
        Future.delayed(Duration(milliseconds: 3000), () {
          setState(() {
            listOfMessages.add(chatMessage2);
            currentBotMessage = 4;
          });
        });
        break;
      default :
        Future.delayed(Duration(milliseconds : 3000), (){
          showGreatPopUp();
        });
        break;
    }
  }


  void _backspace() {
    final text = textEditingController.text;
    final textSelection = textEditingController.selection;
    final selectionLength = textSelection.end - textSelection.start;

    // There is a selection.
    if (selectionLength > 0) {
      final newText = text.replaceRange(
        textSelection.start,
        textSelection.end,
        '',
      );
      textEditingController.text = newText;
      textEditingController.selection = textSelection.copyWith(
        baseOffset: textSelection.start,
        extentOffset: textSelection.start,
      );
      return;
    }

    // The cursor is at the beginning.
    if (textSelection.start == 0) {
      return;
    }

    // Delete the previous character
    final previousCodeUnit = text.codeUnitAt(textSelection.start - 1);
    final offset = _isUtf16Surrogate(previousCodeUnit) ? 2 : 1;
    final newStart = textSelection.start - offset;
    final newEnd = textSelection.start;
    final newText = text.replaceRange(
      newStart,
      newEnd,
      '',
    );
    textEditingController.text = newText;
    textEditingController.selection = textSelection.copyWith(
      baseOffset: newStart,
      extentOffset: newStart,
    );
  }

  bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }


  showGreatPopUp() {
    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0),

            content: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
              ),
              height: 300.0,
              child: new Column(
                children: [
                  new CircleAvatar(
                    radius: 30.0,
                    backgroundColor: primaryBlueColor,
                    child: new SvgPicture.asset(
                      "assets/svg/ic_logo.svg",
                      color: Colors.white,
                      height: 47.82,
                      width: 47.82,
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                    child: new Text(
                      Translations.of(context).text(
                        "great",
                      ),
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          color: Colors.black,
                          fontFamily: "Hellix",
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 40.0),
                    child: new Text(
                      Translations.of(context).text(
                        "theAMazingAventureBeginNow",
                      ),
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          color: primaryGreyColor,
                          fontFamily: "Hellix",
                          fontSize: 16.0,
                          height: 1.3,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  new WikiChatButton(
                    isColoredBlue: true,
                    text: Translations.of(context).text("letsGo"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(context,
                          new MaterialPageRoute(builder: (context) {
                        return new ChatRoomPage();
                      }));
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildWelcomeMessage() {
    return new Column(
      children: [
        new CircleAvatar(
          backgroundColor: primaryBlueColor,
          radius: 35.0,
          child: new SvgPicture.asset(
            "assets/svg/ic_logo.svg",
            color: Colors.white,
            height: 47.82,
            width: 47.82,
          ),
        ),
        new Padding(
          padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0),
          child: new Text(
            Translations.of(context).text(
              "theAMazingAventureBeginNow",
            ),
            textAlign: TextAlign.center,
            style: new TextStyle(
                color: Colors.black,
                fontFamily: "Helix",
                fontSize: 32.0,
                height: 1.5,
                fontWeight: FontWeight.w700),
          ),
        )
      ],
    );
  }
}
