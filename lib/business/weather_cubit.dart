import 'package:flutter_bloc/flutter_bloc.dart';
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
      //var tmp = WeatherViewModel(region: 'aaaa');

      // 여기서 데이터 전환 이루어져야 함. Mapper()

      emit(Loaded(weather: [resp]));
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }
}
