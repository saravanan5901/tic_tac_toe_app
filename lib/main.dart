import 'package:flutter/material.dart';
import 'package:tic_tac_toe_package/widgets/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Tic Tac Toe',
      home: HomePage(),
    );
  }
}
