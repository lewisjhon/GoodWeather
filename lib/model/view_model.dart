class WeatherViewModel {
  final String region;
  final String weatherImage;
  final String weatherDesc;

  /// 한 줄짜리 한글 날씨 상태(맑음/흐림/비 등). 큰 현재 기온 아래에 표시.
  final String weatherCondition;
  final int minTemperature;
  final int maxTemperature;
  final int curTemperature;

  /// 어제 같은 시각의 기온. 조회에 실패하면 null 이며, 이때 비교 문구는 숨긴다.
  final int? yesterdayTemperature;

  final List<WeatherByTimeViewModel> itemByTime;
  final List<WeatherByDayViewModel> itemByDay;

  WeatherViewModel({
    required this.region,
    required this.weatherImage,
    required this.weatherDesc,
    required this.weatherCondition,
    required this.minTemperature,
    required this.maxTemperature,
    required this.curTemperature,
    required this.itemByTime,
    required this.itemByDay,
    this.yesterdayTemperature,
  });
}

class WeatherByTimeViewModel {
  final int time;
  final String weatherImage;
  final int curTemperature;

  WeatherByTimeViewModel({
    required this.time,
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
