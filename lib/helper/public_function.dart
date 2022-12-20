var now = DateTime.now();

String getToday() {
  return "${now.month}/${now.day}";
}

String getYYYYMMDD() {
  return "${now.year}${now.month}${now.day}";
}

String getWeatherIcon(String iconCode) {
  //3개의 조합으로 계산해보까?
  //1 : 낮/밤
  //2 : 맑음/구름많음/흐림
  //3 : 없음/비/눈/비,눈/소나기

  //아래는 기상청에서 구분해주는 값.
  //1.맑음
  //2.구름많음 = cloudy.svg
  //3.구름많음+비
  //4.구름많음+눈
  //5.구름많음+비/눈
  //6.구름많음+소나기
  //7.흐림
  //8.흐림+비
  //9.흐림+눈
  //10.흐림+비/눈
  //11.흐림+소나기
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
