/// 하나의 날씨 조회 지점. KMA API 가 단기예보는 격자좌표(nx/ny),
/// 중기예보는 regId 코드를 쓰기 때문에 한 지점이 두 종류의 키를 모두 들고 있다.
///
/// - [nx]/[ny]          : 단기예보(getVilageFcst) 격자좌표
/// - [midLandRegId]     : 중기육상예보(getMidLandFcst) 광역 구역 코드
/// - [midTempRegId]     : 중기기온(getMidTa) 도시별 코드
/// - [lat]/[lon]        : GPS 좌표(현재 위치 → 가장 가까운 지역 매칭용)
/// - [isCurrent]        : GPS 로 잡은 현재 위치 페이지인지 여부
class Region {
  final String name;
  final double lat;
  final double lon;
  final int nx;
  final int ny;
  final String midLandRegId;
  final String midTempRegId;
  final bool isCurrent;

  const Region({
    required this.name,
    required this.lat,
    required this.lon,
    required this.nx,
    required this.ny,
    required this.midLandRegId,
    required this.midTempRegId,
    this.isCurrent = false,
  });

  /// 캐시/페이지 식별용 고유 키. 현재 위치 페이지는 좌표가 바뀌어도
  /// 한 칸으로 취급되도록 별도 키를 쓴다.
  String get key => isCurrent ? 'current' : '${nx}_$ny';

  /// 화면에 표시할 이름. 현재 위치는 📍 를 앞에 붙인다.
  String get displayName => isCurrent ? '📍 $name' : name;

  Region copyWith({String? name, bool? isCurrent}) {
    return Region(
      name: name ?? this.name,
      lat: lat,
      lon: lon,
      nx: nx,
      ny: ny,
      midLandRegId: midLandRegId,
      midTempRegId: midTempRegId,
      isCurrent: isCurrent ?? this.isCurrent,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'lat': lat,
        'lon': lon,
        'nx': nx,
        'ny': ny,
        'midLandRegId': midLandRegId,
        'midTempRegId': midTempRegId,
      };

  factory Region.fromJson(Map<String, dynamic> json) => Region(
        name: json['name'] as String,
        lat: (json['lat'] as num).toDouble(),
        lon: (json['lon'] as num).toDouble(),
        nx: json['nx'] as int,
        ny: json['ny'] as int,
        midLandRegId: json['midLandRegId'] as String,
        midTempRegId: json['midTempRegId'] as String,
      );
}
