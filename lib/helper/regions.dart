import 'dart:math';

import 'package:weather/helper/grid_converter.dart';
import 'package:weather/model/region.dart';

/// 지역 검색용 내장 카탈로그.
///
/// 단기예보 격자(nx/ny)와 중기예보 regId 는 GPS 좌표만으로 깔끔하게 유도되지
/// 않아서(특히 중기 regId 는 기상청이 정한 구역 코드), 주요 도시 값을 미리
/// 표로 들고 있는다. 검색은 이 목록에서, GPS 현재 위치는 가장 가까운 항목의
/// 중기 regId 를 빌려 쓴다(단기 격자는 GPS 로 정확히 변환).
const List<Region> kRegions = [
  Region(name: '서울특별시', lat: 37.5665, lon: 126.9780, nx: 60, ny: 127, midLandRegId: '11B00000', midTempRegId: '11B10101'),
  Region(name: '인천광역시', lat: 37.4563, lon: 126.7052, nx: 55, ny: 124, midLandRegId: '11B00000', midTempRegId: '11B20201'),
  Region(name: '수원시', lat: 37.2636, lon: 127.0286, nx: 60, ny: 121, midLandRegId: '11B00000', midTempRegId: '11B20601'),
  Region(name: '춘천시', lat: 37.8813, lon: 127.7300, nx: 73, ny: 134, midLandRegId: '11D10000', midTempRegId: '11D10301'),
  Region(name: '강릉시', lat: 37.7519, lon: 128.8761, nx: 92, ny: 131, midLandRegId: '11D20000', midTempRegId: '11D20501'),
  Region(name: '대전광역시', lat: 36.3504, lon: 127.3845, nx: 67, ny: 100, midLandRegId: '11C20000', midTempRegId: '11C20401'),
  Region(name: '세종특별자치시', lat: 36.4800, lon: 127.2890, nx: 66, ny: 103, midLandRegId: '11C20000', midTempRegId: '11C20404'),
  Region(name: '청주시', lat: 36.6424, lon: 127.4890, nx: 69, ny: 106, midLandRegId: '11C10000', midTempRegId: '11C10301'),
  Region(name: '광주광역시', lat: 35.1595, lon: 126.8526, nx: 58, ny: 74, midLandRegId: '11F20000', midTempRegId: '11F20501'),
  Region(name: '목포시', lat: 34.8118, lon: 126.3922, nx: 50, ny: 67, midLandRegId: '11F20000', midTempRegId: '11F20401'),
  Region(name: '여수시', lat: 34.7604, lon: 127.6622, nx: 73, ny: 66, midLandRegId: '11F20000', midTempRegId: '11F20801'),
  Region(name: '전주시', lat: 35.8242, lon: 127.1480, nx: 63, ny: 89, midLandRegId: '11F10000', midTempRegId: '11F10201'),
  Region(name: '대구광역시', lat: 35.8714, lon: 128.6014, nx: 89, ny: 90, midLandRegId: '11H10000', midTempRegId: '11H10701'),
  Region(name: '포항시', lat: 36.0190, lon: 129.3435, nx: 102, ny: 94, midLandRegId: '11H10000', midTempRegId: '11H10201'),
  Region(name: '부산광역시', lat: 35.1796, lon: 129.0756, nx: 98, ny: 76, midLandRegId: '11H20000', midTempRegId: '11H20201'),
  Region(name: '울산광역시', lat: 35.5384, lon: 129.3114, nx: 102, ny: 84, midLandRegId: '11H20000', midTempRegId: '11H20101'),
  Region(name: '창원시', lat: 35.2280, lon: 128.6811, nx: 91, ny: 77, midLandRegId: '11H20000', midTempRegId: '11H20301'),
  Region(name: '제주시', lat: 33.4996, lon: 126.5312, nx: 53, ny: 38, midLandRegId: '11G00000', midTempRegId: '11G00201'),
];

/// 서울 기본값(GPS 실패 시 폴백).
const Region kDefaultRegion = Region(
  name: '서울특별시',
  lat: 37.5665,
  lon: 126.9780,
  nx: 60,
  ny: 127,
  midLandRegId: '11B00000',
  midTempRegId: '11B10101',
);

/// 이름으로 카탈로그를 검색한다(부분 일치). 빈 쿼리는 전체 목록.
List<Region> searchRegions(String query) {
  final q = query.trim();
  if (q.isEmpty) return kRegions;
  return kRegions.where((r) => r.name.contains(q)).toList();
}

/// GPS 좌표로 현재 위치 [Region] 을 만든다.
/// 단기 격자는 좌표에서 정확히 변환하고, 중기 regId·표시 이름은 카탈로그에서
/// 가장 가까운 도시의 값을 빌려 온다.
Region regionFromGps(double lat, double lon) {
  final grid = convertGpsToGrid(lat, lon);

  Region nearest = kRegions.first;
  double best = double.infinity;
  for (final r in kRegions) {
    final d = _haversine(lat, lon, r.lat, r.lon);
    if (d < best) {
      best = d;
      nearest = r;
    }
  }

  return Region(
    name: nearest.name,
    lat: lat,
    lon: lon,
    nx: grid.nx,
    ny: grid.ny,
    midLandRegId: nearest.midLandRegId,
    midTempRegId: nearest.midTempRegId,
    isCurrent: true,
  );
}

/// 두 위경도 사이 거리(km). 가장 가까운 지역을 고를 때만 쓰므로 근사면 충분.
double _haversine(double lat1, double lon1, double lat2, double lon2) {
  const double r = 6371.0;
  const double degrad = pi / 180.0;
  final dLat = (lat2 - lat1) * degrad;
  final dLon = (lon2 - lon1) * degrad;
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1 * degrad) * cos(lat2 * degrad) * sin(dLon / 2) * sin(dLon / 2);
  return r * 2 * atan2(sqrt(a), sqrt(1 - a));
}
