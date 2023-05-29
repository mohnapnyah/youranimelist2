import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'AnimeTitle.dart';

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
        color: Color(0xFFE0EEFF),
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
                return GridTile(
                  child: Image.asset(
                    anime.posterUrl,
                    fit: BoxFit.cover,
                  ),
                  footer: GridTileBar(
                    backgroundColor: Colors.black45,
                    title: Text(
                      anime.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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
}