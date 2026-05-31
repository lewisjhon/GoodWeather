import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/model/region.dart';

/// 사용자가 검색해서 추가한 지역 목록을 SharedPreferences 에 저장/복원한다.
/// 현재 위치(GPS) 페이지는 매번 새로 잡으므로 여기 저장하지 않는다.
class LocationStore {
  static const String _key = 'savedRegions';

  Future<List<Region>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => Region.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> save(List<Region> regions) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(regions.map((r) => r.toJson()).toList());
    await prefs.setString(_key, raw);
  }
}
