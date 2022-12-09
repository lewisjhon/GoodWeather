import 'package:flutter/foundation.dart';

class WeatherModel {
  String _title = '';
  int _degree = 0;

  String get Title => _title;
  int get Degree => _degree;

  set Title(String value) => _title = value;
  set Degree(int value) => _degree = value;
}
