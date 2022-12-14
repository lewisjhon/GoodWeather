import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:weather/business/weather_cubit.dart';
import 'package:weather/business/weather_state.dart';
import 'package:weather/helper/public_function.dart';
import 'package:weather/model/domain_model.dart';
import 'package:weather/widget/listitem_by_day.dart';
import 'package:weather/widget/listitem_by_time.dart';

class WeatherDetailWidget extends StatefulWidget {
  const WeatherDetailWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeatherDetailWidgetState createState() => _WeatherDetailWidgetState();
}

class _WeatherDetailWidgetState extends State<WeatherDetailWidget> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WeatherCubit>(context).getWeather();
  }

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
        child: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (_, state) {
            if (state is Empty) {
              return Container();
            } else if (state is Error) {
              return Container(
                child: Text(state.message),
              );
            } else if (state is Loading) {
              //return const Center(child: CupertinoActivityIndicator()); // iphone style
              return const Center(
                  child: CircularProgressIndicator()); //android style
            } else if (state is Loaded) {
              final item = state.weather;
              var logger = Logger();
              logger.d((item[0] as Response).header.resultMsg);

              return Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.black12.withOpacity(0.5), BlendMode.dstATop),
                        image: const AssetImage('assets/images/background.jpg'),
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
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              padding: const EdgeInsets.all(15),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (num i = 1; i < 10; i++)
                                      ListitemByTime(
                                          currentTemperture: i.toInt())
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.black12,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              padding: const EdgeInsets.all(15),
                              child: Column(children: [
                                Container(
                                  height: 20,
                                  child: const Text('2주간 일기 예보'),
                                ),
                                for (num i = 1; i < 14; i++)
                                  const ListitemByDay()
                              ]),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}