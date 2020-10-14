import 'package:flutter/material.dart';
import 'package:ng_github/main/data/model/User.dart';

import 'login_redux.dart';
import 'middleware/epic_middleware.dart';
import 'user_redux.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';

class NGState   {
  ///用户信息
  User userInfo;
  ///是否登录
  bool login;

  ///构造方法
  NGState({this.userInfo,  this.login});
}




///创建 Reducer
///源码中 Reducer 是一个方法 typedef State Reducer<State>(State state, dynamic action);
///我们自定义了 appReducer 用于创建 store
NGState appReducer(NGState state, action) {
  return NGState(
    ///通过 UserReducer 将 NGState 内的 userInfo 和 action 关联在一起
    userInfo: UserReducer(state.userInfo, action),
    login: LoginReducer(state.login, action),
  );
}


final List<Middleware<NGState>> middleware = [
  EpicMiddleware<NGState>(loginEpic),
  EpicMiddleware<NGState>(userInfoEpic),
  EpicMiddleware<NGState>(oauthEpic),
  UserInfoMiddleware(),
  LoginMiddleware(),
];
