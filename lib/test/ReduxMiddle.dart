import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'ReduxState.dart';
import 'first_page.dart';

main() {
  final store = Store<ReduxState>(
      getReduce,
      initialState: ReduxState.initState()
  );
  runApp(ReduxDemo3(store,));
}

/**
 * 1、最顶层必须是 StoreProvider 开始
    2、StoreBuilder后要跟上我们定义的那个State类，要不会报错，
 */
class ReduxDemo3 extends StatelessWidget {

  final Store<ReduxState> store;
  ReduxDemo3(this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: StoreBuilder<ReduxState>(builder: (BuildContext context, Store<ReduxState> store){
          return MaterialApp(
            title: 'ReduxDemo3',
            theme: new ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: FirstPage(),
          );
        })
    );
  }
}
