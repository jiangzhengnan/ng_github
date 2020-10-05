import "package:flutter/material.dart";
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'ReduxState.dart';

class NextPage extends StatefulWidget {

  @override
  State createState() => NextPageState();
}

class NextPageState extends State<NextPage> {
  @override
  Widget build(BuildContext context) {

    /// StoreBuilder
    return StoreBuilder<ReduxState>(
        builder: (BuildContext context, Store<ReduxState> store){
          return Scaffold(
            appBar: AppBar(
              title: Text("这是第二页"),
            ),
            body: Center(
                child: Column(
                  children: <Widget>[
                    Text(store.state.name),
                    SizedBox(height: 100,),
                    FlatButton(
                        onPressed: (){
                          store.dispatch(MyAction.Change);
                        },
                        child: Text("点击变换数据")
                    )
                  ],
                )
            ),
          );
        }
    );

    /// StoreConnector
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("这是第二页"),
//      ),
//      body: Center(
//        child: Column(
//          children: <Widget>[
//            StoreConnector<ReduxState, String>(
//              converter: (store) => store.state.name,
//                builder: (BuildContext context, String name) {
//                  return Text(name);
//                },
//            ),
//            SizedBox(height: 100,),
//            StoreBuilder<ReduxState>(
//                builder: (context, store) {
//                  return FlatButton(
//                      onPressed: (){
//                        store.dispatch(Action.Change);
//                      },
//                      child: Text("点击变换数据")
//                  );
//                }
//            ),
//          ],
//        )
//      ),
//    );
  }

}