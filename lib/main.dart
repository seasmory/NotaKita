import 'package:flutter/material.dart';
import 'package:notakita/services/authentication.dart';
import 'package:notakita/pages/root_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'NotaKita',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: new RootPage(auth: new Auth()));
  }
}
