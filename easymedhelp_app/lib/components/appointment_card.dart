import 'package:easymedhelp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:easymedhelp_app/utils/configuration.dart';
import 'package:easymedhelp_app/providers/dio_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rating_dialog/rating_dialog.dart';

class AppointmentCard extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final Color color;

  const AppointmentCard({super.key, required this.doctor, required this.color});

  @override
  _AppointmentCardState createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  String getPathFromUrl(String url) {
    Uri uri = Uri.parse(url);
    return uri.path;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: widget.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {}, // For future implementation
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDoctorInfo(context),
              const SizedBox(height: 20),
              ScheduleCard(appointment: widget.doctor['appointments']),
              const SizedBox(height: 20),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorInfo(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
            "http://10.0.2.2:8000${getPathFromUrl(widget.doctor['doctor_profile'])}",
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.doctor['doctor_name'],
                style: EasyMedHelpConfiguration.textTheme.bodyLarge!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.doctor['category'],
                style: EasyMedHelpConfiguration.textTheme.bodySmall!.copyWith(
                  fontSize: 14, // Set the font size to 14
                  fontWeight: FontWeight.normal, // Set text weight to bold
                  color: Colors.white70, // Maintain the existing color
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: EasyMedHelpConfiguration.primaryColor,
              side: const BorderSide(
                  color: Colors.white, width: 2), // Adds a white border
              shape: RoundedRectangleBorder(
                // Ensures the border radius is applied
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Відмінити',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return RatingDialog(
                        initialRating: 1.0,
                        title: const Text(
                          'Rate the Doctor',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        message: const Text(
                          'Please help us to rate our Doctor',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        image: const FlutterLogo(
                          size: 100,
                        ),
                        submitButtonText: 'Submit',
                        commentHint: 'Your Reviews',
                        onSubmitted: (response) async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          final token = prefs.getString('token') ?? '';

                          final rating = await DioProvider().storeReviews(
                              response.comment,
                              response.rating,
                              widget.doctor['appointments']
                                  ['id'], //this is appointment id
                              widget.doctor['doctor_id'], //this is doctor id
                              token);

                          //if successful, then refresh
                          if (rating == 200 && rating != '') {
                            MyApp.navigatorKey.currentState!.pushNamed('main');
                          }
                        });
                  });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: const Text('Завершити',
                style: TextStyle(color: EasyMedHelpConfiguration.primaryColor)),
          ),
        ),
      ],
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const ScheduleCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EasyMedHelpConfiguration.secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            '${appointment['day']}, ${appointment['date']}',
            style: const TextStyle(color: Colors.white),
          ),
          const Spacer(),
          const Icon(Icons.access_time, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            appointment['time'],
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
