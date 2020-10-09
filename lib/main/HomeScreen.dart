import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ng_github/main/utils/navigator_utils.dart';

import 'login/login_webview.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Heelo simple redux"),),
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
    print("login:" + code);
    if (code != null && code.length > 0) {
      ///通过 redux 去执行登陆流程
      //StoreProvider.of<GSYState>(context).dispatch(OAuthAction(context, code));
    }
  }
}

