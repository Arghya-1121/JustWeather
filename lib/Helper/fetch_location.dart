// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// Future<String> currentLocation() async {
//   LocationPermission locationPermission = await Geolocator.checkPermission();
//   if (locationPermission == LocationPermission.denied){
//     locationPermission = await Geolocator.requestPermission();
//   }
//   Position currentPosition = await Geolocator.getCurrentPosition();
//   List<Placemark> currentLoc = await placemarkFromCoordinates(currentPosition.latitude, currentPosition.longitude);
//   String? nearby = currentLoc[0].locality;
//   // print("\n\n\n${nearby}");
//   return nearby??"";
// }

import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw 'Location permissions are denied';
    }
  }
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw 'Location services are disabled.';
  }
  if (permission == LocationPermission.deniedForever) {
    throw 'Location permissions are permanently denied, we cannot request permissions.';
  }
  return await Geolocator.getCurrentPosition();
}