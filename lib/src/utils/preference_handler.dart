import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  // make this a singleton class
  PreferenceHandler._privateConstructor();

  static final PreferenceHandler instance =
      PreferenceHandler._privateConstructor();

  // only have a single app-wide reference to the SharedPreference
  static SharedPreferences _prefs;

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) return _prefs;
    // lazily instantiate the db the first time it is accessed
    _prefs = await _initPreference();
    return _prefs;
  }

  // this opens the SharedPreference (and creates it if it doesn't exist)
  _initPreference() async {
    return await SharedPreferences.getInstance();
  }

  Future<String> getString(String key) async {
    SharedPreferences prefs = await instance.prefs;
    String prefValue = prefs.getString(key) ?? "";
    return prefValue;
  }

  setString(String key, String value) async {
    SharedPreferences prefs = await instance.prefs;
    prefs.setString(key, value);
  }

  Future<int> getInt(String key) async {
    SharedPreferences prefs = await instance.prefs;
    int prefValue = prefs.getInt(key) ?? 0;
    return prefValue;
  }

  setInt(String key, int value) async {
    SharedPreferences prefs = await instance.prefs;
    prefs.setInt(key, value);
  }

  Future<bool> getBool(String key) async {
    SharedPreferences prefs = await instance.prefs;
    bool prefValue = prefs.getBool(key) ?? false;
    return prefValue;
  }

  setBool(String key, bool value) async {
    SharedPreferences prefs = await instance.prefs;
    prefs.setBool(key, value);
  }

  Future<double> getDouble(String key) async {
    SharedPreferences prefs = await instance.prefs;
    double prefValue = prefs.getDouble(key) ?? 0.0;
    return prefValue;
  }

  setDouble(String key, double value) async {
    SharedPreferences prefs = await instance.prefs;
    prefs.setDouble(key, value);
  }

  Future<bool> clearPreference() async {
    SharedPreferences prefs = await instance.prefs;
    return await prefs.clear();
  }
}
