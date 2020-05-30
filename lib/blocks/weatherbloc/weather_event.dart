import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class FetchWeatherEvent extends WeatherEvent {
  final String cityName;

  FetchWeatherEvent({this.cityName});
  @override
  List<Object> get props => [cityName];

}


class RefreshWeatherEvent extends WeatherEvent {
  final String cityName;

  RefreshWeatherEvent({this.cityName});
  @override
  List<Object> get props => [cityName];

}


class ResetWeatherEvent extends WeatherEvent {
  @override
  List<Object> get props => throw UnimplementedError();

}
