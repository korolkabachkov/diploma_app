import 'package:easymedhelp_app/components/appointment_card.dart';
import 'package:easymedhelp_app/components/doctor_card.dart';
import 'package:easymedhelp_app/models/auth_model.dart';
import 'package:easymedhelp_app/utils/configuration.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> user = {};
  Map<String, dynamic> doctor = {};
  List<dynamic> favouriteList = [];

  List<Map<String, dynamic>> medCat = [
    {
      "icon": FontAwesomeIcons.userDoctor,
      "category": "Терапевт",
    },
    {
      "icon": FontAwesomeIcons.solidEye,
      "category": "Офтальмолог",
    },
    {
      "icon": FontAwesomeIcons.heartPulse,
      "category": "Кардіолог",
    },
    {
      "icon": FontAwesomeIcons.handFist,
      "category": "Дерматолог",
    },
    {
      "icon": FontAwesomeIcons.personPregnant,
      "category": "Гінеколог",
    },
    {
      "icon": FontAwesomeIcons.teeth,
      "category": "Стоматолог",
    },
  ];

  @override
  Widget build(BuildContext context) {
    EasyMedHelpConfiguration.init(context);
    user = Provider.of<AuthModel>(context, listen: false).getUser;
    doctor = Provider.of<AuthModel>(context, listen: false).getAppointment;
    favouriteList = Provider.of<AuthModel>(context, listen: false).getFavourite;
    print(favouriteList);

    return Scaffold(
      body: user.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                color: EasyMedHelpConfiguration.primaryColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: EasyMedHelpConfiguration.primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 32,
                              backgroundImage:
                                  AssetImage('assets/profile_image.jpg'),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Вітаємо,',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  user['name'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Записи на сьогодні',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      doctor.isNotEmpty
                          ? AppointmentCard(
                              doctor: doctor,
                              color: EasyMedHelpConfiguration.primaryColor,
                            )
                          : Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    'На сьогодні записи відсутні',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 40),
                      const Text(
                        'Категорії лікарів',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: medCat.map((category) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: InkWell(
                                onTap: () {
                                  // Handle category selection
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Colors.grey
                                              .withOpacity(0.5), // Border color
                                          width: 1, // Border width
                                        ),
                                      ),
                                      child: Center(
                                        child: FaIcon(
                                          category['icon'],
                                          color: Colors.purple,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      category['category'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Популярні лікарі',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: List.generate(user['doctor'].length, (index) {
                          return DoctorCard(
                            //route: 'doc_details',
                            doctor: user['doctor'][index],
                            isFavourite: favouriteList.contains(
                                    user['doctor'][index]['doctor_id'])
                                ? true
                                : false,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
