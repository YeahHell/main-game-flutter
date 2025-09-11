import 'package:flutter/material.dart';
import 'package:main_flutter/utils/image_button.dart';

class GameCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String buttonImageURL;
  final VoidCallback onGameTap;

  const GameCard({
    super.key,
    required this.onGameTap,
    required this.title,
    required this.icon,
    required this.buttonImageURL,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
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
          ImageButton(imageUrl: buttonImageURL, height: 130, width: double.infinity, onTap: onGameTap),
        ],
      ),
    );
  }
}
