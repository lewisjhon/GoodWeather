import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        child: Column(
          children: [
            Flexible(
              fit: FlexFit.tight,
              flex: 3,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Text('서울시'),
                  ),
                  SvgPicture.asset(getWeatherIcon('02d'), height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('최저'), Text('2도')],
                          )),
                      Container(
                        alignment: Alignment.center,
                        width: 100,
                        child: Text('10도'),
                      ),
                      Container(
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('최저'), Text('2도')],
                          )),
                    ],
                  )
                ],
              ),
            ),
            Flexible(
              flex: 7,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(15),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (num i = 1; i < 10; i++)
                              Container(
                                width: 50,
                                height: 100,
                                color: Colors.black38,
                                margin: const EdgeInsets.all(2),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      padding: const EdgeInsets.all(15),
                      child: Column(children: [
                        for (num i = 1; i < 7; i++)
                          Container(
                              height: 70,
                              color: Colors.black54,
                              margin: const EdgeInsets.all(2)),
                      ]),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

String getWeatherIcon(String iconCode) {
  switch (iconCode) {
    case '01d':
      return 'assets/images/day.svg';

    case '01n':
      return 'assets/images/night.svg';

    case '02d':
      return 'assets/images/cloudy_day.svg';

    case '02n':
      return 'assets/images/cloudy_night.svg';

    case '03d':
    case '03n':
    case '04d':
    case '04n':
      return 'assets/images/cloudy.svg';

    case '09d':
    case '09n':
    case '10d':
    case '10n':
      return 'assets/images/rainy.svg';

    case '11d':
    case '11n':
      return 'assets/images/thunder.svg';

    case '13d':
    case '13n':
      return 'assets/images/snowy.svg';

    // TODO: Add smog icon
    // case '50d':
    // case '50n':

    default:
      return 'assets/day.svg';
  }
}
