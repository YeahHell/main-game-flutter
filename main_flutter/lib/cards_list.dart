import 'package:flutter/material.dart';
import 'package:main_flutter/utils/image_button.dart';
import 'package:main_flutter/utils/search_bar_widget.dart';
import 'data/game_preview_model.dart';
import 'game_processor.dart';

class CardsList extends StatefulWidget {
  const CardsList({super.key});

  @override
  State<CardsList> createState() => _CardsListState();
}

class _CardsListState extends State<CardsList> {
  String query = ''; // holds the search text
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter games based on search text
    final filteredGames = games.where((game) {
      return game.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return Column(
      children: [
        // 🔎 Search bar
        SearchBarWidget(
          controller: _controller,
          onChanged: (value) {
            setState(() => query = value);
          },
          onClear: () {
            setState(() => query = '');
          },
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: GridView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: filteredGames.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8, // horizontal spacing
                mainAxisSpacing: 8, // vertical spacing
                childAspectRatio: 1.25,
              ),
              itemBuilder: (context, index) {
                final game = filteredGames[index];
                return ImageButton(
                  imageUrl: game.imageUrl,
                  height: 150,
                  width: double.infinity,
                  onTap: () =>
                      game.type == GameType.sb ? openSB() : openGame(game.id),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
