import 'package:shared_preferences/shared_preferences.dart';

void saveRadiusValue(int radius) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('radius', radius);
  }

Future<int> getRadiusValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int radius = prefs.getInt('radius') ?? 3;
    return radius;
}