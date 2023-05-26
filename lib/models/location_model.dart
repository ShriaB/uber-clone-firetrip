/// [locationId] Unique ID of the location if available
/// [locationName] Name of the location
/// [locationAddress] Proper address of the location
/// [locationLatitude]  Location Latitude
/// [locationLongitude] Location Longitude

class LocationModel {
  String? locationId;
  String? locationName;
  String? locationAddress;
  double? locationLatitude;
  double? locationLongitude;

  LocationModel({
    this.locationId,
    this.locationName,
    this.locationAddress,
    this.locationLatitude,
    this.locationLongitude,
  });

  /// Converts a Map containing location information to a [LocationModel] object
  /// Used when we are fetching Location suggestions from Mapbox Search API while searching dropoff location
  LocationModel.fromJson(Map<dynamic, dynamic> json) {
    locationId = json['id'];
    locationName = json['text'];
    locationAddress = json['place_name'];
    locationLatitude = json['center'][1];
    locationLongitude = json['center'][0];
  }

  /// Converts a snap from Firebase to [LocationModel] object
  /// Used when Trips containing [LocationModel] objects are fetched from Firebase
  LocationModel.fromSnapshot(Map<dynamic, dynamic> snap) {
    locationId = snap["locid"];
    locationName = snap["location_name"];
    locationAddress = snap["location_address"];
    locationLatitude = snap["latitude"];
    locationLongitude = snap["longitude"];
  }

  /// Converts the current [LocationModel] object to a Map
  /// Used when trips containing [LocationModel] are added to Firebase
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'locid': locationId,
      'location_name': locationName,
      'location_address': locationAddress,
      'latitude': locationLatitude,
      'longitude': locationLongitude
    };
    return data;
  }
}
