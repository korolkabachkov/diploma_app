import 'dart:convert';
import 'package:easymedhelp_app/components/button.dart';
import 'package:easymedhelp_app/main.dart';
import 'package:easymedhelp_app/models/auth_model.dart';
import 'package:easymedhelp_app/providers/dio_provider.dart';
import 'package:easymedhelp_app/utils/configuration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscured = true; // Чи приховувати пароль

  @override
  Widget build(BuildContext context) {
    // Ініціалізуємо конфігурацію за допомогою контексту
    EasyMedHelpConfiguration.init(context);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Віджет для введення адреси електронної пошти
          _buildEmailTextField(),
          EasyMedHelpConfiguration.spacingS,
          // Віджет для введення пароля
          _buildPasswordTextField(),
          EasyMedHelpConfiguration.spacingS,
          // Кнопка для входу
          _buildLoginButton(),
        ],
      ),
    );
  }

  // Метод для створення поля вводу електронної пошти
  Widget _buildEmailTextField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      cursorColor: EasyMedHelpConfiguration.primaryColor,
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: EasyMedHelpConfiguration.outlinedBorder,
        hintText: 'Електронна адреса',
        prefixIcon: Icon(Icons.email_outlined,
            color: EasyMedHelpConfiguration.primaryColor),
      ),
      style: EasyMedHelpConfiguration.textTheme.bodyLarge,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Будь ласка, введіть адресу електронної пошти';
        }
        if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          return 'Будь ласка, введіть дійсну адресу електронної пошти';
        }
        return null;
      },
    );
  }

  // Метод для створення поля введення паролю
  Widget _buildPasswordTextField() {
    return TextFormField(
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      cursorColor: EasyMedHelpConfiguration.primaryColor,
      obscureText: _isPasswordObscured,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: EasyMedHelpConfiguration.outlinedBorder,
        hintText: 'Пароль',
        prefixIcon: const Icon(Icons.lock_outline,
            color: EasyMedHelpConfiguration.primaryColor),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isPasswordObscured = !_isPasswordObscured;
            });
          },
          icon: _isPasswordObscured
              ? const Icon(Icons.visibility_off_outlined, color: Colors.black38)
              : const Icon(Icons.visibility_outlined,
                  color: EasyMedHelpConfiguration.primaryColor),
        ),
      ),
      style: EasyMedHelpConfiguration.textTheme.bodyLarge,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Будь ласка, введіть свій пароль';
        }
        if (value.length < 6) {
          return 'Пароль має бути не менше 6 символів';
        }
        return null;
      },
    );
  }

  // Метод для створення кнопки входу
  Widget _buildLoginButton() {
    return Consumer<AuthModel>(
      builder: (context, auth, child) {
        return Button(
          width: double.infinity,
          title: 'Увійти',
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final bool token = await DioProvider().getToken(
                _emailController.text,
                _passwordController.text,
              );

              if (token) {
                _handleLogin(auth);
              } else {
                _showErrorSnackbar();
              }
            }
          },
          disabled: false,
        );
      },
    );
  }

  // Метод для обробки входу користувача
  void _handleLogin(AuthModel auth) async {
    // Отримуємо доступ до локальних налаштувань для отримання токена
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    // Перевіряємо, чи токен не є порожнім або нульовим
    if (token != null && token.isNotEmpty) {
      // Отримуємо дані користувача за допомогою токена
      final getUserResult = await _getUserData(token);
      // Якщо дані користувача успішно отримано
      if (getUserResult != null) {
        // Обробляємо дані користувача
        _processUserData(auth, getUserResult);
      }
    }
  }

// Метод для отримання даних користувача за допомогою токена
  Future<Map<String, dynamic>?> _getUserData(String token) async {
    // Отримуємо дані користувача за допомогою DioProvider
    final getUserResult = await DioProvider().getUser(token);
    // Перевіряємо, чи отримано дані користувача
    if (getUserResult != null) {
      // Повертаємо дані у форматі Map<String, dynamic>
      return json.decode(getUserResult);
    } else {
      // Якщо дані не отримано, повертаємо null
      return null;
    }
  }

// Метод для обробки отриманих даних користувача
  void _processUserData(AuthModel auth, Map<String, dynamic>? userData) {
    // Якщо дані користувача не порожні
    if (userData != null) {
      // Шукаємо записи до лікаря, якщо вони є
      final appointment = _findAppointment(userData);
      // Передаємо дані користувача та записи моделі AuthModel
      auth.loginSuccess(userData, appointment);
      // Переходимо на головний екран додатка
      MyApp.navigatorKey.currentState!.pushNamed('main');
    }
  }

// Метод для пошуку призначення лікаря у отриманих даних користувача
  Map<String, dynamic> _findAppointment(Map<String, dynamic> userData) {
    Map<String, dynamic> appointment = {};
    // Шукаємо записи до лікаря у списку лікарів користувача
    for (var doctorData in userData['doctor']) {
      if (doctorData['appointments'] != null) {
        appointment = doctorData;
        break;
      }
    }
    // Повертаємо знайдене призначення
    return appointment;
  }

  // Метод для відображення сповіщення про помилку
  void _showErrorSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
          "Неправильна електронна адреса або пароль. Будь ласка спробуйте ще раз."),
      backgroundColor: EasyMedHelpConfiguration.errorColor,
    ));
  }
}
