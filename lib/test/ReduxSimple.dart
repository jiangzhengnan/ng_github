import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

//一个简单的动作:增量
//action
enum Actions { Increment }

void main() {
  // reducer = initState = store
  final store = Store<int>(
      (int state,dynamic action){
        if(action == Actions.Increment) {
          return state + 1;
        }
        return state;
      },initialState: 0
  );
  runApp(ReduxSimple(store:store));

}

class ReduxSimple extends StatelessWidget{
  final Store<int> store;

  ReduxSimple({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<int>(
      // 将给定的Redux Store传递给请求它的所有后代
      store:store,
      child: MaterialApp(
        home: ReduxSimpleHome(),
      ),

    );
  }
  
}

class ReduxSimpleHome extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _ReduxSimpleHomeState();
  }

}

class _ReduxSimpleHomeState extends State<ReduxSimpleHome>{

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text("Heelo simple redux"),),
     floatingActionButton: StoreConnector<int, VoidCallback>(
       converter: (store)=>()=>store.dispatch(Actions.Increment),
       builder: (context,cb) =>FloatingActionButton(
         onPressed: cb,
         child: Icon(Icons.add),
       ),
     ),
     body: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         StoreConnector<int,String>(
           converter: (store)=>store.state.toString(),
           builder: (context,count){
             return Center(child:Text('$count'));
           },
         )

       ],
     ),
   );
  }


}