import 'package:easymedhelp_app/main.dart';
import 'package:easymedhelp_app/models/auth_model.dart';
import 'package:easymedhelp_app/providers/dio_provider.dart';
import 'package:easymedhelp_app/utils/configuration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Map<String, dynamic> user = {};

  @override
  Widget build(BuildContext context) {
    EasyMedHelpConfiguration.init(context);
    user = Provider.of<AuthModel>(context, listen: false).getUser;

    return Scaffold(
      backgroundColor: EasyMedHelpConfiguration
          .primaryColor, // Change to your desired background color
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: EasyMedHelpConfiguration.primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CircleAvatar(
                    radius: 65.0,
                    backgroundImage: AssetImage('assets/profile_image.jpg'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '20 років | Жіноча',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildMenuItem(Icons.person, "Профіль", () {}),
                  const SizedBox(height: 20),
                  _buildMenuItem(Icons.history, "Історія записів", () {}),
                  const SizedBox(height: 20),
                  _buildMenuItem(
                    Icons.logout_outlined,
                    "Вийти",
                    () async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final token = prefs.getString('token') ?? '';

                      if (token.isNotEmpty && token != '') {
                        final response = await DioProvider().logout(token);

                        if (response == 200) {
                          await prefs.remove('token');
                          MyApp.navigatorKey.currentState!
                              .pushReplacementNamed('/');
                        } else {
                          // Handle error if logout failed
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Logout Failed'),
                              content: const Text(
                                  'Unable to logout. Please try again later.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap, // Use the passed onTap callback
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: EasyMedHelpConfiguration.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: EasyMedHelpConfiguration.primaryColor,
              size: 35,
            ),
            const SizedBox(width: 20),
            Text(
              label,
              style: const TextStyle(
                color: EasyMedHelpConfiguration.primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
