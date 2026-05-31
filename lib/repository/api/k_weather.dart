//기상청 api key
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:weather/helper/public_function.dart';
import 'package:weather/model/domain_model.dart';
import 'package:http/http.dart' as http;

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

/// 좌표(nx/ny)·regId 는 [Region] 에서 받아 온다(하드코딩 제거).
class WeatherRepository {
  Future<ResponseMid> fetchWeatherMidTemp({required String regId}) async {
    var url =
        '$urlMidTemp?serviceKey=$apikey&numOfRows=1000&pageNo=1&dataType=JSON&regId=$regId&tmFc=${getYYYYMMDD()}0600';

    final response = await http.get(Uri.parse(url));

    Logger().d(url);

    if (response.statusCode == 200) {
      return ResponseMid.fromJson(jsonDecode(response.body)['response']);
    } else {
      throw Exception('Failed to load mid temperature');
    }
  }

  Future<ResponseMid> fetchWeatherMidSky({required String regId}) async {
    var url =
        '$urlMidSky?serviceKey=$apikey&numOfRows=1000&pageNo=1&dataType=JSON&regId=$regId&tmFc=${getYYYYMMDD()}0600';

    final response = await http.get(Uri.parse(url));

    Logger().d(url);

    if (response.statusCode == 200) {
      return ResponseMid.fromJson(jsonDecode(response.body)['response']);
    } else {
      throw Exception('Failed to load mid sky');
    }
  }

  /// 어제 기온 비교용 단기예보.
  ///
  /// `getVilageFcst` 는 발표 시각(base_time) 이후의 예보만 주므로, 어제 하루를
  /// 통째로 담으려면 그제(이틀 전) 23시 발표분을 받아온다. 그제 23시 발표 →
  /// 어제 00시부터 오늘까지 커버되므로 어제 같은 시각 기온을 뽑아 쓸 수 있다.
  /// KMA 가 오래된 base_date 를 더 이상 서빙하지 않아 NO_DATA 가 오면 items 가
  /// 비고, mapper 가 비교 문구를 자동으로 숨긴다.
  Future<ResponseShort> fetchWeatherYesterday(
      {required int nx, required int ny}) async {
    var url =
        '$urlShort?serviceKey=$apikey&numOfRows=1000&pageNo=1&base_date=${getYYYYMMDD(addDay: -2)}&base_time=2300&nx=$nx&ny=$ny&dataType=JSON';

    final response = await http.get(Uri.parse(url));

    Logger().d(url);

    if (response.statusCode == 200) {
      return ResponseShort.fromJson(jsonDecode(response.body)['response']);
    } else {
      throw Exception('Failed to load yesterday weather');
    }
  }

  Future<ResponseShort> fetchWeatherShort(
      {required int nx, required int ny}) async {
    var url =
        '$urlShort?serviceKey=$apikey&numOfRows=1000&pageNo=1&base_date=${getYYYYMMDD(addDay: -1)}&base_time=2300&nx=$nx&ny=$ny&dataType=JSON';

    final response = await http.get(Uri.parse(url));

    Logger().d(url);

    if (response.statusCode == 200) {
      return ResponseShort.fromJson(jsonDecode(response.body)['response']);
    } else {
      throw Exception('Failed to load short forecast');
    }
  }
}
