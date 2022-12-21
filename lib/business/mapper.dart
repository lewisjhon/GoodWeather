import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:weather/helper/public_function.dart';
import 'package:weather/model/domain_model.dart';
import 'package:weather/model/view_model.dart';

WeatherViewModel mapResponse(ResponseShort resShort, ResponseMid resMid) {
  //category
  //TMP : 온도(°C)
  //SKY : 하늘상태(맑음:1/구름많음:3/흐림:4)
  //PTY : 강수형태(없음:0/비:1/비,눈:2/눈:3/소나기:4)
  //REH : 습도(%)
  var tmp = resMid.body.items[0] as ItemMid;
  List<WeatherByDayViewModel> tmpItemByDay = [
    WeatherByDayViewModel(
        title: getWeekday(3),
        weatherImage: '',
        weatherDesc: '',
        minTemperature: tmp.taMin3,
        maxTemperature: tmp.taMax3),
    WeatherByDayViewModel(
        title: getWeekday(4),
        weatherImage: '',
        weatherDesc: '',
        minTemperature: tmp.taMin4,
        maxTemperature: tmp.taMax4),
    WeatherByDayViewModel(
        title: getWeekday(5),
        weatherImage: '',
        weatherDesc: '',
        minTemperature: tmp.taMin5,
        maxTemperature: tmp.taMax5),
    WeatherByDayViewModel(
        title: getWeekday(6),
        weatherImage: '',
        weatherDesc: '',
        minTemperature: tmp.taMin6,
        maxTemperature: tmp.taMax6),
    WeatherByDayViewModel(
        title: getWeekday(7),
        weatherImage: '',
        weatherDesc: '',
        minTemperature: tmp.taMin7,
        maxTemperature: tmp.taMax7),
    WeatherByDayViewModel(
        title: getWeekday(8),
        weatherImage: '',
        weatherDesc: '',
        minTemperature: tmp.taMin8,
        maxTemperature: tmp.taMax8),
    WeatherByDayViewModel(
        title: getWeekday(9),
        weatherImage: '',
        weatherDesc: '',
        minTemperature: tmp.taMin9,
        maxTemperature: tmp.taMax9),
    WeatherByDayViewModel(
        title: getWeekday(10),
        weatherImage: '',
        weatherDesc: '',
        minTemperature: tmp.taMin10,
        maxTemperature: tmp.taMax10),
  ];

  var todayTmpItems = resShort.body.items
      .where((x) => x.fcstDate == getYYYYMMDD() && x.category == "TMP")
      .toList();
  todayTmpItems
      .sort((a, b) => int.parse(a.fcstValue).compareTo(int.parse(b.fcstValue)));

  var curTemp = todayTmpItems
      .where((x) => x.fcstTime == "${now.hour.toString().padLeft(2, '0')}00");

  return WeatherViewModel(
      curTemperature: int.parse(curTemp.first.fcstValue),
      minTemperature: int.parse(todayTmpItems.first.fcstValue),
      maxTemperature: int.parse(todayTmpItems.last.fcstValue),
      region: "서울시",
      weatherDesc: "",
      weatherImage: "rainy.svg",
      itemByDay: tmpItemByDay,
      itemByTime: todayTmpItems.map((e) => mapTimeViewModel(e)).toList());
}

WeatherByTimeViewModel mapTimeViewModel(ItemShort model) {
  return WeatherByTimeViewModel(
      curTemperature: int.parse(model.fcstValue),
      title: model.fcstTime,
      weatherImage: '');
}

WeatherByDayViewModel mapDayViewModel(ItemShort model) {
  return WeatherByDayViewModel(
    title: '12:00',
    weatherImage: "rainy.svg",
    weatherDesc: "rainy.svg",
    minTemperature: 0,
    maxTemperature: 1,
  );
}
