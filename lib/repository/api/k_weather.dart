//기상청 api key
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:weather/business/weather_state.dart';
import 'package:weather/helper/public_function.dart';
import 'package:weather/model/domain_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String apikey =
    "9cb09qJk83PkSy0hGYFExVqmeOPKjcBtudHao38zMJYmprd7zrPWhiXJySnLU1bFUzStqL9dbd3ADRVjUFYO4w%3D%3D";
const String baseUrlShort =
    "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0";
const String baseUrlMid = "https://apis.data.go.kr/1360000/MidFcstInfoService";

//const String urlShortUltra = "$baseUrlShort/getUltraSrtFcst"; // 현재 ~ 6시간
const String urlShort = "$baseUrlShort/getVilageFcst"; // 현재 ~ 3일
const String urlMidSky = "$baseUrlMid/getMidLandFcst"; // 4일 ~ 10일 (구름정보)
const String urlMidTemp = "$baseUrlMid/getMidTa"; // 4일 ~ 10일 (온도정보)

//long sample
//https://apis.data.go.kr/1360000/MidFcstInfoService/getMidTa?regId=11B10101&tmFc=202212200600

class WeatherRepository {

  Future<ResponseMid> fetchWeatherMidTemp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastReqHour', getDateTime().hour);

    var url =
        '$urlMidTemp?serviceKey=$apikey&numOfRows=1000&pageNo=1&dataType=JSON&regId=11B10101&tmFc=${getYYYYMMDD()}0600';

    final response = await http.get(Uri.parse(url));

    Logger().d(url);

    if (response.statusCode == 200) {
      return ResponseMid.fromJson(jsonDecode(response.body)['response']);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<ResponseMid> fetchWeatherMidSky() async {
    var url =
        '$urlMidSky?serviceKey=$apikey&numOfRows=1000&pageNo=1&dataType=JSON&regId=11B00000&tmFc=${getYYYYMMDD()}0600';

    final response = await http.get(Uri.parse(url));

    Logger().d(url);

    if (response.statusCode == 200) {
      return ResponseMid.fromJson(jsonDecode(response.body)['response']);
    } else {
      throw Exception('Failed to load album');
    }
  }

  /// 어제 기온 비교용 단기예보.
  ///
  /// `getVilageFcst` 는 발표 시각(base_time) 이후의 예보만 주므로, 어제 하루를
  /// 통째로 담으려면 그제(이틀 전) 23시 발표분을 받아온다. 그제 23시 발표 →
  /// 어제 00시부터 오늘까지 커버되므로 어제 같은 시각 기온을 뽑아 쓸 수 있다.
  /// KMA 가 오래된 base_date 를 더 이상 서빙하지 않아 NO_DATA 가 오면 items 가
  /// 비고, mapper 가 비교 문구를 자동으로 숨긴다.
  Future<ResponseShort> fetchWeatherYesterday() async {
    var url =
        '$urlShort?serviceKey=$apikey&numOfRows=1000&pageNo=1&base_date=${getYYYYMMDD(addDay: -2)}&base_time=2300&nx=58&ny=125&dataType=JSON';

    final response = await http.get(Uri.parse(url));

    Logger().d(url);

    if (response.statusCode == 200) {
      return ResponseShort.fromJson(jsonDecode(response.body)['response']);
    } else {
      throw Exception('Failed to load yesterday weather');
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
        '$urlShort?serviceKey=$apikey&numOfRows=1000&pageNo=1&base_date=${getYYYYMMDD(addDay: -1)}&base_time=2300&nx=58&ny=125&dataType=JSON';

    final response = await http.get(Uri.parse(url));

    Logger().d(url);

    if (response.statusCode == 200) {
      return ResponseShort.fromJson(jsonDecode(response.body)['response']);
      // return Future<ResponseShort>.delayed(Duration(seconds: 0), () {
      //   return ResponseShort.fromJson(jsonDecode(response.body)['response']);
      // });
    } else {
      throw Exception('Failed to load album');
    }
  }
}
