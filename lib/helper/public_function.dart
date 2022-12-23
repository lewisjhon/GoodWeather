import 'dart:js_util';
import 'package:intl/intl.dart';

DateTime getDateTime({int addDay = 0}) {
  return DateTime.now().add(Duration(days: addDay));
}

String getWeekday(int addDay) {
  return DateFormat('E', 'ko').format(getDateTime(addDay: addDay));
}

String getToday() {
  return "${getDateTime().month}/${getDateTime().day}";
}

String getYYYYMMDD({int addDay = 0}) {
  return DateFormat("yyyyMMdd").format(getDateTime(addDay: addDay));
}

String getYYYYMMDDHHmmSS() {
  return DateFormat("yyyyMMddHHmmss").format(getDateTime());
}

String getHH00() {
  return "${getDateTime().hour.toString().padLeft(2, '0')}00";
}

String getWeatherIcon(String skyCode, String rainCode) {
  //3개의 조합으로 계산해보까?
  //1 : 낮/밤
  //skyCode : 맑음(1)/구름많음(3)/흐림(4)
  //rainCode : 없음(0)/비(1)/눈(3)/비,눈(2)/소나기(4) [초단기 경우: 빗방울(5)/빗방울눈날림(6)/눈날림(7)]

  //아래는 기상청에서 구분해주는 값.
  //1.맑음
  //2.구름많음
  //3.구름많음+비
  //4.구름많음+눈
  //5.구름많음+비/눈
  //6.구름많음+소나기
  //7.흐림
  //8.흐림+비
  //9.흐림+눈
  //10.흐림+비/눈
  //11.흐림+소나기
  var combineCode = "$skyCode$rainCode";
  switch (combineCode) {
    case '10':
      return 'assets/images/day.svg';
    case '30':
    case '40':
      return 'assets/images/cloudy.svg'; //'assets/images/cloudy_day.svg' / 'assets/images/cloudy_night.svg'
    case '31':
    case '32':
    case '34':
    case '41':
    case '42':
    case '44':
      return 'assets/images/rainy.svg';
    case '33':
    case '43':
      return 'assets/images/snowy.svg';
    default:
      return 'assets/images/cloudy_day.svg';
  }
}

String getWeatherIconByText(String text) {
  //skyCode : 맑음(1)/구름많음(3)/흐림(4)

  switch (text) {
    case '맑음':
      return 'assets/images/day.svg';
    case '구름많음':
      return 'assets/images/cloudy_day.svg';
    case '흐림':
      return 'assets/images/cloudy.svg';
    default:
      return 'assets/images/cloudy_day.svg';
  }
}
