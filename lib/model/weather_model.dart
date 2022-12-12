// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';

class WeatherModel {
  String _title = '';
  int _degree = 0;

  String get Title => _title;
  int get Degree => _degree;

  set Title(String value) => _title = value;
  set Degree(int value) => _degree = value;
}

class ShortWeather {
  final int numOfRows;
  final int pageNo;
  final int totalCount;
  final String resultCode;
  final String resultMsg;
  final String dataType;
  final String baseDate;
  final String baseTime;
  final String fcstDate;
  final String fcstTime;
  final String category;
  final String fcstValue;
  final String nx;
  final String ny;

  const ShortWeather({
    required this.numOfRows,
    required this.pageNo,
    required this.totalCount,
    //header
    required this.resultCode,
    required this.resultMsg,
    //body
    required this.dataType,
    required this.baseDate,
    required this.baseTime,
    required this.fcstDate,
    required this.fcstTime,
    required this.category,
    required this.fcstValue,
    required this.nx,
    required this.ny,
  });

  factory ShortWeather.fromJson(Map<String, dynamic> json) {
    return ShortWeather(
      numOfRows: json['numOfRows'],
      pageNo: json['pageNo'],
      totalCount: json['totalCount'],
      resultCode: json['resultCode'],
      resultMsg: json['resultMsg'],
      dataType: json['dataType'],
      baseDate: json['baseDate'],
      baseTime: json['baseTime'],
      fcstDate: json['fcstDate'],
      fcstTime: json['fcstTime'],
      category: json['category'],
      fcstValue: json['fcstValue'],
      nx: json['nx'],
      ny: json['ny'],
    );
  }
}
