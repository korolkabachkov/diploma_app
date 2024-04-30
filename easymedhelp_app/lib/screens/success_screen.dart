import 'package:easymedhelp_app/components/button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BookingSuccess extends StatelessWidget {
  const BookingSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Lottie.asset(
                  'assets/1ffkxqZXIv.json',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Запис успішно здійснено!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Ваш запис призначений на 18 квітня о 12:00. Для отримання додаткової інформації перегляньте вкладку "Записи".',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Button(
                width: double.infinity,
                title: 'На головну',
                onPressed: () => Navigator.of(context).pushNamed('main'),
                disabled: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
