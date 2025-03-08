import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather03/Helper/fetch_data.dart';
import 'package:weather03/Helper/fetch_location.dart';
import 'package:weather03/Helper/location_manager.dart';
import 'package:weather03/Locations/add_location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.appName});

  final String appName;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> locations = [];
  String? _errorMessage;
  bool _isLoading = true;
  List<Weather?> weatherData = [];

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  void _fetchAllWeather() async {
    List<Weather?> tempData = [];
    for (String location in locations) {
      Weather? weather = await _fetchWeather(location);
      tempData.add(weather);
    }
    setState(() {
      weatherData = tempData;
      _isLoading = false;
    });
  }

  void _loadLocations() async {
    final savedLocations = await LocationManager.getLocation();
    setState(() {
      locations = savedLocations;
    });
    _fetchAllWeather();
  }

  Future<Weather?> _fetchWeather(location) async {
    currentLocationEnable = false;
    if (currentLocationEnable == true) {
      // For current location
      try {
        var position = await getCurrentLocation();
        Weather? result = await Weather.fetchWeatherLocation(
          position.longitude,
          position.latitude,
        );
        setState(() {
          _isLoading = false;
        });
        return result;
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to load the Weather data. $e';
          _isLoading = false;
        });
        return null;
      }
    } else {
      // for location manager!
      try {
        Weather? result = await Weather.fetchWeatherArea(location);
        setState(() {
          _isLoading = false;
        });
        return result;
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to load the Weather Data. $e';
          _isLoading = false;
        });
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appName, style: TextStyle(fontFamily: 'Pacifico')),
        centerTitle: true,
        leading: IconButton(
            onPressed: _fetchAllWeather, icon: Icon(Icons.refresh)),
        actions: [
          IconButton(
            onPressed:
                () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddLocation(appName: widget.appName),
                  ),
              );
              _loadLocations();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: PageView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          Weather? response =
              (index < weatherData.length) ? weatherData[index] : null;
          return RefreshIndicator(
            onRefresh: () async {
              Weather? newWeather = await _fetchWeather(locations[index]);
              if (newWeather != null) {
                setState(() => weatherData[index] = newWeather);
              }
            },
            child: Padding(
              padding: EdgeInsets.all(3),
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? Center(child: Text(_errorMessage!))
                  : ListView(
                // spacing: 3,
                children: [
                  SizedBox(
                    height: 350,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${response!.city} (${_convertTime(
                              response.timezone)})',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '${response.temperature}',
                              style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.network(
                              'https://openweathermap.org/img/wn/${response
                                  .icon}@2x.png',
                            ),
                          ],
                        ),
                        Text(
                          'Feels like ${response.feels_like}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: Row(
                      spacing: 3,
                      children: [
                        Expanded(
                          child: Text(
                            'Max Temp: ${response.temp_max}',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Min Temp: ${response.temp_min}',
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: Row(
                      spacing: 3,
                      children: [
                        Expanded(
                          child: Text(
                            'Visibility: ${response.visibility}',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Outside: ${response.description}',
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: Row(
                      spacing: 3,
                      children: [
                        Expanded(
                          child: Text(
                            'Humidity: ${response.humidity}',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Pressure: ${response.pressure} mmHg',
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: Row(
                      spacing: 3,
                      children: [
                        Expanded(
                          child: Text(
                            'Wind Speed: ${response.wind_speed}',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Wind Direction: ${response.wind_direction}',
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: Row(
                      spacing: 3,
                      children: [
                        Expanded(
                          child: Text(
                            'Sunrise: ${DateFormat('hh:mm:ss a').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    response.sunrise))}',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Sea level: ${response.sea_level} m',
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: Row(
                      spacing: 3,
                      children: [
                        Expanded(
                          child: Text(
                            'Sunset: ${DateFormat('hh:mm:ss a').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    response.sunset))}',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Ground level: ${response.grd_level} m',
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // floatingActionButton: IconButton(onPressed: _fetchWeather, icon: Icon(Icons.refresh)),
    );
  }

  String _convertTime(int time) {
    if (time == 0) {
      return '0';
    }
    return '${(time ~/ 3600)}:${((time % 3600) ~/ 60)}';
  }
}
