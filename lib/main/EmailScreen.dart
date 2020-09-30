import 'package:flutter/material.dart';

class EmailScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EmailState();
}

class EmailState extends State<EmailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Email")),
    );
  }
}
