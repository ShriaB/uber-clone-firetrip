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

  LocationModel.fromJson(Map<String, dynamic> json) {
    locationId = json['id'];
    locationName = json['text'];
    locationAddress = json['place_name'];
    locationLatitude = json['center'][1];
    locationLongitude = json['center'][0];
  }
}
