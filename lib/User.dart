import 'package:youranimelist/AnimeTitle.dart';

class User {
  String username;
  String password;
  List<Anime>? favoriteAnimeList;

  User({required this.username, required this.password, required this.favoriteAnimeList, });

  void addFavoriteAnime(Anime anime) {
    favoriteAnimeList?.add(anime);
  }

  void removeFavoriteAnime(Anime anime) {
    favoriteAnimeList?.remove(anime);
  }
}