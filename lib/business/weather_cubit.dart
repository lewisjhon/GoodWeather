import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:weather/business/mapper.dart';
import 'package:weather/model/domain_model.dart';
import 'package:weather/model/view_model.dart';
import 'package:weather/repository/api/k_weather.dart';
import 'package:weather/business/weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository repository;

  WeatherCubit({required this.repository}) : super(Empty());

  getWeather() async {
    try {
      emit(Loading());

      final respShort = await repository.fetchWeatherShort();
      final respMid = await repository.fetchWeatherMidTemp();
      final respMidSky = await repository.fetchWeatherMidSky();

      // 어제 비교는 부가 정보라 실패해도 전체 조회를 막지 않는다.
      ResponseShort? respYesterday;
      try {
        respYesterday = await repository.fetchWeatherYesterday();
      } catch (e) {
        Logger().d('어제 날씨 조회 실패(비교 생략): $e');
      }

      if (respShort.header.resultCode == "00") {
        var model =
            mapResponse(respShort, respMid, respMidSky, yesterday: respYesterday);
        emit(Loaded(weather: [model]));
      } else {
        var logg = Logger();
        logg.d(respShort.header.resultMsg);
        emit(Error(message: respShort.header.resultMsg));
      }
    } catch (e) {
      Logger().d(e);
      emit(Error(message: e.toString()));
    }
  }
}
