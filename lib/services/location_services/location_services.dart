import 'package:firetrip/models/location_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class LocationServices {
  final ProviderRef ref;

  LocationServices(this.ref);

  /// Determine the current position of the device.
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> getCurrentUserPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

  /// Reverse Geocoding
  /// Takes a location coordinate
  /// Returns the [LocationModel] object for it containing the [locationName], [locationAddress]
  Future<LocationModel?> getUserAddressFromPosition(LatLng location) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(location.latitude, location.longitude);
      var placemark = placemarks.first;
      LocationModel userLocationInfo = LocationModel();
      userLocationInfo.locationLatitude = location.latitude;
      userLocationInfo.locationLongitude = location.longitude;
      userLocationInfo.locationName = placemark.subLocality;
      userLocationInfo.locationAddress =
          "${placemark.street} ${placemark.subLocality} ${placemark.locality} ${placemark.postalCode}";
      return userLocationInfo;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }
}

final locationServiceProvider =
    Provider<LocationServices>((ref) => LocationServices(ref));
