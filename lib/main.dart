import 'package:belajar_flutter_1/page/home.dart';
import 'package:belajar_flutter_1/page/login.dart';
import 'package:flutter/material.dart';

import 'page/form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/",
      routes: {
        "/": (_) => LoginPage(),
        "/home": (_) => HomePage(),
        "/form": (_) => FormPage(),
      },
    );
  }
}