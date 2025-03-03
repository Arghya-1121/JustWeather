import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather03/api.dart';

class Weather {
  final String city;
  final double temperature;
  final String description;
  final String icon;
  final double feels_like;
  final double temp_min;
  final double temp_max;
  final int pressure;
  final int humidity;
  final int sea_level;
  final int grd_level;
  final int visibility;
  final double wind_speed;
  final double wind_direction;
  final int sunrise;
  final int sunset;
  final int timezone;

  Weather({
    required this.timezone,
    required this.feels_like,
    required this.temp_min,
    required this.temp_max,
    required this.pressure,
    required this.humidity,
    required this.sea_level,
    required this.grd_level,
    required this.visibility,
    required this.wind_speed,
    required this.wind_direction,
    required this.sunrise,
    required this.sunset,
    required this.city,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    city: json['name'] ?? 'Unknown City',
    visibility: json['visibility']?.toInt() ?? 0,
    timezone: json['timezone']?.toInt() ?? 0,
    icon: json['weather'][0]['icon'] ?? '01d',
    description: json['weather'][0]['description'] ?? 'Fine',
    temperature: json['main']['temp']?.toDouble() ?? 0.0,
    feels_like: json['main']['feels_like']?.toDouble() ?? 0.0,
    grd_level: json['main']['grnd_level']?.toInt() ?? 0,
    humidity: json['main']['humidity']?.toInt() ?? 0,
    pressure: json['main']['pressure']?.toInt() ?? 0,
    sea_level: json['main']['sea_level']?.toInt() ?? 0,
    temp_max: json['main']['temp_max']?.toDouble() ?? 0.0,
    temp_min: json['main']['temp_min']?.toDouble() ?? 0.0,
    sunrise: json['sys']['sunrise']?.toInt() ?? 0,
    sunset: json['sys']['sunset']?.toInt() ?? 0,
    wind_speed: json['wind']['speed']?.toDouble() ?? 0.0,
    wind_direction: json['wind']['deg']?.toDouble() ?? 0.0,
  );

  static Future<Weather> fetchWeatherArea(String city) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${WeatherApi.API}&units=metric',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  static Future<Weather> fetchWeatherLocation(double lon, double lat) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=${WeatherApi.API}&units=metric',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
