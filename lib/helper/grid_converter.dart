import 'dart:math';

/// KMA 단기예보 격자좌표(nx, ny).
class GridPoint {
  final int nx;
  final int ny;
  const GridPoint(this.nx, this.ny);
}

/// 위경도(WGS84)를 기상청 단기예보 격자좌표로 변환한다.
///
/// 기상청이 공개한 Lambert Conformal Conic(LCC) 투영 변환식을 그대로 옮긴 것.
/// 상수(투영 위도, 기준점 등)는 기상청 격자 정의값이라 건드리지 말 것.
GridPoint convertGpsToGrid(double lat, double lon) {
  const double re = 6371.00877; // 지구 반경(km)
  const double grid = 5.0; // 격자 간격(km)
  const double slat1 = 30.0; // 표준위도 1
  const double slat2 = 60.0; // 표준위도 2
  const double olon = 126.0; // 기준점 경도
  const double olat = 38.0; // 기준점 위도
  const double xo = 43; // 기준점 X좌표(격자)
  const double yo = 136; // 기준점 Y좌표(격자)

  const double degrad = pi / 180.0;

  final double reGrid = re / grid;
  final double slat1Rad = slat1 * degrad;
  final double slat2Rad = slat2 * degrad;
  final double olonRad = olon * degrad;
  final double olatRad = olat * degrad;

  double sn = tan(pi * 0.25 + slat2Rad * 0.5) / tan(pi * 0.25 + slat1Rad * 0.5);
  sn = log(cos(slat1Rad) / cos(slat2Rad)) / log(sn);

  double sf = tan(pi * 0.25 + slat1Rad * 0.5);
  sf = pow(sf, sn).toDouble() * cos(slat1Rad) / sn;

  double ro = tan(pi * 0.25 + olatRad * 0.5);
  ro = reGrid * sf / pow(ro, sn).toDouble();

  double ra = tan(pi * 0.25 + lat * degrad * 0.5);
  ra = reGrid * sf / pow(ra, sn).toDouble();

  double theta = lon * degrad - olonRad;
  if (theta > pi) theta -= 2.0 * pi;
  if (theta < -pi) theta += 2.0 * pi;
  theta *= sn;

  final int nx = (ra * sin(theta) + xo + 0.5).floor();
  final int ny = (ro - ra * cos(theta) + yo + 0.5).floor();

  return GridPoint(nx, ny);
}
