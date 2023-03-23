import 'package:flutter/material.dart';
import 'package:path_finder/widgets/screen_map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Path finder',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ScreenMap(),
    );
  }
}
