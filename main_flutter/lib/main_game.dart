import 'package:flutter/material.dart';
import 'package:main_flutter/cards_list.dart';
import 'package:main_flutter/utils/channel_helper.dart';
import 'app_bar.dart';
import 'utils/navigation_service.dart';

class MainGameApp extends StatefulWidget {
  const MainGameApp({super.key});

  @override
  State<MainGameApp> createState() => _MainGameAppState();
}

class _MainGameAppState extends State<MainGameApp> {
  @override
  void initState() {
    super.initState();
    ch.setMethodCallHandler((call) {
      return MethodChannelHelper.handleMethodCall(
        navigatorKey.currentContext,
        call
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: Scaffold(
        appBar: CustomAppBar(),
        backgroundColor: Colors.grey[100],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(children: [Expanded(child: CardsList())]),
          ),
        ),
      ),
    );
  }
}
