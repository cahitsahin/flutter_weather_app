import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/blocks/weatherbloc/bloc.dart';
import 'package:weatherapp/blocks/weatherbloc/weather_bloc.dart';
import 'package:weatherapp/blocks/weatherbloc/weather_event.dart';
import 'package:weatherapp/models/weather.dart';

class ShowWeather extends StatelessWidget {
  const ShowWeather({
    Key key,
    @required WeatherBloc weatherBloc,
    @required this.currentCity,
    @required Completer<void> refreshCopmleter,
    @required this.responseWeather,
  })  : _weatherBloc = weatherBloc,
        _refreshCopmleter = refreshCopmleter,
        super(key: key);

  final WeatherBloc _weatherBloc;
  final String currentCity;
  final Completer<void> _refreshCopmleter;
  final Weather responseWeather;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: MyCustomClipper(),
          child: Container(
            width: double.infinity,
            height: 260.0,
            decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [Colors.blueAccent, Colors.blue])),
          ),
        ),

        RefreshIndicator(
          onRefresh: () {
            _weatherBloc.add(RefreshWeatherEvent(cityName: currentCity));
            return _refreshCopmleter.future;
          },
          child: ListView(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    _weatherBloc.add(ResetWeatherEvent());
                  },
                  iconSize: 32,
                  icon: Icon(
                    Icons.close,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
              Center(child: LocationWidget(weather: responseWeather)),
              SizedBox(
                height: 10,
              ),
              Center(child: LastUpdateWidget(weather: responseWeather)),
              SizedBox(
                height: 10,
              ),
              Center(child: WeatherImageWidget(weather: responseWeather)),
              SizedBox(
                height: 80,
              ),
              Center(child: TemperatureWidget(weather: responseWeather)),
            ],
          ),
        ),
      ],
    );
  }
}

class LocationWidget extends StatelessWidget {
  final Weather weather;

  const LocationWidget({Key key, this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      weather.title,
      style: TextStyle(
          fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
    );
  }
}

class LastUpdateWidget extends StatelessWidget {
  final Weather weather;

  const LastUpdateWidget({Key key, this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var date = weather.time.toLocal();
    return Text(
      weather.consolidatedWeather[0].weatherStateName +
          ", " +
          DateFormat('EEEE').format(date),
      style: TextStyle(fontSize: 18, color: Colors.white),
    );
  }
}

class WeatherImageWidget extends StatelessWidget {
  final Weather weather;

  const WeatherImageWidget({Key key, this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var weatherCode = weather.consolidatedWeather[0].weatherStateAbbr;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          "https://www.metaweather.com/static/img/weather/ico/$weatherCode.ico",
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          weather.consolidatedWeather[0].theTemp.toStringAsFixed(0) + "°",
          style: TextStyle(fontSize: 42, color: Colors.white),
        ),
      ],
    );
  }
}

class TemperatureWidget extends StatelessWidget {
  final Weather weather;

  const TemperatureWidget({Key key, this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: weather.consolidatedWeather.length,
        itemBuilder: (context, index) {
          var date =
              weather.consolidatedWeather[index].applicableDate.toLocal();
          var weatherCode = weather.consolidatedWeather[index].weatherStateAbbr;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEEE').format(date),
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
                Image.network(
                  "https://www.metaweather.com/static/img/weather/ico/$weatherCode.ico",
                  height: 25,
                ),
                Text(
                  weather.consolidatedWeather[index].minTemp
                          .toStringAsFixed(0) +
                      "°/" +
                      weather.consolidatedWeather[index].maxTemp
                          .toStringAsFixed(0) +
                      "°",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        });
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    return path;
  }

  @override
  bool shouldReclip(MyCustomClipper oldClipper) => false;
}
