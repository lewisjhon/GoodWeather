import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoodWeather',
      home: Container(
        child: Column(children: [
          Flexible(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.amberAccent,
            ),
          ),
          Flexible(
            flex: 8,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    height: 100,
                    color: Colors.green,
                  ),
                  Container(
                    height: 800,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
