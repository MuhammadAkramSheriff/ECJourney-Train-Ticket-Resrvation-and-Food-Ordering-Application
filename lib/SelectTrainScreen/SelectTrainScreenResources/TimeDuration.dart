import 'package:intl/intl.dart';

class TimeDuration {
  final int hours;
  final int minutes;

  TimeDuration(this.hours, this.minutes);
}

TimeDuration calculateHoursAndMinutes(String date, String departsTime, String arriveTime) {

  DateFormat originalFormat = DateFormat('dd-MM-yyyy');
  DateTime startDateDateTime = originalFormat.parse(date);
  DateFormat targetFormat = DateFormat('yyyy-MM-dd');
  String formattedStartDate = targetFormat.format(startDateDateTime);

  DateTime departsDateTime = DateTime.parse('$formattedStartDate $departsTime:00');
  DateTime arriveDateTime = DateTime.parse('$formattedStartDate $arriveTime:00');

  Duration journeyDuration = arriveDateTime.difference(departsDateTime);
  int hours = journeyDuration.inHours;
  int minutes = journeyDuration.inMinutes % 60;

  return TimeDuration(hours, minutes);
}