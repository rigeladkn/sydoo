import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sydoo/components/SChatMessage.dart';
import 'package:sydoo/translations.dart';
import 'package:sydoo/utils/color.dart';
import 'dart:io' show Platform;

class ChatRoomPage extends StatefulWidget {
  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

List<ChatMessage> listOfMessages = [];

class _ChatRoomPageState extends State<ChatRoomPage> {
  FocusNode _focusNode = new FocusNode();
  TextEditingController textEditingController = new TextEditingController();
  bool showEmojis = false;
  String message = "";
  int currentBotMessage = 0;
  ScrollController scrollController = new ScrollController();

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
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: primaryBlueColor,
        elevation: 0.0,
        leadingWidth: 0.0,
        leading: new Container(
          height: 0,
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text(
            Translations.of(context).text("chatRoom"),
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Hellix",
                fontSize: 24.0,
                fontWeight: FontWeight.w700),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
                child: new SvgPicture.asset(
              "assets/svg/ic_profile.svg",
              width: 30.0,
              height: 30.0,
              color: Colors.white,
            )),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: onBackPressed,
        child: Stack(
          children: [
            Column(
              children: [
                Flexible(
                  child: ListView.builder(
                      controller: scrollController,
                      padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 70),
                      itemCount: listOfMessages.length,
                      itemBuilder: (context, index) {
                        return listOfMessages[index];
                      }),
                ),
                new Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.035),
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
                        if (_focusNode.hasFocus) {
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
            if (message != "") {
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
            _focusNode.nextFocus();
          });
        },
        onBackspacePressed: () {
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
}
