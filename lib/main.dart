import 'package:flutter/material.dart';
import 'presentation/AddPage.dart';
import 'presentation/Home.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HompPage(),
      // home: AddPage(),
      // home: MyHomePage(),
    );
  }
}
