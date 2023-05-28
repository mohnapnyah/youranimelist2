import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'AnimeTitle.dart';
 
class AnimeDetailScreen extends StatelessWidget {
  final String animeTitle;


  AnimeDetailScreen({required this.animeTitle});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('Anime')
          .where('title', isEqualTo: animeTitle)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Anime Details'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Anime Details'),
            ),
            body: Center(
              child: Text('Error occurred'),
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Anime Details'),
            ),
            body: Center(
              child: Text('Anime not found'),
            ),
          );
        }

        final animeData = snapshot.data!.docs[0].data() as Map<String, dynamic>;
        final anime =  Anime(
          title: animeData['title'],
          posterUrl: animeData['posterUrl'],
          description: animeData['description'],
        );

        return Scaffold(
          appBar: AppBar(
            title: Text('Anime Details'),
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Image.asset(
                      anime.posterUrl,
                      fit: BoxFit.cover,
                      width: 200.0,
                      height: 300.0,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  anime.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  anime.description,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Nunito',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}