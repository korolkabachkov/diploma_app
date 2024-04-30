import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easymedhelp_app/components/login_form.dart';
import 'package:easymedhelp_app/components/register_form.dart';
import 'package:easymedhelp_app/utils/configuration.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignInMode = true;

  @override
  Widget build(BuildContext context) {
    _initConfiguration(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: EasyMedHelpConfiguration.backgroundColor,
      body: Padding(
        padding: EasyMedHelpConfiguration.paddingMedium,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 64),
              _buildWelcomeText(),
              EasyMedHelpConfiguration.spacingS,
              _buildAuthDescription(),
              EasyMedHelpConfiguration.spacingS,
              _buildAuthIllustration(),
              EasyMedHelpConfiguration.spacingS,
              _isSignInMode ? const LoginForm() : const RegisterForm(),
              EasyMedHelpConfiguration.spacingS,
              _isSignInMode ? _buildForgotPasswordButton() : Container(),
              const Spacer(),
              _buildToggleAuthModeButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _initConfiguration(BuildContext context) {
    EasyMedHelpConfiguration.init(context);
  }

  Widget _buildWelcomeText() {
    return Text(
      'Ласкаво просимо',
      style: EasyMedHelpConfiguration.textTheme.displayLarge,
    );
  }

  Widget _buildAuthDescription() {
    return Text(
      _isSignInMode
          ? 'Увійдіть у свій аккаунт'
          : 'Зареєструйтеся для того, щоб отримати доступ до запису до лікарів',
      style: EasyMedHelpConfiguration.textTheme.bodyLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAuthIllustration() {
    return SvgPicture.asset(
      'assets/doctor_auth.svg',
      height: 200.0,
      fit: BoxFit.contain,
    );
  }

  Widget _buildForgotPasswordButton() {
    return Center(
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Забули пароль?',
          style: EasyMedHelpConfiguration.textTheme.bodyLarge!.copyWith(
            color: EasyMedHelpConfiguration.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildToggleAuthModeButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          _isSignInMode ? 'Не маєте аккаунту?' : 'Вже зареєстровані?',
          style: EasyMedHelpConfiguration.textTheme.bodyLarge
              ?.copyWith(color: const Color.fromARGB(255, 150, 150, 150)),
        ),
        TextButton(
          onPressed: _toggleAuthMode,
          child: Text(
            _isSignInMode ? 'Зареєструватися' : 'Увійти',
            style: EasyMedHelpConfiguration.textTheme.bodyLarge!.copyWith(
              color: EasyMedHelpConfiguration.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  void _toggleAuthMode() {
    setState(() {
      _isSignInMode = !_isSignInMode;
    });
  }
}
