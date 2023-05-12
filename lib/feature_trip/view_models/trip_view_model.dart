import 'package:firetrip/feature_home/models/location_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripViewModel {
  LocationModel? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;
  // List<String> tripHistoryKeyList = [];
  // List<TripHistoryModel> allTripInfoList = [];
}

class TripStateNotifier extends StateNotifier<TripViewModel> {
  TripStateNotifier() : super(TripViewModel());

  void updatePickupLocationAddress(LocationModel userPickUpaddress) {
    print("in viewmodel");
    state.userPickUpLocation = userPickUpaddress;
    print(state.userPickUpLocation?.locationName);
  }

  void updateDropoffLocationAddress(LocationModel userDropOffaddress) {
    state.userDropOffLocation = userDropOffaddress;
  }
}

final tripStateNotifierProvider =
    StateNotifierProvider<TripStateNotifier, TripViewModel>(
        (ref) => TripStateNotifier());
