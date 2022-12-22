import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weather/helper/public_function.dart';
import 'package:weather/model/domain_model.dart';
import 'package:weather/model/view_model.dart';

WeatherByDayViewModel CreateDayItem(String title, int min, int max, String img,
    {String desc = ''}) {
  return WeatherByDayViewModel(
      title: title,
      weatherImage: img,
      weatherDesc: desc,
      minTemperature: min,
      maxTemperature: max);
}

WeatherByDayViewModel CreateDayItemFromList(
    List<ItemShort> list, String title, String img,
    {String desc = '', int addDay = 0}) {
  var tmp = list
      .where((x) =>
          x.fcstDate == getYYYYMMDD(addDay: addDay) && x.category == "TMP")
      .toList();
  tmp.sort((a, b) => int.parse(a.fcstValue).compareTo(int.parse(b.fcstValue)));

  return WeatherByDayViewModel(
      title: title,
      weatherImage: img,
      weatherDesc: desc,
      minTemperature: int.parse(tmp.first.fcstValue),
      maxTemperature: int.parse(tmp.last.fcstValue));
}

WeatherViewModel mapResponse(ResponseShort resShort, ResponseMid resMid) {
  //category
  //TMP : 온도(°C)
  //SKY : 하늘상태(맑음:1/구름많음:3/흐림:4)
  //PTY : 강수형태(없음:0/비:1/비,눈:2/눈:3/소나기:4)
  //REH : 습도(%)
  var tmp = resMid.body.items[0] as ItemMid;
  List<WeatherByDayViewModel> tmpItemByDay = [];

  tmpItemByDay.add(CreateDayItemFromList(
      resShort.body.items, "오늘", getWeatherIcon('0', '1')));
  tmpItemByDay.add(CreateDayItemFromList(
      resShort.body.items, getWeekday(1), getWeatherIcon('0', '1'),
      addDay: 1));
  tmpItemByDay.add(CreateDayItemFromList(
      resShort.body.items, getWeekday(2), getWeatherIcon('0', '1'),
      addDay: 2));
  tmpItemByDay.addAll([
    CreateDayItem(
        getWeekday(3), tmp.taMin3, tmp.taMax3, getWeatherIcon('0', '1')),
    CreateDayItem(
        getWeekday(4), tmp.taMin4, tmp.taMax4, getWeatherIcon('0', '1')),
    CreateDayItem(
        getWeekday(5), tmp.taMin5, tmp.taMax5, getWeatherIcon('0', '1')),
    CreateDayItem(
        getWeekday(6), tmp.taMin6, tmp.taMax6, getWeatherIcon('0', '1')),
    CreateDayItem(
        getWeekday(7), tmp.taMin7, tmp.taMax7, getWeatherIcon('0', '1')),
    CreateDayItem(
        getWeekday(8), tmp.taMin8, tmp.taMax8, getWeatherIcon('0', '1')),
    CreateDayItem(
        getWeekday(9), tmp.taMin9, tmp.taMax9, getWeatherIcon('0', '1')),
    CreateDayItem(
        getWeekday(10), tmp.taMin10, tmp.taMax10, getWeatherIcon('0', '1')),
  ]);

  Logger().d('test');
  var todayTmpItems = resShort.body.items
      .where((x) => x.fcstDate == getYYYYMMDD() && x.category == "TMP")
      .toList();
  todayTmpItems
      .sort((a, b) => int.parse(a.fcstValue).compareTo(int.parse(b.fcstValue)));
  var curTemp = todayTmpItems.where((x) => x.fcstTime == getHH00());

  var skyCode =
      getShortItemValue(resShort.body.items, 'SKY', getYYYYMMDD(), getHH00());
  var rainCode =
      getShortItemValue(resShort.body.items, 'PTY', getYYYYMMDD(), getHH00());

  return WeatherViewModel(
      curTemperature: int.parse(curTemp.first.fcstValue),
      minTemperature: int.parse(todayTmpItems.first.fcstValue),
      maxTemperature: int.parse(todayTmpItems.last.fcstValue),
      region: "서울시",
      weatherDesc: "",
      weatherImage: getWeatherIcon(skyCode, rainCode),
      itemByDay: tmpItemByDay,
      itemByTime: todayTmpItems.map((e) => mapTimeViewModel(e)).toList());
}

String getShortItemValue(
    List<ItemShort> list, String category, String date, String time) {
  return list
      .where((x) =>
          x.fcstDate == date && x.fcstTime == time && x.category == category)
      .toList()
      .first
      .fcstValue;
}

//아래 함수도 못쓰겠네.. 결국 time 항목도 수동으로 생성 해야 할 듯. ㅠㅠ
WeatherByTimeViewModel mapTimeViewModel(ItemShort model) {
  return WeatherByTimeViewModel(
      curTemperature: int.parse(model.fcstValue),
      title: model.fcstTime,
      weatherImage: getWeatherIcon('0', '1'));
}
