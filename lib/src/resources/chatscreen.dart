import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'chatmessage.dart';


final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseDatabase database = FirebaseDatabase.instance;
FirebaseUser user;

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);


class Chatpage extends StatefulWidget{
  @override
  ChatpageState createState() => ChatpageState();
} 

class ChatpageState extends State<Chatpage> with TickerProviderStateMixin{
  final List<ChatMessage> _messages;
  final TextEditingController _textController;
  final DatabaseReference _messageDatabaseReference;
  final StorageReference _photoStorageReference;
  bool _isComposing = false;

  ChatpageState()
    : _isComposing = false,
      _messages = <ChatMessage>[],
      _textController = TextEditingController(),
      _messageDatabaseReference = FirebaseDatabase.instance.reference().child("messages"),
      _photoStorageReference = FirebaseStorage.instance.ref().child("chat_photos")
      {
        _messageDatabaseReference.onChildAdded.listen(_onMessageAdded);
        _getCurrentUser();
      }
       
  @override
  Widget build(BuildContext context){
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Group Chat"),
          elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(
                top: BorderSide(color: Colors.grey[200]),
              ))
            : null,
      ),
    );
  }
  
  Widget _buildTextComposer() {
  return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                  hintText: "Send a message",
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: _sendImageFromCamera,
                    ),
                    IconButton(
                      icon: Icon(Icons.image),
                      onPressed: _sendImageFromGallery,
                    ),
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? CupertinoButton(
                            child: Text("Send"),
                            onPressed: _isComposing
                                ? () => _handleSubmitted(
                                      _textController.text,
                                    )
                                : null,
                          )
                        : IconButton(
                            icon: Icon(Icons.send),
                            onPressed: _isComposing
                                ? () => _handleSubmitted(
                                      _textController.text,
                                    )
                                : null,
                          ),
                  ],
                )
              )
          ],
        ),
      ));
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    final ChatMessage message = _createMessageFromText(text, user.email.toString());
    _messageDatabaseReference.push().set(message.toMap());
  }

  void _sendImage(ImageSource imageSource) async {
    File image = await ImagePicker.pickImage(source: imageSource);
    final String fileName = Uuid().v4();
    StorageReference photoRef = _photoStorageReference.child(fileName);
    final StorageUploadTask uploadTask = photoRef.putFile(image);
    final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
    final ChatMessage message = _createMessageFromImage(
      await downloadUrl.ref.getDownloadURL(),
      ""
    );
    _messageDatabaseReference.push().set(message.toMap());
  }

  void _sendImageFromCamera() async {
    _sendImage(ImageSource.camera);
  }
  void _sendImageFromGallery() async {
    _sendImage(ImageSource.gallery);
  }

  _getCurrentUser() async{
    user = await firebaseAuth.currentUser();
  }

  ChatMessage _createMessageFromText(String text, String username) => ChatMessage(
    text: text,
    username: username,
    animationController: AnimationController(
      duration: Duration(milliseconds: 180),
      vsync: this,
    ),
  );

  ChatMessage _createMessageFromImage(String imageUrl, String username) => ChatMessage(
      imageUrl: imageUrl,
      username: user.email.toString(),
      animationController: AnimationController(
        duration: Duration(milliseconds: 90),
        vsync: this,
      ),
    );

  void _onMessageAdded(Event event) {
    final text = event.snapshot.value["text"];
    final imageUrl = event.snapshot.value["imageUrl"];
    final name = event.snapshot.value["username"];

    ChatMessage message = imageUrl == null
        ? _createMessageFromText(text, name)
        : _createMessageFromImage(imageUrl, name);

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }
}