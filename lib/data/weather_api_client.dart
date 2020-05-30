import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weatherapp/models/weather.dart';

class WeatherApiClient{

  static const baseUrl = "https://www.metaweather.com";
  final http.Client httpClient = http.Client();


  Future<int> getLocationID(String cityName) async {
    final cityUrl = baseUrl+"/api/location/search/?query="+cityName;
    final response = await httpClient.get(cityUrl);
    
    if(response.statusCode != 200){
      throw Exception("Server Not Respond");
    }

    final responseJson = (jsonDecode(response.body)) as List;
    return responseJson[0]["woeid"];
  }


  Future<Weather> getWeather(int cityID) async {
    final weatherUrl = baseUrl+"/api/location/$cityID";

    final response = await httpClient.get(weatherUrl);

    if(response.statusCode != 200){
      throw Exception("Server Not Respond");
    }

    final responseJson = (jsonDecode(response.body));

    return Weather.fromJson(responseJson);

  }

}