import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class WeatherState extends Equatable {}

class Empty extends WeatherState {
  @override
  List<Object> get props => [];
}

class Loading extends WeatherState {
  @override
  List<Object> get props => [];
}

class Error extends WeatherState {
  final String message;

  Error({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class Loaded extends WeatherState {
  final List<Object> weather;

  Loaded({
    required this.weather,
  });

  @override
  List<Object?> get props => [weather];
}
