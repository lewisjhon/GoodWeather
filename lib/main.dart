import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather/helper/public_function.dart';
import 'package:weather/model/weather_model.dart';
import 'package:weather/widget/listitem_by_day.dart';
import 'package:weather/widget/listitem_by_time.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: CupertinoColors.white,
          barBackgroundColor: CupertinoColors.white,
          scaffoldBackgroundColor: CupertinoColors.white,
          textTheme: CupertinoTextThemeData(
              textStyle: TextStyle(fontFamily: 'ONE Mobile Title'))),
      home: CupertinoPageScaffold(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black12.withOpacity(0.5), BlendMode.dstATop),
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: const Text(
                        '서울시',
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    Container(
                      child: SvgPicture.asset(
                        getWeatherIcon('02n'),
                        height: 150,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [Text('최저'), Text('2°')],
                            )),
                        Container(
                          alignment: Alignment.center,
                          width: 100,
                          child: const Text('10°',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [Text('최고'), Text('12°')],
                            )),
                      ],
                    )
                  ],
                ),
              ),
              Flexible(
                flex: 7,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        padding: const EdgeInsets.all(15),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (num i = 1; i < 10; i++) ListitemByTime()
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Column(children: [
                          Container(
                            height: 20,
                            child: const Text('2주간 일기 예보'),
                          ),
                          for (num i = 1; i < 14; i++) const ListitemByDay()
                        ]),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
