import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataManager<T> extends ValueNotifier<T> {
  final String key;
  final T defaultValue;

  DataManager(this.key, this.defaultValue) : super(defaultValue) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (T == int) {
      value = (prefs.getInt(key) ?? defaultValue) as T;
    } else if (T == double) {
      value = (prefs.getDouble(key) ?? defaultValue) as T;
    } else if (T == bool) {
      value = (prefs.getBool(key) ?? defaultValue) as T;
    } else if (T == String) {
      value = (prefs.getString(key) ?? defaultValue) as T;
    } else {
      throw UnsupportedError('Unsupported type $T');
    }
  }

  Future<void> set(T newValue) async {
    final prefs = await SharedPreferences.getInstance();
    if (newValue is int) {
      await prefs.setInt(key, newValue);
    } else if (newValue is double) {
      await prefs.setDouble(key, newValue);
    } else if (newValue is bool) {
      await prefs.setBool(key, newValue);
    } else if (newValue is String) {
      await prefs.setString(key, newValue);
    } else {
      throw UnsupportedError('Unsupported type $T');
    }
    value = newValue;
  }

  Future<int> increment(String key, {int by = 1, int defaultValue = 0}) async {
    if (T != int) {
      throw UnsupportedError('Increment only supported for int type');
    }
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(key) ?? defaultValue;
    final updated = current + by;
    await prefs.setInt(key, updated);
    value = updated as T;
    return updated;
  }
}

final balanceManager = DataManager<int>('balance', 0);
final tpTokenManager = DataManager<String>(
  'tp_token',
  '4-df1300a9eb0ba6817c03a29d854a0345',
);
