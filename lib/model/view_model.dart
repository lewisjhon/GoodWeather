class WeatherViewModel {
  final String region;
  final String weatherImage;
  final int minTemperature;
  final int maxTemperature;
  final int curTemperature;

  WeatherViewModel(this.weatherImage, this.minTemperature, this.maxTemperature,
      this.curTemperature,
      {required this.region});

  // String _title = '';
  // int _degree = 0;

  // String get Title => _title;
  // int get Degree => _degree;

  // set Title(String value) => _title = value;
  // set Degree(int value) => _degree = value;
}
