import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ng_github/main/common/event/http_error_event.dart';
import 'package:ng_github/main/common/event/index.dart';
import 'package:ng_github/main/data/model/User.dart';
import 'package:ng_github/main/data/net/model/code.dart';
import 'package:ng_github/main/main/HomePage.dart';
import 'package:ng_github/main/main/login/login_page.dart';
import 'package:ng_github/main/redux/ng_state.dart';
import 'package:ng_github/main/utils/navigator_utils.dart';
import 'package:redux/redux.dart';

class MainApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainAppState();
  }
}

class _MainAppState extends State<MainApp>
    with HttpErrorListener, NavigatorObserver {
  //创建Store
  final store = new Store<NGState>(
    appReducer,

    ///拦截器
    middleware: middleware,

    ///初始化数据
    initialState: new NGState(userInfo: User.empty(), login: false),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      /// 通过 with NavigatorObserver ，在这里可以获取可以往上获取到
      /// MaterialApp 和 StoreProvider 的 context
      /// 还可以获取到 navigator;
      /// 比如在这里增加一个监听，如果 token 失效就退回登陆页。
      navigator.context;
      navigator;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// 使用 flutter_redux 做全局状态共享
    /// 通过 StoreProvider 应用 store
    return new StoreProvider(
      store: store,
      child: new StoreBuilder<NGState>(builder: (context, store) {
        return new MaterialApp(

            navigatorObservers: [this],

            ///命名式路由
            /// "/" 和 MaterialApp 的 home 参数一个效果
            routes: {
              HomePage.sName: (context) {
                _context = context;
                return NavigatorUtils.pageContainer(new HomePage(), context);
              },

              LoginPage.sName: (context) {
                _context = context;
                return NavigatorUtils.pageContainer(new LoginPage(), context);
              },
            });
      }),
    );
  }
}

mixin HttpErrorListener on State<MainApp> {
  StreamSubscription stream;

  ///这里为什么用 _context 你理解吗？
  ///因为此时 State 的 context 是 FlutterReduxApp 而不是 MaterialApp
  ///所以如果直接用 context 是会获取不到 MaterialApp 的 Localizations 哦。
  BuildContext _context;

  @override
  void initState() {
    super.initState();

    ///Stream演示event bus
    stream = eventBus.on<HttpErrorEvent>().listen((event) {
      errorHandleFunction(event.code, event.message);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (stream != null) {
      stream.cancel();
      stream = null;
    }
  }

  ///网络错误提醒
  errorHandleFunction(int code, message) {
    switch (code) {
      case Code.NETWORK_ERROR:
        showToast("net work error");
        break;
      case 401:
        showToast("401");
        break;
      case 403:
        showToast("403");
        break;
      case 404:
        showToast("404");
        break;
      case 422:
        showToast("422");
        break;
      case Code.NETWORK_TIMEOUT:
        //超时
        showToast("net 超时");
        break;
      case Code.GITHUB_API_REFUSED:
        //Github API 异常
        showToast("Github API 异常 惨遭拒绝");
        break;
      default:
        showToast("原因不明" + " " + message);
        break;
    }
  }

  showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG);
  }
}
