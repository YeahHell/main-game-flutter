import 'package:flutter/material.dart';
import 'data/game_preview_model.dart';
import 'game_card.dart';
import 'game_processor.dart';
import 'dialogs/deposit_dialog.dart';

class CardsList extends StatefulWidget {
  const CardsList({super.key});

  @override
  State<CardsList> createState() => _CardsListState();
}

class _CardsListState extends State<CardsList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...games.map(
          (game) => Column(
            children: [
              GameCard(
                onGameTap: () => game.type == GameType.sb ? openSB() : openGame(game.id),
                title: game.name,
                icon: game.icon,
                buttonImageURL: game.imageUrl,
              ),
              SizedBox(height: 30),
            ],
          ),
        ),

        // Test button for deposit (có thể xóa trong production)
        TextButton.icon(
          onPressed: () => showDepositDialog(null),
          icon: Icon(Icons.account_balance_wallet, color: Colors.grey),
          label: Text(
            'Test Deposit Dialog',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
