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

WeatherByTimeViewModel CreateTimeItem(int time, String img, int temp) {
  return WeatherByTimeViewModel(
      curTemperature: temp, time: time, weatherImage: img);
}

WeatherViewModel mapResponse(
    ResponseShort resShort, ResponseMid resMid, ResponseMid resMidSky) {
  //category
  //TMP : 온도(°C)
  //SKY : 하늘상태(맑음:1/구름많음:3/흐림:4)
  //PTY : 강수형태(없음:0/비:1/비,눈:2/눈:3/소나기:4)
  //REH : 습도(%)
  var tmp = resMid.body.items[0];
  var tmp2 = resMidSky.body.items[0];
  List<WeatherByDayViewModel> tmpItemByDay = [];

  tmpItemByDay.add(CreateDayItemFromList(
      resShort.body.items, "오늘", getWeatherIcon('0', '1')));
  tmpItemByDay.add(CreateDayItemFromList(
      resShort.body.items, getWeekdayWithDate(1), getWeatherIcon('0', '1'),
      addDay: 1));
  tmpItemByDay.add(CreateDayItemFromList(
      resShort.body.items, getWeekdayWithDate(2), getWeatherIcon('0', '1'),
      addDay: 2));
  tmpItemByDay.addAll([
    CreateDayItem(getWeekdayWithDate(3), tmp.taMin3, tmp.taMax3,
        getWeatherIconByText(tmp2.wf3Am)),
    CreateDayItem(getWeekdayWithDate(4), tmp.taMin4, tmp.taMax4,
        getWeatherIconByText(tmp2.wf4Am)),
    CreateDayItem(getWeekdayWithDate(5), tmp.taMin5, tmp.taMax5,
        getWeatherIconByText(tmp2.wf5Am)),
    CreateDayItem(getWeekdayWithDate(6), tmp.taMin6, tmp.taMax6,
        getWeatherIconByText(tmp2.wf6Am)),
    CreateDayItem(getWeekdayWithDate(7), tmp.taMin7, tmp.taMax7,
        getWeatherIconByText(tmp2.wf7Am)),
    CreateDayItem(
        getWeekdayWithDate(8), tmp.taMin8, tmp.taMax8, getWeatherIconByText(tmp2.wf8)),
    CreateDayItem(
        getWeekdayWithDate(9), tmp.taMin9, tmp.taMax9, getWeatherIconByText(tmp2.wf9)),
    CreateDayItem(getWeekdayWithDate(10), tmp.taMin10, tmp.taMax10,
        getWeatherIconByText(tmp2.wf10)),
  ]);

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

  List<WeatherByTimeViewModel> tmpItemByTime = [];
  List<String> timeList = [
    '0000',
    '0100',
    '0200',
    '0300',
    '0400',
    '0500',
    '0600',
    '0700',
    '0800',
    '0900',
    '1000',
    '1100',
    '1200',
    '1300',
    '1400',
    '1500',
    '1600',
    '1700',
    '1800',
    '1900',
    '2000',
    '2100',
    '2200',
    '2300',
  ];

  for (var time in timeList) {
    tmpItemByTime.add(CreateTimeItem(
        int.parse(time.substring(0, 2)),
        getWeatherIcon(
            getShortItemValue(resShort.body.items, 'SKY', getYYYYMMDD(), time),
            getShortItemValue(resShort.body.items, 'PTY', getYYYYMMDD(), time)),
        int.parse(getShortItemValue(
            resShort.body.items, 'TMP', getYYYYMMDD(), time))));
  }

  return WeatherViewModel(
    curTemperature: int.parse(curTemp.first.fcstValue),
    minTemperature: int.parse(todayTmpItems.first.fcstValue),
    maxTemperature: int.parse(todayTmpItems.last.fcstValue),
    region: "서울시",
    weatherDesc: "오늘 날씨는 전반적으로 포근하고 건조하겠습니다.",
    weatherImage: getWeatherIcon(skyCode, rainCode),
    itemByDay: tmpItemByDay,
    itemByTime: tmpItemByTime,
  );
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
