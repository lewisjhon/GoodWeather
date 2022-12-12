//기상청 api key
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:weather/model/weather_model.dart';
import 'package:http/http.dart' as http;

const String apikey =
    "9cb09qJk83PkSy0hGYFExVqmeOPKjcBtudHao38zMJYmprd7zrPWhiXJySnLU1bFUzStqL9dbd3ADRVjUFYO4w%3D%3D";
const String urlShort = ""; // 오늘 ~ 3일
const String urlLong = ""; // 4일 ~ 10일

Future<ShortWeather> fetchWeather() async {
  final response = await http.get(Uri.parse(
      'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=$apikey&numOfRows=10&pageNo=1&base_date=20221212&base_time=1730&nx=55&ny=127&dataType=JSON'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var logger = Logger();
    logger.d(response.body);
    return ShortWeather.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
