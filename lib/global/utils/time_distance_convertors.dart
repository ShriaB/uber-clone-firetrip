import 'package:intl/intl.dart';

/// Takes two DateTime valiables
/// Returns the difference between them in terms of hours and minutes
/// The return string is of this format: "<hours>h <minutes>m"
String getTripDuration(DateTime? dt1, DateTime? dt2) {
  String durationString = "";
  if (dt1 != null && dt2 != null) {
    Duration duration = dt2.difference(dt1);
    durationString = "${duration.inMinutes ~/ 60}h ${duration.inMinutes % 60}m";
  }
  return durationString;
}

/// Takes distance in meters
/// Returns the distance in km correct to 2 decimal places in string format
String metersToKm(num meters) {
  return (meters / 1000).toStringAsFixed(2);
}

/// Takes duration in seconds
/// Adds the duration to current time and returns a string of the format: hour:minute
String addDurationToCurrentTime(num seconds) {
  var dropTime = DateTime.now().add(Duration(seconds: seconds.ceil()));
  return DateFormat.jm().format(dropTime);
}
