import 'package:flutter/material.dart';
import 'package:main_flutter/data/local_data_manager.dart';
import 'main_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsHelper.instance.read('balance', defaultValue: 0);
  runApp(const MainGameApp());
}
