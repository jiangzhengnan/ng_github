import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ng_github/main/redux/ng_state.dart';
import 'package:redux/redux.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Store<NGState> _getStore() {
    if (context == null) {
      return null;
    }
    return StoreProvider.of(context);
  }

  ///从全局状态中获取我的用户名
  _getUserName() {
    if (_getStore() == null ||
        _getStore().state == null ||
        _getStore().state.userInfo == null ||
        _getStore().state.userInfo.login == null) {
      return "还没有";
    }
    return _getStore().state.userInfo.login;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UserInfo"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new MaterialButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: new Text(_getUserName()),
          )
        ],
      ),
    );
  }
}
