import 'package:flutter/material.dart';

class LoginLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginWidget(),

    );
  }

}

class LoginWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }

}

class LoginState extends State<LoginWidget>{
  TextEditingController _nameController,_pwController;
  FocusNode _nameFocus,_pwFocus;

  @override
  void initState() {
    _nameController = TextEditingController();
    _pwController = TextEditingController();
    _nameFocus = FocusNode();
    _pwFocus = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 80,),
            Center(
              child: Text('Login',style: TextStyle(fontSize: 32),),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: TextField(
                  focusNode: _nameFocus,
                  controller: _nameController,
                  obscureText: false,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (input){
                    _nameFocus.unfocus();
                    FocusScope.of(context).requestFocus(_pwFocus);
                  },
                  decoration: InputDecoration(labelText: "name pls")
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Material(
                borderRadius: BorderRadius.circular(10.0),
                child: TextField(
                  focusNode: _pwFocus,
                  controller: _pwController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (input){
                    _pwFocus.unfocus();
                    //登陆请求
                  },
                  decoration: InputDecoration(
                    labelText: "password",
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            ButtonBar(
              children: <Widget>[
                RaisedButton(onPressed: (){},child: Text('login'),color: Colors.white,)
              ],
            )

          ],
        ),
      ),

    );
  }

}

