import 'package:weatherapp/data/weather_api_client.dart';
import 'package:weatherapp/locator.dart';
import 'package:weatherapp/models/weather.dart';

class WeatherRepository{

  WeatherApiClient weatherApiClient = locator<WeatherApiClient>();

  Future<Weather> getWeather(String cityName) async {


    final int cityID = await weatherApiClient.getLocationID(cityName);
    return await weatherApiClient.getWeather(cityID);

  }
}