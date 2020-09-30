import 'package:flutter/material.dart';
import 'package:ng_github/main/EmailScreen.dart';
import 'package:ng_github/main/HomeScreen.dart';

//底部导航栏组件
class BottomNavigationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BottomNavigationWidgetState();
}

class BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  final mBottomNavigationColor = Colors.blue;
  int currentIndex = 0;
  List<Widget> pages = List<Widget>();

  @override
  void initState() {
    super.initState();
    pages.add(HomeScreen());
    pages.add(EmailScreen());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: mBottomNavigationColor),
            title: Text("home",style: TextStyle(color: mBottomNavigationColor),)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.email, color: mBottomNavigationColor),
              title: Text("home",style: TextStyle(color: mBottomNavigationColor),)
          )
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: pages[currentIndex],
    );
  }
}
