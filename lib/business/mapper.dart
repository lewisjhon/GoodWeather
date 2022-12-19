import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:weather/helper/public_function.dart';
import 'package:weather/model/domain_model.dart';
import 'package:weather/model/view_model.dart';

WeatherViewModel map(Response model) {
  var todayTmpItems = model.body.items
      .where((x) => x.fcstDate == getYYYYMMDD() && x.category == "TMP")
      .toList();

  todayTmpItems
      .sort((a, b) => int.parse(a.fcstValue).compareTo(int.parse(b.fcstValue)));

  Logger().d(todayTmpItems.map((e) => e.fcstValue));

  return WeatherViewModel(
      curTemperature: 1,
      minTemperature: int.parse(todayTmpItems.first.fcstValue),
      maxTemperature: int.parse(todayTmpItems.last.fcstValue),
      region: "서울시",
      weatherDesc: "",
      weatherImage: "rainy.svg",
      itemByDay: [
        WeatherByDayViewModel(
          title: '12:00',
          weatherImage: "rainy.svg",
          weatherDesc: "rainy.svg",
          minTemperature: 0,
          maxTemperature: 1,
        )
      ],
      itemByTime: [
        WeatherByTimeViewModel(
          title: "MON",
          weatherImage: "rainy.svg",
          curTemperature: 0,
        )
      ]);
}
