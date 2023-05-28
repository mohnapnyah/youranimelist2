import 'package:flutter/material.dart';
import 'AnimeTitle.dart';
import 'AnimeCard.dart';

class WaitingPage extends StatelessWidget {
  final List<Anime> favoriteAnimeList; // Список избранных аниме

  WaitingPage({required this.favoriteAnimeList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waiting Titles'),
        backgroundColor: Color(0xFF2E51A2),
      ),
      body: ListView.builder(
        itemCount: favoriteAnimeList.length,
        itemBuilder: (context, index) {
          // Создаем аниме-карточку для каждого элемента списка
          return AnimeCard(
            anime: favoriteAnimeList[index],
          );
        },
      ),
    );
  }
}
