// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

bool currentLocationEnable = false;

class LocationManager {
  static const String _key = 'Location';

  static Future<bool> currentLocationState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('currentLocationEnable') ?? false;
  }

  static Future<void> saveCurrentLocationState(bool state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('currentLocationEnable', state);
  }

  static Future<void> saveLocations(List<String> loc) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, loc);
  }

  static Future<List<String>> getLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static Future<void> addLocation(String loc) async {
    final locs = await getLocation();
    if (locs.contains(loc)) {
      throw Exception('Location already exists');
    }
    locs.add(loc);
    await saveLocations(locs);
  }

  static Future<void> removeLocation(String loc) async {
    final locs = await getLocation();
    if (locs.contains(loc)) {
      locs.remove(loc);
      await saveLocations(locs);
    } else {
      throw Exception('Location not found: $loc');
    }
  }
}
