
import 'package:flutter/material.dart';
import 'package:ng_github/main/bottom/BottomNavigationWidget.dart';

class BottomLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new BottomNavigationWidget(),

    );
  }


}
