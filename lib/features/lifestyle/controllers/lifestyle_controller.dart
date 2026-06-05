import 'package:flutter/foundation.dart';
import '../../../models/lifestyle_data.dart';

class LifestyleController extends ChangeNotifier {
  String _primaryActivity = 'Mixed / General';
  int _screenTimeHours = 4;
  bool _outdoorActivity = false;
  String _workEnvironment = 'Indoor';

  String get primaryActivity => _primaryActivity;
  int get screenTimeHours => _screenTimeHours;
  bool get outdoorActivity => _outdoorActivity;
  String get workEnvironment => _workEnvironment;

  static const List<String> activityOptions = [
    'Reading / Office Work',
    'Outdoor / Sports',
    'Driving',
    'Night Activities',
    'Mixed / General',
  ];

  static const List<String> environmentOptions = [
    'Indoor',
    'Outdoor',
    'Mixed',
  ];

  void setActivity(String value) {
    _primaryActivity = value;
    notifyListeners();
  }

  void setScreenTime(int hours) {
    _screenTimeHours = hours;
    notifyListeners();
  }

  void setOutdoor(bool value) {
    _outdoorActivity = value;
    notifyListeners();
  }

  void setEnvironment(String value) {
    _workEnvironment = value;
    notifyListeners();
  }

  LifestyleData get data => LifestyleData(
        primaryActivity: _primaryActivity,
        screenTimeHours: _screenTimeHours,
        outdoorActivity: _outdoorActivity,
        workEnvironment: _workEnvironment,
      );
}
