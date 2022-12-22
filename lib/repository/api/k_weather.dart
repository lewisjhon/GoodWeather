//기상청 api key
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:weather/business/weather_state.dart';
import 'package:weather/helper/public_function.dart';
import 'package:weather/model/domain_model.dart';
import 'package:http/http.dart' as http;

const String apikey =
    "9cb09qJk83PkSy0hGYFExVqmeOPKjcBtudHao38zMJYmprd7zrPWhiXJySnLU1bFUzStqL9dbd3ADRVjUFYO4w%3D%3D";
const String baseUrlShort =
    "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0";
const String baseUrlLong = "https://apis.data.go.kr/1360000/MidFcstInfoService";
const String urlShortUltra = "$baseUrlShort/getUltraSrtFcst"; // 현재 ~ 6시간
const String urlShort = "$baseUrlShort/getVilageFcst"; // 현재 ~ 3일

const String urlLongWeather = "$baseUrlLong/getMidLandFcst"; // 4일 ~ 10일 (구름정보)
const String urlLongTemperature = "$baseUrlLong/getMidTa"; // 4일 ~ 10일 (온도정보)

//long sample
//https://apis.data.go.kr/1360000/MidFcstInfoService/getMidTa?regId=11B10101&tmFc=202212200600

class WeatherRepository {
  Future<ResponseMid> fetchWeatherMid() async {
    var url =
        '$urlLongTemperature?serviceKey=$apikey&numOfRows=1000&pageNo=1&dataType=JSON&regId=11B10101&tmFc=${getYYYYMMDD()}0600';

    final response = await http.get(Uri.parse(url));

    Logger().d(url);

    if (response.statusCode == 200) {
      return Future<ResponseMid>.delayed(Duration(seconds: 0), () {
        return ResponseMid.fromJson(jsonDecode(response.body)['response']);
      });
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<ResponseShort> fetchWeatherShort() async {
    DateTime now = DateTime.now();

    //매일 데이터 갱신 기준 시간 + 10분 (일일 8회)
    List<DateTime> baseTimeList = [
      DateTime(now.year, now.month, now.day, 2, 20),
      DateTime(now.year, now.month, now.day, 5, 20),
      DateTime(now.year, now.month, now.day, 8, 20),
      DateTime(now.year, now.month, now.day, 11, 20),
      DateTime(now.year, now.month, now.day, 14, 20),
      DateTime(now.year, now.month, now.day, 17, 20),
      DateTime(now.year, now.month, now.day, 20, 20),
      DateTime(now.year, now.month, now.day, 23, 20),
    ];

    var baseTime = baseTimeList.first;

    var filterdList =
        baseTimeList.where((element) => element.compareTo(now) == -1);
    if (filterdList.isNotEmpty) {
      baseTime = filterdList.last;
    }

    //var url =
    //    '$urlShort?serviceKey=$apikey&numOfRows=1000&pageNo=1&base_date=${getYYYYMMDD()}&base_time=${baseTime.hour}${baseTime.minute}&nx=60&ny=127&dataType=JSON';
    var url =
        '$urlShort?serviceKey=$apikey&numOfRows=1000&pageNo=1&base_date=${getYYYYMMDD()}&base_time=0200&nx=60&ny=127&dataType=JSON';

    final response = await http.get(Uri.parse(url));

    Logger().d(url);

    if (response.statusCode == 200) {
      return Future<ResponseShort>.delayed(Duration(seconds: 0), () {
        return ResponseShort.fromJson(jsonDecode(response.body)['response']);
      });
    } else {
      throw Exception('Failed to load album');
    }
  }
}
