import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:weatherapp/data/weather_repository.dart';
import 'package:weatherapp/locator.dart';
import 'package:weatherapp/models/weather.dart';
import './bloc.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {

  WeatherRepository weatherRepository = locator<WeatherRepository>();


  @override
  WeatherState get initialState => InitialWeatherState();

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    if(event is FetchWeatherEvent){

      yield WeatherLoadingState();
      try{
        final Weather weather = await weatherRepository.getWeather(event.cityName);
        yield WeatherLoadedState(weather: weather);
      }catch(_){
        yield WeatherErrorState();
      }
    }else if(event is RefreshWeatherEvent){
      try{
        final Weather weather = await weatherRepository.getWeather(event.cityName);
        yield WeatherLoadedState(weather: weather);
      }catch(_){
        yield state;
      }
    }else if(event is ResetWeatherEvent){
      yield InitialWeatherState();
    }
  }
}
