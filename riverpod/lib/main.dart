import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpo/future/futurescreen.dart';

void main() {
  runApp(const ProviderScope(
    child: MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureScreen();
  }
}
