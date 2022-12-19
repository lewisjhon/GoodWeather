class WeatherViewModel {
  final String region;
  final String weatherImage;
  final String weatherDesc;
  final int minTemperature;
  final int maxTemperature;
  final int curTemperature;

  final List<WeatherByTimeViewModel> itemByTime;
  final List<WeatherByDayViewModel> itemByDay;

  WeatherViewModel({
    required this.region,
    required this.weatherImage,
    required this.weatherDesc,
    required this.minTemperature,
    required this.maxTemperature,
    required this.curTemperature,
    required this.itemByTime,
    required this.itemByDay,
  });
}

class WeatherByTimeViewModel {
  final String title;
  final String weatherImage;
  final int curTemperature;

  WeatherByTimeViewModel({
    required this.title,
    required this.weatherImage,
    required this.curTemperature,
  });
}

class WeatherByDayViewModel {
  final String title;
  final String weatherImage;
  final String weatherDesc;
  final int minTemperature;
  final int maxTemperature;

  WeatherByDayViewModel({
    required this.title,
    required this.weatherImage,
    required this.weatherDesc,
    required this.minTemperature,
    required this.maxTemperature,
  });
}
