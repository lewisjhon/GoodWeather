import 'package:intl/intl.dart';

DateTime getDateTime({int addDay = 0}) {
  return DateTime.now().add(Duration(days: addDay));
}

String getWeekday(int addDay) {
  return DateFormat('E', 'ko').format(getDateTime(addDay: addDay));
}

String getWeekdayWithDate(int addDay) {
  var today = getDateTime(addDay: addDay);
  return DateFormat('E', 'ko').format(getDateTime(addDay: addDay)) + " ${today.month}/${today.day}";
}

String getToday() {
  return "${getDateTime().month}/${getDateTime().day}";
}

String getYYYYMMDD({int addDay = 0}) {
  return DateFormat("yyyyMMdd").format(getDateTime(addDay: addDay));
}

String getYYYYMMDDHHmmSS() {
  return DateFormat("yyyyMMddHHmmss").format(getDateTime());
}

String getHH00() {
  return "${getDateTime().hour.toString().padLeft(2, '0')}00";
}

String getWeatherIcon(String skyCode, String rainCode) {
  //3개의 조합으로 계산해보까?
  //1 : 낮/밤
  //skyCode : 맑음(1)/구름많음(3)/흐림(4)
  //rainCode : 없음(0)/비(1)/눈(3)/비,눈(2)/소나기(4) [초단기 경우: 빗방울(5)/빗방울눈날림(6)/눈날림(7)]

  //아래는 기상청에서 구분해주는 값.
  //1.맑음
  //2.구름많음
  //3.구름많음+비
  //4.구름많음+눈
  //5.구름많음+비/눈
  //6.구름많음+소나기
  //7.흐림
  //8.흐림+비
  //9.흐림+눈
  //10.흐림+비/눈
  //11.흐림+소나기
  var combineCode = "$skyCode$rainCode";
  switch (combineCode) {
    case '10':
      return 'assets/images/day.svg';
    case '30':
    case '40':
      return 'assets/images/cloudy.svg'; //'assets/images/cloudy_day.svg' / 'assets/images/cloudy_night.svg'
    case '31':
    case '32':
    case '34':
    case '41':
    case '42':
    case '44':
      return 'assets/images/rainy.svg';
    case '33':
    case '43':
      return 'assets/images/snowy.svg';
    default:
      return 'assets/images/cloudy_day.svg';
  }
}

String getWeatherIconByText(String text) {
  //skyCode : 맑음(1)/구름많음(3)/흐림(4)

  switch (text) {
    case '맑음':
      return 'assets/images/day.svg';
    case '구름많음':
      return 'assets/images/cloudy_day.svg';
    case '흐림':
      return 'assets/images/cloudy.svg';
    default:
      return 'assets/images/cloudy_day.svg';
  }
}

/// KMA 코드(SKY + PTY)를 한 줄짜리 한글 날씨 상태로 바꿔 준다.
/// 강수(PTY)가 있으면 강수 표현을 우선하고, 없으면 하늘상태(SKY)를 쓴다.
String getWeatherConditionText(String skyCode, String rainCode) {
  switch (rainCode) {
    case '1':
      return '비';
    case '2':
      return '비/눈';
    case '3':
      return '눈';
    case '4':
      return '소나기';
  }
  switch (skyCode) {
    case '1':
      return '맑음';
    case '3':
      return '구름많음';
    case '4':
      return '흐림';
    default:
      return '구름많음';
  }
}

/// 오늘 같은 시각 기온([today])을 어제 같은 시각([yesterday])과 비교한
/// 친근한 한글 문구. 어제 데이터가 없으면(null) 빈 문자열을 돌려줘
/// UI 에서 비교 줄을 숨길 수 있게 한다.
String getYesterdayComparisonText(int today, int? yesterday) {
  if (yesterday == null) return '';
  final diff = today - yesterday;
  if (diff == 0) return '어제와 기온이 비슷해요';
  if (diff > 0) return '어제보다 $diff° 높아요';
  return '어제보다 ${-diff}° 낮아요';
}

/// 기온대별 옷차림 추천 한 건. 화면에 그대로 뿌릴 수 있도록
/// 이모지 · 한 줄 요약 · 추천 의상 목록을 함께 담는다.
class OutfitRecommendation {
  final String emoji;
  final String summary;
  final String items;

  const OutfitRecommendation({
    required this.emoji,
    required this.summary,
    required this.items,
  });
}

/// 현재 기온([temp], °C)에 맞는 옷차림을 돌려준다.
/// 기상청/생활기상 기준의 기온별 옷차림 구간을 따른다.
OutfitRecommendation getOutfitRecommendation(int temp) {
  if (temp >= 28) {
    return const OutfitRecommendation(
      emoji: '🩳',
      summary: '많이 더워요. 가볍게 입으세요',
      items: '민소매 · 반팔 · 반바지 · 원피스',
    );
  } else if (temp >= 23) {
    return const OutfitRecommendation(
      emoji: '👕',
      summary: '따뜻해요. 얇게 입기 좋아요',
      items: '반팔 · 얇은 셔츠 · 면바지 · 반바지',
    );
  } else if (temp >= 20) {
    return const OutfitRecommendation(
      emoji: '🧥',
      summary: '활동하기 좋은 날씨예요',
      items: '얇은 가디건 · 긴팔티 · 면바지 · 청바지',
    );
  } else if (temp >= 17) {
    return const OutfitRecommendation(
      emoji: '👚',
      summary: '선선해요. 겉옷을 챙기세요',
      items: '얇은 니트 · 맨투맨 · 가디건 · 청바지',
    );
  } else if (temp >= 12) {
    return const OutfitRecommendation(
      emoji: '🧥',
      summary: '쌀쌀해요. 겉옷이 필요해요',
      items: '자켓 · 가디건 · 야상 · 청바지',
    );
  } else if (temp >= 9) {
    return const OutfitRecommendation(
      emoji: '🧣',
      summary: '꽤 쌀쌀해요. 따뜻하게 입으세요',
      items: '트렌치코트 · 야상 · 니트 · 스타킹',
    );
  } else if (temp >= 5) {
    return const OutfitRecommendation(
      emoji: '🧥',
      summary: '추워요. 두툼하게 입으세요',
      items: '코트 · 가죽자켓 · 히트텍 · 니트',
    );
  } else {
    return const OutfitRecommendation(
      emoji: '🧤',
      summary: '많이 추워요. 단단히 챙기세요',
      items: '패딩 · 두꺼운 코트 · 목도리 · 기모제품',
    );
  }
}
