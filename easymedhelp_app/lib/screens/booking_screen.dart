import 'package:easymedhelp_app/components/button.dart';
import 'package:easymedhelp_app/components/custom_appbar.dart';
import 'package:easymedhelp_app/providers/dio_provider.dart';
import 'package:easymedhelp_app/utils/configuration.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:easymedhelp_app/models/booking_datetime_converted.dart';
import 'package:easymedhelp_app/main.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;
  String? token;

  Future<void> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EasyMedHelpConfiguration.init(context);
    final doctor = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
        appBar: const CustomAppBar(
          appTitle: 'Запис на прийом',
          icon: FaIcon(Icons.arrow_back_ios),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  _tableCalendar(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                    child: Center(
                      child: Text(
                        'Виберіть час консультації',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            _isWeekend
                ? SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      alignment: Alignment.center,
                      child: const Text(
                        'У вихідні дні запис недоступний, будь ласка, оберіть іншу дату',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .grey, // Changed to make the message stand out
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildTimeSlot(index),
                      childCount:
                          12, // Assuming 12 slots from 9:00 to 20:00, adjust accordingly
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio:
                          1.5, // Adjusted aspect ratio for better visual alignment
                    ),
                  ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 32),
                child: Button(
                  width: double.infinity,
                  title: 'Записатися на прийом',
                  onPressed: () async {
                    //convert date/day/time into string first
                    final getDate = DateConverted.getDate(_currentDay);
                    final getDay = DateConverted.getDay(_currentDay.weekday);
                    final getTime = DateConverted.getTime(_currentIndex!);

                    final booking = await DioProvider().bookAppointment(
                        getDate, getDay, getTime, doctor['doctor_id'], token!);

                    if (booking == 200) {
                      MyApp.navigatorKey.currentState!
                          .pushNamed('success_screen');
                    }
                  },
                  disabled: _timeSelected && _dateSelected ? false : true,
                ),
              ),
            ),
          ],
        ));
  }

  Widget _tableCalendar() {
    // Define the start and end dates for the calendar
    final DateTime firstDay = DateTime.now();
    final DateTime lastDay = DateTime(2024, 12, 31);

    // Decoration for today in the calendar
    final BoxDecoration todayDecoration = BoxDecoration(
      color: EasyMedHelpConfiguration.primaryColor, // Base color
      shape: BoxShape.circle, // Shape of the decoration
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5), // Shadow color
          spreadRadius: 1,
          blurRadius: 7,
          offset: const Offset(3, 3), // Shadow position
        ),
      ],
    );

    // Available calendar formats
    final Map<CalendarFormat, String> availableCalendarFormats = {
      CalendarFormat.month: 'Month',
    };

    // Handle changes in calendar format
    void onFormatChanged(CalendarFormat format) {
      setState(() {
        _format = format;
      });
    }

    // Handle day selection events
    void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
      setState(() {
        _currentDay = selectedDay;
        _focusDay = focusedDay;
        _dateSelected = true;
        _isWeekend = selectedDay.weekday == 6 || selectedDay.weekday == 7;
        _timeSelected = !_isWeekend;
        _currentIndex = _isWeekend ? null : _currentIndex;
      });
    }

    // Widget configuration for TableCalendar
    return TableCalendar(
      focusedDay: _focusDay,
      firstDay: firstDay,
      lastDay: lastDay,
      calendarFormat: _format,
      currentDay: _currentDay,
      rowHeight: 56,
      calendarStyle: CalendarStyle(todayDecoration: todayDecoration),
      availableCalendarFormats: availableCalendarFormats,
      onFormatChanged: onFormatChanged,
      onDaySelected: onDaySelected,
    );
  }

  bool _isTimePast(int index) {
    final now = DateTime.now();
    final selectedTime = DateTime(now.year, now.month, now.day, 9 + index);
    return now.isAfter(selectedTime);
  }

  Widget _buildTimeSlot(int index) {
    final bool isPastTime = _currentDay.day == DateTime.now().day &&
        _currentDay.month == DateTime.now().month &&
        _currentDay.year == DateTime.now().year &&
        _isTimePast(index);

    return GestureDetector(
      onTap: !isPastTime
          ? () {
              setState(() {
                _currentIndex = index;
                _timeSelected = true;
              });
            }
          : null,
      child: Opacity(
        opacity: isPastTime ? 0.5 : 1, // Dim past times
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: _currentIndex == index && !isPastTime
                  ? EasyMedHelpConfiguration.primaryColor
                  : Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
            color: _currentIndex == index && !isPastTime
                ? EasyMedHelpConfiguration.primaryColor.withOpacity(0.8)
                : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            '${9 + index}:00',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _currentIndex == index && !isPastTime
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
