import 'package:flutter/material.dart';

class UsersController with ChangeNotifier {
  bool _paymentStatus = false;

  bool get paymentStatus => _paymentStatus;

  set paymentStatus(bool value) {
    _paymentStatus = value;
    notifyListeners();
  }

  double _mealsPerDay = 3.0;

  double get mealsPerDay => _mealsPerDay;

  set mealsPerDay(double value) {
    _mealsPerDay = value;
    notifyListeners();
  }

  double _weightGoal = 0.5;

  double get weightGoal => _weightGoal;

  set weightGoal(double value) {
    _weightGoal = value;
    notifyListeners();
  }

  String _type = '';

  String get type => _type;

  set type(String value) {
    _type = value;
    notifyListeners();
  }

  String _amount = '';

  String get amount => _amount;

  set amount(String value) {
    _amount = value;
    notifyListeners();
  }
}
