import 'package:easymedhelp_app/main.dart';
import 'package:easymedhelp_app/models/auth_model.dart';
import 'package:easymedhelp_app/providers/dio_provider.dart';
import 'package:easymedhelp_app/screens/doctor_details.dart';
import 'package:easymedhelp_app/utils/configuration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorCard extends StatefulWidget {
  const DoctorCard({
    super.key,
    required this.doctor,
    required this.isFavourite,
  });

  final Map<String, dynamic> doctor;
  final bool isFavourite;

  @override
  _DoctorCardState createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  late bool isFavourite;

  String getPathFromUrl(String url) {
    Uri uri = Uri.parse(url);
    return uri.path;
  }

  @override
  void initState() {
    super.initState();
    isFavourite = widget
        .isFavourite; // Initialize based on the doctor data or default to false
  }

  @override
  Widget build(BuildContext context) {
    EasyMedHelpConfiguration.init(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          //pass the details to detail page
          MyApp.navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (_) => DoctorDetails(
                    doctor: widget.doctor,
                    isFavourite: widget.isFavourite,
                  )));
        },
        child: SizedBox(
          height: 150,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    "http://10.0.2.2:8000${getPathFromUrl(widget.doctor['doctor_profile'])}",
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.doctor['doctor_name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.doctor['category'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () async {
                              final list =
                                  Provider.of<AuthModel>(context, listen: false)
                                      .getFavourite;
                              if (list.contains(widget.doctor['doctor_id'])) {
                                list.removeWhere(
                                    (id) => id == widget.doctor['doctor_id']);
                              } else {
                                list.add(widget.doctor['doctor_id']);
                              }

                              Provider.of<AuthModel>(context, listen: false)
                                  .setFavouriteList(list);

                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              final token = prefs.getString('token') ?? '';
                              if (token.isNotEmpty && token != '') {
                                final response = await DioProvider()
                                    .storeFavouriteDoctor(token, list);
                                if (response == 200) {
                                  setState(() {
                                    isFavourite = !isFavourite;
                                  });
                                }
                              }
                            },
                            icon: Icon(
                              isFavourite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_outline,
                              color: Colors.red,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('booking_screen',
                                  arguments: {
                                    "doctor_id": widget.doctor['doctor_id']
                                  });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            child: const Text(
                              'Запис на прийом',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
