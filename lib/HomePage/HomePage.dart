import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather03/Helper/fetch_data.dart';
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
  Weather? response;

  @override
  void initState() {
    super.initState();
    locations.add('Kolkata');
    _loadLocations();
    _fetchWeather();
  }

  void _loadLocations() async {
    final savedLocations = await LocationManager.getLocation();
    setState(() {
      locations = savedLocations;
    });
  }

  void _fetchWeather() async {
    try {
      response = await Weather.fetchWeather(locations[0]);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load the Weather Data. $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appName),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddLocation(appName: widget.appName),
                  ),
                ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(3),
        child: _isLoading
            ? Center(
            child: CircularProgressIndicator()) // Show loading indicator
            : _errorMessage != null
            ? Center(child: Text(_errorMessage!)) // Show error message
            : Column(
          spacing: 3,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${response!.city} (${convertTime(response!.timezone)})',
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w700)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('${response!.temperature}', style: TextStyle(
                          fontSize: 100, fontWeight: FontWeight.bold)),
                      Image.network(
                          'https://openweathermap.org/img/wn/${response!
                              .icon}@2x.png'),
                    ],
                  ),
                  Text('Feels like ${response!.feels_like}', style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                spacing: 3,
                children: [
                  Expanded(child: Text('Max Temp: ${response!.temp_max}',
                      textAlign: TextAlign.start)),
                  Expanded(child: Text('Min Temp: ${response!.temp_min}',
                      textAlign: TextAlign.end)),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                spacing: 3,
                children: [
                  Expanded(child: Text('Visibility: ${response!.visibility}',
                      textAlign: TextAlign.start)),
                  Expanded(child: Text('Outside: ${response!.description}',
                      textAlign: TextAlign.end)),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                spacing: 3,
                children: [
                  Expanded(child: Text('Humidity: ${response!.humidity}',
                      textAlign: TextAlign.start)),
                  Expanded(child: Text('Pressure: ${response!.pressure} mmHg',
                      textAlign: TextAlign.end)),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                spacing: 3,
                children: [
                  Expanded(child: Text('Wind Speed: ${response!.wind_speed}',
                      textAlign: TextAlign.start)),
                  Expanded(child: Text(
                      'Wind Direction: ${response!.wind_direction}',
                      textAlign: TextAlign.end)),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                spacing: 3,
                children: [
                  Expanded(
                    child: Text('Sunrise: ${DateFormat('hh:mm:ss a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            response!.sunrise))}\n'
                        'Sunset: ${DateFormat('hh:mm:ss a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            response!.sunset))}', textAlign: TextAlign.start,),
                  ),
                  Expanded(
                    child: Text('Sea level: ${response!
                        .sea_level} m\nGround level: ${response!.grd_level} m',
                      textAlign: TextAlign.end,),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String convertTime(int time) {
  if (time == 0) {
    return '0';
  }
  return '${(time ~/ 3600)}:${((time % 3600) ~/ 60)}';
}