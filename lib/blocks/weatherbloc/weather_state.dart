import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:weatherapp/models/weather.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
}

class InitialWeatherState extends WeatherState {
  @override
  List<Object> get props => [];
}

class WeatherLoadingState extends WeatherState{
  @override
  List<Object> get props => [];
}

class WeatherLoadedState extends WeatherState {
  final Weather weather;

  WeatherLoadedState({@required this.weather});

  @override
  List<Object> get props => [weather];

}

class WeatherErrorState extends WeatherState {
  @override
  List<Object> get props => throw UnimplementedError();

}
