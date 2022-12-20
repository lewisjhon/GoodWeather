import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:weather/helper/public_function.dart';
import 'package:weather/model/domain_model.dart';
import 'package:weather/model/view_model.dart';

WeatherViewModel mapResponse(Response model) {
  //category
  //TMP : 온도(°C)
  //SKY : 하늘상태(맑음:1/구름많음:3/흐림:4)
  //PTY : 강수형태(없음:0/비:1/비,눈:2/눈:3/소나기:4)
  //REH : 습도(%)

  var todayTmpItems = model.body.items
      .where((x) => x.fcstDate == getYYYYMMDD() && x.category == "TMP")
      .toList();

  todayTmpItems
      .sort((a, b) => int.parse(a.fcstValue).compareTo(int.parse(b.fcstValue)));

  Logger().d(todayTmpItems.map((e) => e.fcstValue));

  var curTemp = todayTmpItems
      .where((x) => x.fcstTime == "${now.hour.toString().padLeft(2, '0')}00");

  Logger().d(curTemp.map((e) => e.fcstValue));

  return WeatherViewModel(
      curTemperature: int.parse(curTemp.first.fcstValue),
      minTemperature: int.parse(todayTmpItems.first.fcstValue),
      maxTemperature: int.parse(todayTmpItems.last.fcstValue),
      region: "서울시",
      weatherDesc: "",
      weatherImage: "rainy.svg",
      itemByDay: todayTmpItems.map((e) => mapDayViewModel(e)).toList(),
      itemByTime: todayTmpItems.map((e) => mapTimeViewModel(e)).toList());
}

WeatherByTimeViewModel mapTimeViewModel(Item model) {
  return WeatherByTimeViewModel(
      curTemperature: int.parse(model.fcstValue),
      title: model.fcstTime,
      weatherImage: '');
}

WeatherByDayViewModel mapDayViewModel(Item model) {
  return WeatherByDayViewModel(
    title: '12:00',
    weatherImage: "rainy.svg",
    weatherDesc: "rainy.svg",
    minTemperature: 0,
    maxTemperature: 1,
  );
}
