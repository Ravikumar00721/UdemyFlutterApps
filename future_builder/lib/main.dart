import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false, // Optional
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  Future<int> futurebuilder() async {
    await Future.delayed(Duration(seconds: 5));
    return 8;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FutureBuilder"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.yellowAccent,
        child: Center(
          child: FutureBuilder(
            future: futurebuilder(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                return Text(snapshot.data.toString());
              }
            },
          ),
        ),
      ),
    );
  }
}
