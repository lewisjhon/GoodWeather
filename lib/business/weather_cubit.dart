import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:weather/business/mapper.dart';
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

      if (respShort.header.resultCode == "00") {
        var model = mapResponse(respShort, respMid, respMidSky);
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
