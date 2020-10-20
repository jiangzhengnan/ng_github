import 'package:flutter/material.dart';
import 'package:ng_github/main/main/user/user_page.dart';
import 'package:ng_github/main/main/login/login_page.dart';

//底部导航栏组件
class HomePage extends StatefulWidget {
  static final String sName = "/";

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final mBottomNavigationColor = Colors.blue;
  int currentIndex = 0;
  List<Widget> pages = List<Widget>();

  @override
  void initState() {
    super.initState();
    pages.add(LoginPage());
    pages.add(UserPage());

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
