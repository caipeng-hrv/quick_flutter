import 'package:flutter/material.dart';

class BasePage  {
  String title;
  bool isCenter;
  bool hasBackButton;
  Widget body;
  BasePage({this.body,this.title,this.isCenter,this.hasBackButton});

  build(){
    return Scaffold(
      appBar: new AppBar(
        centerTitle: isCenter??true,
        automaticallyImplyLeading: hasBackButton??false,
        title: Text(
            title??'',
            style: new TextStyle(
              color: Color(0xFFFFFFFF),
              // letterSpacing: 20,
              fontSize: 16,
            ),
          ),
      ),
      body: Container(
        alignment: Alignment.bottomLeft,
        child: body??Container(),
      ) 
    );
  }
}
