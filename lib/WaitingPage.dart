import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'AnimeTitle.dart';
import 'AnimeDetailsScreen.dart';

 class WaitingPage extends StatefulWidget {
  @override
  _WaitingPageState createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 255, 195, 214),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .collection('favoriteAnime')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error occurred'),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No favorite anime'),
              );
            }

            final favoriteAnimeList = snapshot.data!.docs.map((doc) {
              final animeData = doc.data() as Map<String, dynamic>;
              return Anime(
                title: animeData['title'],
                posterUrl: animeData['posterUrl'],
                description: animeData['description'],
              );
            }).toList();

            return GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: favoriteAnimeList.length,
              itemBuilder: (context, index) {
                final anime = favoriteAnimeList[index];
                final isFavorite = true; // Check if anime is in favoriteAnime list

                return GridTile(
                  child: GestureDetector(
                    onTap: () {
                      // Перейти на страницу AnimeDetailsScreen при нажатии на карточку аниме
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnimeDetailScreen(animeTitle: anime.title),
                        ),
                      );
                    },
                    child: Image.asset(
                      anime.posterUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  footer: GridTileBar(
                    backgroundColor: Colors.black45,
                    title: Text(
                      anime.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 132, 20, 45), // Цвет текста
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.star : Icons.star_border,
                        color: Colors.yellow,
                      ),
                      onPressed: () {
                        // Обработчик нажатия на звезду
                        if (isFavorite) {
                          _removeFromFavorites(anime.title);
                        } else {
                          // Добавить аниме в список favoriteAnime
                        }
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _removeFromFavorites(String title) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final favoriteAnimeRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favoriteAnime');

      await favoriteAnimeRef.doc(title).delete();
    }
  }
}