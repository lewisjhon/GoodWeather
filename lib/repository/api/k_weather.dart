//기상청 api key
import 'dart:convert';
import 'package:weather/model/domain_model.dart';
import 'package:http/http.dart' as http;

const String apikey =
    "9cb09qJk83PkSy0hGYFExVqmeOPKjcBtudHao38zMJYmprd7zrPWhiXJySnLU1bFUzStqL9dbd3ADRVjUFYO4w%3D%3D";
const String urlShort =
    "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"; // 오늘 ~ 3일
const String urlLong = ""; // 4일 ~ 10일

class WeatherRepository {
  Future<Response> fetchWeather() async {
    final response = await http.get(Uri.parse(
        '$urlShort?serviceKey=$apikey&numOfRows=10&pageNo=1&base_date=20221212&base_time=1730&nx=55&ny=127&dataType=JSON'));

    if (response.statusCode == 200) {
      return Future<Response>.delayed(Duration(seconds: 2), () {
        return Response.fromJson(jsonDecode(response.body)['response']);
      });
    } else {
      throw Exception('Failed to load album');
    }
  }
}
