import 'package:flutter/material.dart';
import 'AnimeTitle.dart';

// Это карточка аниме, она будет в прокручиваемом списке и содержит в себе аниме
class AnimeCard extends StatelessWidget {
  final Anime anime;

  AnimeCard({required this.anime});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      margin: EdgeInsets.only(right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150.0,
            child:  Image.asset(anime.posterUrl),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          SizedBox(height: 10.0),
          Text(
            anime.title,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}