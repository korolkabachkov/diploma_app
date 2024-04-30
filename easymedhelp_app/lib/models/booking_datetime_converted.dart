import 'package:intl/intl.dart';

//this basically is to convert date/day/time from calendar to string
class DateConverted {
  static String getDate(DateTime date) {
    return DateFormat.yMd().format(date);
  }

  static String getDay(int day) {
    switch (day) {
      case 1:
        return 'Понеділок';
      case 2:
        return 'Вівторок';
      case 3:
        return 'Середа';
      case 4:
        return 'Четвер';
      case 5:
        return 'П\'ятниця';
      case 6:
        return 'Субота';
      case 7:
        return 'Неділя';
      default:
        return 'Неділя';
    }
  }

  static String getTime(int time) {
    switch (time) {
      case 0:
        return '9:00';
      case 1:
        return '10:00';
      case 2:
        return '11:00';
      case 3:
        return '12:00';
      case 4:
        return '13:00';
      case 5:
        return '14:00';
      case 6:
        return '15:00';
      case 7:
        return '16:00';
      case 8:
        return '17:00';
      case 9:
        return '18:00';
      case 10:
        return '19:00';
      case 11:
        return '20:00';
      default:
        return '9:00';
    }
  }
}
