import 'package:firetrip/global/constants/colors.dart';
import 'package:firetrip/global/routes/route_names.dart';
import 'package:firetrip/global/styles/styles.dart';
import 'package:firetrip/global/utils/time_distance_convertors.dart';
import 'package:firetrip/models/location_model.dart';
import 'package:firetrip/provider/trip_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom Sheet widget
class BottomSheetWidget extends ConsumerStatefulWidget {
  late final LocationModel source;
  late final LocationModel destination;
  num distance = 0.0;
  num duration = 0.0;

  BottomSheetWidget(
      {super.key,
      required this.source,
      required this.destination,
      required this.distance,
      required this.duration});

  @override
  ConsumerState<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends ConsumerState<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "${widget.source.locationName}",
                style: const TextStyle(fontSize: 18),
              ),
              const Icon(
                Icons.arrow_right_alt,
                color: primaryColor,
                size: 40,
              ),
              Text(
                "${widget.destination.locationName}",
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    "assets/images/car.png",
                    height: 50,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "FireTrip Prime",
                        style: TextStyle(
                            color: blackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                          "${metersToKm(widget.distance)} Km, ${addDurationToCurrentTime(widget.duration)}"),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "₹340.0",
                    style: TextStyle(
                        color: blackColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: textButtonStyle,
            onPressed: () {
              ref.read(tripStateNotifierProvider.notifier).setPickUpTime();
              Navigator.pushReplacementNamed(context, RouteNames.navigation);
            },
            child: const Text(
              "Start you ride",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
