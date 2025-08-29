import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  SharedPrefsHelper._();

  static final instance = SharedPrefsHelper._();

  Future<void> write(String key, Object value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else {
      throw UnsupportedError("Unsupported type");
    }
  }

  Future<T> read<T>(String key, {required T defaultValue}) async {
    final prefs = await SharedPreferences.getInstance();

    if (T == int) {
      return (prefs.getInt(key) ?? defaultValue) as T;
    } else if (T == double) {
      return (prefs.getDouble(key) ?? defaultValue) as T;
    } else if (T == bool) {
      return (prefs.getBool(key) ?? defaultValue) as T;
    } else if (T == String) {
      return (prefs.getString(key) ?? defaultValue) as T;
    } else {
      throw UnsupportedError("Unsupported type");
    }
  }

  Future<int> increment(String key, {int by = 1, int defaultValue = 0}) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(key) ?? defaultValue;
    final updated = current + by;
    await prefs.setInt(key, updated);
    return updated;
  }
}
