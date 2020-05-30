import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/blocks/weatherbloc/bloc.dart';
import 'package:weatherapp/blocks/weatherbloc/weather_bloc.dart';
import 'package:weatherapp/ui/weather_page.dart';

class HomePage extends StatelessWidget {
  String currentCity = "Ankara";
  Completer<void> _refreshCopmleter = Completer<void>();
  TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _weatherBloc = BlocProvider.of<WeatherBloc>(context);
    return Scaffold(
      body: BlocBuilder(
        bloc: _weatherBloc,
        builder: (context, WeatherState state) {
          if (state is InitialWeatherState) {
            return SearchCityWidget(
                weatherBloc: _weatherBloc, currentCity: currentCity,textEditingController: _cityController,);
          }
          if (state is WeatherLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is WeatherLoadedState) {
            final responseWeather = state.weather;
            _refreshCopmleter.complete();
            _refreshCopmleter = Completer();
            return ShowWeather(
                weatherBloc: _weatherBloc,
                currentCity: _cityController.text,
                refreshCopmleter: _refreshCopmleter,
                responseWeather: responseWeather);
          }
          if (state is WeatherErrorState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text("City Not Found",style: TextStyle(fontSize: 36),)),
                IconButton(
                  onPressed: () {
                    _weatherBloc.add(ResetWeatherEvent());
                  },
                  iconSize: 48,
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
              ],
            );
          }
          return Center();
        },
      ),
    );
  }
}


class SearchCityWidget extends StatelessWidget {
  const SearchCityWidget({
    Key key,
    @required WeatherBloc weatherBloc,
    @required this.currentCity, this.textEditingController,
  })  : _weatherBloc = weatherBloc,
        super(key: key);

  final WeatherBloc _weatherBloc;
  final String currentCity;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlue, Colors.purple],
          )),
        ),
        ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:80.0,bottom: 80),
              child: Image.asset(
                "assets/icon.png",
                height: 200,
                width: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Card(
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          labelText: "City Name",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        onPressed: () {
                          _weatherBloc
                              .add(FetchWeatherEvent(cityName: textEditingController.text));
                        },
                        color: Colors.lightBlue,
                        child: Text(
                          "Search",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
