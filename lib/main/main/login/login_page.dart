import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ng_github/main/redux/login_redux.dart';
import 'package:ng_github/main/redux/ng_state.dart';
import 'package:ng_github/main/utils/navigator_utils.dart';

import 'login_webview.dart';


class LoginPage extends StatefulWidget {
  static final String sName = "login";

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login"),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new MaterialButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: new Text('登录'),
            onPressed: () {
             // ignore: unnecessary_statements
              print("onPressed");
              Fluttertoast.showToast(
                  msg:'login',
                  gravity: ToastGravity.CENTER,
                  toastLength: Toast.LENGTH_LONG);


              oauthLogin();

              // Navigator.of(context).push(
              //     CupertinoPageRoute( builder: (context) => MediaQuery(
              //       ///不受系统字体缩放影响
              //         data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
              //         child: new LoginWebView( "https://github.com/login/oauth/authorize?client_id"
              //             "=8b01061bcf2f034e5672&state=app&"
              //             "redirect_uri=gsygithubapp://authed", "登录"))));
            },
          )

        ],
      ),
    );
  }

  oauthLogin() async {
    String code = await Navigator.push(
        context,
        CupertinoPageRoute( builder: (context) => MediaQuery(
          ///不受系统字体缩放影响
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: new LoginWebView( "https://github.com/login/oauth/authorize?client_id"
                "=8b01061bcf2f034e5672&state=app&"
                "redirect_uri=gsygithubapp://authed", "登录"))));
    if (code != null && code.length > 0) {
      print("login:" + code);

      ///通过 redux 去执行登陆流程
      StoreProvider.of<NGState>(context).dispatch(OAuthAction(context, code));
    }
  }
}

