import 'package:easymedhelp_app/models/auth_model.dart';
import 'package:easymedhelp_app/screens/booking_screen.dart';
import 'package:easymedhelp_app/screens/success_screen.dart';
import 'package:easymedhelp_app/utils/configuration.dart';
import 'package:easymedhelp_app/screens/auth_screen.dart';
import 'package:easymedhelp_app/utils/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() {
  initializeDateFormatting('uk_UA', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    EasyMedHelpConfiguration.init(context);
    return ChangeNotifierProvider<AuthModel>(
      create: (context) => AuthModel(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'EasyMedHelp App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
            focusColor: EasyMedHelpConfiguration.primaryColor,
            border: EasyMedHelpConfiguration.outlinedBorder,
            focusedBorder: EasyMedHelpConfiguration.focusBorder,
            errorBorder: EasyMedHelpConfiguration.errorBorder,
            enabledBorder: EasyMedHelpConfiguration.outlinedBorder,
            floatingLabelStyle: TextStyle(
              color: EasyMedHelpConfiguration.primaryColor,
            ),
            prefixIconColor: Colors.black38,
          ),
          scaffoldBackgroundColor: Colors.white,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: EasyMedHelpConfiguration.primaryColor,
            selectedItemColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            unselectedItemColor: EasyMedHelpConfiguration.secondaryColor,
            elevation: 10,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthScreen(),
          'main': (context) => const MainLayout(),
          'booking_screen': (context) => const BookingScreen(),
          'success_screen': (context) => const BookingSuccess(),
        },
      ),
    );
  }
}
