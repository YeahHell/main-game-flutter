import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainGameApp extends StatefulWidget {
  const MainGameApp({super.key});
  @override
  State<MainGameApp> createState() => _MainGameAppState();
}

class _MainGameAppState extends State<MainGameApp> {
  static const _ch = MethodChannel('ksport_minigame');

  @override
  void initState() {
    super.initState();
    _ch.setMethodCallHandler((call) async {
      if (call.method == 'gameClosed') {

      }
    });
  }

  Future<void> _openSB() async {
    await _ch.invokeMethod('presentGame', {
      'tpToken': '4-f42adc1066763601e3dcd82a925cfa5c',
      'agentId': '4',
      'meta': {
        'uid': 'k_sports_ksport',
        'environment': 'production',
        'apiBaseUrl': 'https://apps-gateway.preprod.nana.codes',
        'sbBaseUrl': 'https://gali.sb21.net',
        'apiVersion': 'v2',
        'wssSbBaseUrl': 'wss://anten.sb21.net',
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Main Game 🎮')),
        body: Center(
          child: ElevatedButton(
            onPressed: _openSB,
            child: const Text('Open SB'),
          ),
        ),
      ),
    );
  }
}