import 'package:flutter/material.dart';
import 'package:main_flutter/utils/image_button.dart';

import 'game_processor.dart';

class GameCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String buttonImageURL;
  final VoidCallback onGameTap;


  const GameCard({
    Key? key,
    required this.onGameTap,
    required this.title,
    required this.icon,
    required this.buttonImageURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
        padding: EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 80, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 10),
            ImageButton(
                imageUrl: buttonImageURL,
                onTap: () => openGame('mega645', 0))
          ],
        ),
      );
  }

}

