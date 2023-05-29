import 'package:firetrip/global/constants/colors.dart';
import 'package:firetrip/global/utils/time_distance_convertors.dart';
import 'package:firetrip/models/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class TripCardWidget extends StatefulWidget {
  final TripModel? trip;

  const TripCardWidget({super.key, required this.trip});

  @override
  State<TripCardWidget> createState() => _TripCardWidgetState();
}

class _TripCardWidgetState extends State<TripCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  /// Source location name and address
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.trip?.source?.locationName ??
                              "Source not available",
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.trip?.source?.locationAddress ??
                              "Source not available",
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.visible,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),

                  /// Arrow icon
                  const Icon(
                    Icons.arrow_right_alt,
                    color: primaryColor,
                    size: 40,
                  ),
                  const SizedBox(
                    width: 5,
                  ),

                  /// Destination location name and address
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.trip?.destination?.locationName ??
                              "Destination not available",
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.trip?.destination?.locationAddress ??
                              "Destination not available",
                          style: const TextStyle(fontSize: 16, height: 1),
                          overflow: TextOverflow.visible,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              /// Pickup date and time
              Row(
                children: [
                  const Text("Pick up:"),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(formatDate(widget.trip?.pickup) ?? "Not available")
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              /// Dropoff date and time
              Row(
                children: [
                  const Text("Drop off:"),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(formatDate(widget.trip?.dropoff) ?? "Not available")
                ],
              ),
              const Divider(
                height: 30,
                thickness: 0.5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// Distance covered in the trip
                  Text("${metersToKm(widget.trip?.distance ?? 0)} Km"),
                  const SizedBox(
                    width: 10,
                  ),

                  /// Actual Duration of trip
                  Text(widget.trip?.duration ?? "0h"),
                  const SizedBox(
                    width: 10,
                  ),

                  /// User rating for the trip
                  RatingBar.builder(
                    initialRating: widget.trip?.rideRating?.toDouble() ?? 0.0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemSize: 20,
                    onRatingUpdate: (value) {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
