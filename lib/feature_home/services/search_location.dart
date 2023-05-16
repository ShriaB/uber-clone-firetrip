import 'dart:convert';

import 'package:firetrip/feature_home/models/location_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';

String baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
String accessToken =
    "pk.eyJ1Ijoic2hyaWFicWkiLCJhIjoiY2xnMGJtbzRiMDIwdjNocDl3aXpxNjB6aiJ9.ixuCiBzs3OLVJ86jTymR1w";
String searchType = 'place%2Cpostcode%2Caddress';
String searchResultsLimit = '5';
String country = 'in';

// Dio _dio = Dio();

Future<dynamic> getSearchResultsFromQueryService(
    String query, LatLng point) async {
  print("In getSearchResultsFromQueryService");
  String proximity = '${point.longitude}%2C${point.latitude}';
  print(proximity);
  // print(dotenv.env['MAPBOX_ACCESS_TOKEN']!);
  String url =
      '$baseUrl/$query.json?country=$country&limit=$searchResultsLimit&proximity=$proximity&types=$searchType&access_token=$accessToken';
  print(url);
  try {
    // _dio.options.contentType = Headers.jsonContentType;
    final responseData = await get(Uri.parse(url));
    print(responseData);
    return jsonDecode(responseData.body);
  } catch (e) {
    print(e);
  }
}

Future<List<LocationModel>?> getSearchResultsFromQuery(
    String query, LocationModel? location) async {
  print(
      "${query}, ${location?.locationLatitude}, ${location?.locationLongitude}");
  try {
    if (location?.locationLatitude != null &&
        location?.locationLongitude != null) {
      print("inside if");
      LatLng point = LatLng(
          location?.locationLatitude ?? 22, location?.locationLongitude ?? 89);
      print("after latlong");
      dynamic response = await getSearchResultsFromQueryService(query, point);
      print("after function call");
      List<dynamic> searchedLocations = response['features'];
      print(response["features"]);
      print(response["features"].runtimeType);
      List<LocationModel> searchedList = searchedLocations.map((loc) {
        print("\n");
        return LocationModel.fromJson(loc);
      }).toList();
      // print(searchedList);
      return searchedList;
    }
  } catch (e) {
    print(e);
  }
}
