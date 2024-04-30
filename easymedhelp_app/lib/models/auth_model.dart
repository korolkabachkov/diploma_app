import 'dart:convert';

import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  bool _isLogin = false;
  Map<String, dynamic> user = {};
  Map<String, dynamic> appointment = {};
  List<Map<String, dynamic>> favouriteDoctor = [];
  List<dynamic> _favourite = [];

  bool get isLogin {
    return _isLogin;
  }

  List<dynamic> get getFavourite {
    return _favourite;
  }

  Map<String, dynamic> get getUser {
    return user;
  }

  Map<String, dynamic> get getAppointment {
    return appointment;
  }

  void setFavouriteList(List<dynamic> list) {
    _favourite = list;
    notifyListeners();
  }

  void loginSuccess(
      Map<String, dynamic> userData, Map<String, dynamic> appointmentInfo) {
    _isLogin = true;

    _favourite.clear();

    user = userData;
    appointment = appointmentInfo;

    if (user['details'] != null && user['details']['favourite'] != null) {
      _favourite = json.decode(user['details']['favourite']);
    }
    notifyListeners();
  }

  List<Map<String, dynamic>> get getFavouriteDoctor {
    favouriteDoctor.clear();

    for (var num in _favourite) {
      for (var doctor in user['doctor']) {
        if (num == doctor['doctor_id']) {
          favouriteDoctor.add(doctor);
        }
      }
    }
    return favouriteDoctor;
  }
}
