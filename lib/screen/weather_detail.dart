import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:weather/business/weather_cubit.dart';
import 'package:weather/business/weather_state.dart';
import 'package:weather/helper/public_function.dart';
import 'package:weather/model/domain_model.dart';
import 'package:weather/model/view_model.dart';
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
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      locale: const Locale('ko'),
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
              final WeatherViewModel viewModel = item[0] as WeatherViewModel;
              viewModel.itemByTime.sort((a, b) => a.title.compareTo(b.title));

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
                              viewModel.weatherImage,
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
                                    children: [
                                      Text('최저'),
                                      Text(
                                          '${viewModel.minTemperature.toString()}°')
                                    ],
                                  )),
                              Container(
                                alignment: Alignment.center,
                                width: 100,
                                child: Text(
                                    '${viewModel.curTemperature.toString()}°',
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                  width: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('최고'),
                                      Text(
                                          '${viewModel.maxTemperature.toString()}°')
                                    ],
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 7,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.black12,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10, 15, 10),
                              child: Column(
                                children: [
                                  Text(
                                    '${getToday()} 시간 별 예보',
                                    style: const TextStyle(
                                        color: Colors.black54, fontSize: 12),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        for (var item in viewModel.itemByTime)
                                          ListitemByTime(
                                            currentTemperture:
                                                item.curTemperature,
                                            title:
                                                "${int.parse(item.title.substring(0, 2))}시",
                                            img: item.weatherImage,
                                          )
                                      ],
                                    ),
                                  ),
                                ],
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
                                  child: const Text(
                                    '주간 일기 예보',
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 12),
                                  ),
                                ),
                                for (var item in viewModel.itemByDay)
                                  ListitemByDay(
                                      title: item.title,
                                      img: item.weatherImage,
                                      min: item.minTemperature,
                                      max: item.maxTemperature)
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
