import 'package:firebase_database/firebase_database.dart';
import 'package:firetrip/global/authentication/auth.dart';
import 'package:firetrip/models/trip_model.dart';
import 'package:flutter/foundation.dart';

class TripsService {
  /// Takes a trip
  /// Adds it to realtime database in Firebase against the current user
  static Future<void> addTrip(TripModel trip) async {
    DatabaseReference tripDbRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentUser!.uid)
        .child("trips");
    DatabaseReference newTripRef = tripDbRef.push();
    newTripRef.set(trip.toJson());
  }

  /// Returns all the trips of the current user
  static Future<List<TripModel>> getAllTrips() async {
    try {
      final DatabaseReference tripDbRef =
          FirebaseDatabase.instance.ref("users/${currentUser?.uid}/trips");
      final tripSnapShot = await tripDbRef.get();
      if (tripSnapShot.exists) {
        return tripSnapShot.children
            .map((e) => TripModel.fromSnapshot(e))
            .toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return [];
  }
}
