import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/business/mapper.dart';
import 'package:weather/helper/public_function.dart';
import 'package:weather/model/domain_model.dart';
import 'package:weather/model/region.dart';
import 'package:weather/repository/api/k_weather.dart';
import 'package:weather/business/weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository repository;

  WeatherCubit({required this.repository}) : super(Empty());

  /// [region] 의 날씨를 불러온다. KMA rate limit 을 아끼려고 지역별로 시각당
  /// 한 번만 호출하고, 이미 이번 시각에 받아 둔 데이터가 있으면(=Loaded) 건너뛴다.
  /// [force] 가 true 면(당겨서 새로고침 등) 무조건 다시 부른다.
  Future<void> getWeather(Region region, {bool force = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hourKey = 'lastReqHour_${region.key}';
      final lastReqHour = prefs.getInt(hourKey);

      if (!force && lastReqHour == getDateTime().hour && state is Loaded) {
        return;
      }

      emit(Loading());

      final respShort =
          await repository.fetchWeatherShort(nx: region.nx, ny: region.ny);
      final respMid =
          await repository.fetchWeatherMidTemp(regId: region.midTempRegId);
      final respMidSky =
          await repository.fetchWeatherMidSky(regId: region.midLandRegId);

      // 어제 비교는 부가 정보라 실패해도 전체 조회를 막지 않는다.
      ResponseShort? respYesterday;
      try {
        respYesterday = await repository.fetchWeatherYesterday(
            nx: region.nx, ny: region.ny);
      } catch (e) {
        Logger().d('어제 날씨 조회 실패(비교 생략): $e');
      }

      if (respShort.header.resultCode == "00") {
        await prefs.setInt(hourKey, getDateTime().hour);
        var model = mapResponse(respShort, respMid, respMidSky,
            region: region, yesterday: respYesterday);
        emit(Loaded(weather: [model]));
      } else {
        Logger().d(respShort.header.resultMsg);
        emit(Error(message: respShort.header.resultMsg));
      }
    } catch (e) {
      Logger().d(e);
      emit(Error(message: e.toString()));
    }
  }
}
