import 'dart:convert';

import 'package:easymedhelp_app/providers/dio_provider.dart';
import 'package:easymedhelp_app/utils/configuration.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status { upcoming, complete, cancelled }

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  Map<Status, String> statusDescriptions = {
    Status.upcoming: 'Майбутні',
    Status.complete: 'Завершені',
    Status.cancelled: 'Скасовані',
  };

  Status status = Status.upcoming;
  Alignment _alignment = Alignment.centerLeft;
  List<dynamic> schedules = [];

  Future<void> getAppointments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final appointment = await DioProvider().getAppointments(token);
    if (appointment != 'Error') {
      setState(() {
        schedules = json.decode(appointment);
      });
    }
  }

  @override
  void initState() {
    getAppointments();
    super.initState();
  }

  String getPathFromUrl(String url) {
    Uri uri = Uri.parse(url);
    return uri.path;
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredSchedules = schedules.where((var schedule) {
      switch (schedule['status']) {
        case 'upcoming':
          schedule['status'] = Status.upcoming;
          break;
        case 'complete':
          schedule['status'] = Status.complete;
          break;
        case 'cancelled':
          schedule['status'] = Status.cancelled;
          break;
      }
      return schedule['status'] == status;
    }).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Записи до лікарів',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (Status filterStatus in Status.values)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                status = filterStatus;
                                // Set _alignment based on filterStatus
                                if (filterStatus == Status.upcoming) {
                                  _alignment = Alignment.centerLeft;
                                } else if (filterStatus == Status.complete) {
                                  _alignment = Alignment.center;
                                } else if (filterStatus == Status.cancelled) {
                                  _alignment = Alignment.centerRight;
                                }
                              });
                            },
                            child: Center(
                              child: Text(statusDescriptions[filterStatus]!),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                AnimatedAlign(
                  alignment: _alignment,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: EasyMedHelpConfiguration.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        statusDescriptions[status]!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            EasyMedHelpConfiguration.spacingM(),
            Expanded(
              child: Center(
                child: ListView.builder(
                  itemCount:
                      filteredSchedules.isEmpty ? 1 : filteredSchedules.length,
                  itemBuilder: ((context, index) {
                    if (filteredSchedules.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 100,
                              color: EasyMedHelpConfiguration.secondaryColor,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Немає записів',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      var schedule = filteredSchedules[index];
                      bool isLastElement =
                          filteredSchedules.length + 1 == index;
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: !isLastElement
                            ? const EdgeInsets.only(bottom: 20)
                            : EdgeInsets.zero,
                        color: EasyMedHelpConfiguration.secondaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      "http://10.0.2.2:8000${getPathFromUrl(schedule['doctor_profile'])}",
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        schedule['doctor_name'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        schedule['category'],
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              ScheduleCard(
                                date: schedule['date'],
                                day: schedule['day'],
                                time: schedule['time'],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (schedule['status'] != Status.complete)
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.white),
                                        ),
                                        child: const Text(
                                          'Відмінити',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: const BorderSide(
                                            color: Colors.white),
                                      ),
                                      onPressed: () {},
                                      child: const Text(
                                        'Перезаписатися',
                                        style: TextStyle(
                                            color: EasyMedHelpConfiguration
                                                .primaryColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    super.key,
    required this.date,
    required this.day,
    required this.time,
  });

  final String? date;
  final String? day;
  final String? time;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: EasyMedHelpConfiguration.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 15,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              '$day, $date',
              style: const TextStyle(
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 20),
          const Icon(
            Icons.access_alarm,
            color: Colors.white,
            size: 17,
          ),
          const SizedBox(width: 5),
          Text(
            '$time',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
