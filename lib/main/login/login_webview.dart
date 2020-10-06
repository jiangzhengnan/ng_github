import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class LoginWebView extends StatefulWidget {
  final String url;
  final String title;

  LoginWebView(this.url, this.title);

  @override
  _LoginWebViewState createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  _renderTitle() {
    if (widget.url == null || widget.url.length == 0) {
      return new Text(widget.title);
    }
    return new Row(children: [
      new Expanded(
          child: new Container(
        child: new Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      )),
    ]);
  }

  renderLoading() {
    return new Center(
      child: new Container(
        width: 200.0,
        height: 200.0,
        padding: new EdgeInsets.all(4.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new SpinKitDoubleBounce(color: Theme.of(context).primaryColor),
            new Container(width: 10.0),
            new Container(
                child: new Text('加載中' )
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        if (state.type == WebViewState.shouldStart) {
          print("shouldStart ${state.url}");
          if (state.url != null &&
              state.url.startsWith("gsygithubapp://authed")) {
            var code = Uri.parse(state.url).queryParameters["code"];
            //这里得到返回结果?  code 6965544c689ada8fbf1c
            print("code ${code}");
            flutterWebViewPlugin.reloadUrl("about:blank");

            //这一句弹出?
            Navigator.of(context).pop(code);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        children: <Widget>[
          WebviewScaffold(
            appBar: new AppBar(
              title: _renderTitle(),
            ),
            //invalidUrlRegex: "gsygithubapp://authed",
            initialChild: renderLoading(),
            url: widget.url,
          ),
        ],
      ),
    );
  }
}
