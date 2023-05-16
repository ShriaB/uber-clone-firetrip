import 'dart:convert';

import 'package:firetrip/common/constants/user_map_loc_info.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart';

String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
String accessToken = UserMapLocInfo.mapBoxAccessToken;
String navType = 'driving';

Future getDrivingRoute(LatLng source, LatLng destination) async {
  String url =
      '$baseUrl/$navType/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$accessToken';
  try {
    final responseData = await get(Uri.parse(url));
    return jsonDecode(responseData.body);
  } catch (e) {
    print(e);
  }
}

Future<Map> getDirectionsAPIResponse(
    LatLng sourceLatLng, LatLng destinationLatLng) async {
  final response = await getDrivingRoute(sourceLatLng, destinationLatLng);
  print(response.runtimeType);
  List<LatLng> points =
      (response['routes'][0]['geometry']['coordinates'] as List)
          .map((point) => LatLng(point[1], point[0]))
          .toList();
  num duration = response['routes'][0]['duration'];
  num distance = response['routes'][0]['distance'];
  Map routeResponse = {
    "points": points,
    "duration": duration,
    "distance": distance,
  };
  return routeResponse;
}
