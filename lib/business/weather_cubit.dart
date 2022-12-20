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

      final resp = await repository.fetchWeather();

      if (resp.header.resultCode == "00") {
        var model = mapResponse(resp);
        emit(Loaded(weather: [model]));
      } else {
        var logg = Logger();
        logg.d(resp.header.resultMsg);
        emit(Error(message: resp.header.resultMsg));
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
