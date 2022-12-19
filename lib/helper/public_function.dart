var now = DateTime.now();

String getYYYYMMDD() {
  return "${now.year}${now.month}${now.day}";
}

String getWeatherIcon(String iconCode) {
  switch (iconCode) {
    case '01d':
      return 'assets/images/day.svg';

    case '01n':
      return 'assets/images/night.svg';

    case '02d':
      return 'assets/images/cloudy_day.svg';

    case '02n':
      return 'assets/images/cloudy_night.svg';

    case '03d':
    case '03n':
    case '04d':
    case '04n':
      return 'assets/images/cloudy.svg';

    case '09d':
    case '09n':
    case '10d':
    case '10n':
      return 'assets/images/rainy.svg';

    case '11d':
    case '11n':
      return 'assets/images/thunder.svg';

    case '13d':
    case '13n':
      return 'assets/images/snowy.svg';

    default:
      return 'assets/day.svg';
  }
}
