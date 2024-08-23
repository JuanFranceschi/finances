import 'package:finances/utils/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  final String periodKey = 'defaultPeriod';
  final String visibleKey = 'defaultVisibility';
  late final SharedPreferences prefs;

  setup() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool get getVisibility {
    return prefs.getBool(visibleKey) ?? false;
  }

  setDefaultVisibility(bool defaultVisibility) async {
    await prefs.setBool(visibleKey, defaultVisibility);
  }

  Period get getDefaultPeriod {
    return Period.values.firstWhere(
        (obj) => obj.toString() == (prefs.getString(periodKey) ?? Period.monthly.toString()));
  }

  setDefaultPeriod(Period period) async {
    await prefs.setString(periodKey, period.toString());
  }
}
