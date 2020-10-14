import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ng_github/main/data/model/User.dart';
import 'package:ng_github/main/redux/ng_state.dart';
import 'package:redux/redux.dart';


class MainApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainAppState();
  }

}

class _MainAppState extends State<MainApp> {
  //创建Store
  final store = new Store<NGState>(
    appReducer,

    ///拦截器
    middleware: middleware,

    ///初始化数据
    initialState: new NGState(
        userInfo: User.empty(),
        login: false ),
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}


