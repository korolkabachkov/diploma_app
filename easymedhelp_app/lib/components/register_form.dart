import 'dart:convert';

import 'package:easymedhelp_app/components/button.dart';
import 'package:easymedhelp_app/models/auth_model.dart';
import 'package:easymedhelp_app/providers/dio_provider.dart';
import 'package:easymedhelp_app/utils/configuration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easymedhelp_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildFormField(_nameController, TextInputType.text,
                'Прізвище та ім\'я', Icons.person_outlined),
            EasyMedHelpConfiguration.spacingS,
            _buildFormField(_emailController, TextInputType.emailAddress,
                'Електронна адреса', Icons.email_outlined),
            EasyMedHelpConfiguration.spacingS,
            _buildPasswordField(),
            EasyMedHelpConfiguration.spacingS,
            _buildRegisterButton(),
            const SizedBox(height: 16), // Add some space at the bottom
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(TextEditingController controller,
      TextInputType keyboardType, String hintText, IconData icon) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: EasyMedHelpConfiguration.primaryColor,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: EasyMedHelpConfiguration.outlinedBorder,
        hintText: hintText,
        prefixIcon: Icon(icon),
        prefixIconColor: EasyMedHelpConfiguration.primaryColor,
      ),
      style: EasyMedHelpConfiguration.textTheme.bodyLarge,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Це поле обов\'язкове для заповнення';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      cursorColor: EasyMedHelpConfiguration.primaryColor,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: EasyMedHelpConfiguration.outlinedBorder,
        hintText: 'Пароль',
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
          icon: obscurePassword
              ? const Icon(
                  Icons.visibility_off_outlined,
                  color: Colors.black38,
                )
              : const Icon(
                  Icons.visibility_outlined,
                  color: EasyMedHelpConfiguration.primaryColor,
                ),
        ),
        prefixIcon: const Icon(Icons.lock_outline),
        prefixIconColor: EasyMedHelpConfiguration.primaryColor,
      ),
      obscureText: obscurePassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Це поле обов\'язкове для заповнення';
        }
        if (value.length < 6) {
          return 'Пароль повинен містити принаймні 6 символів';
        }
        return null;
      },
    );
  }

  Widget _buildRegisterButton() {
    return Consumer<AuthModel>(builder: (context, auth, child) {
      return Button(
        width: double.infinity,
        title: 'Зареєструватися',
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final registrationResult = await DioProvider().registerUser(
                _nameController.text,
                _emailController.text,
                _passwordController.text);
            if (registrationResult != null) {
              final token = await DioProvider()
                  .getToken(_emailController.text, _passwordController.text);
              if (token != null) {
                final prefs = await SharedPreferences.getInstance();
                final tokenValue = prefs.getString('token');
                if (tokenValue != null && tokenValue.isNotEmpty) {
                  final response = await DioProvider().getUser(tokenValue);
                  if (response != null) {
                    _handleLogin(response, auth);
                  }
                }
              }
            }
          }
        },
        disabled: false,
      );
    });
  }

  Future<void> _handleLogin(String response, AuthModel auth) async {
    setState(() {
      Map<String, dynamic> appointment = {};
      final user = json.decode(response);

      for (var doctorData in user['doctor']) {
        if (doctorData['appointments'] != null) {
          appointment = doctorData;
        }
      }
      auth.loginSuccess(user, appointment);
      MyApp.navigatorKey.currentState!.pushNamed('main');
    });
  }
}
