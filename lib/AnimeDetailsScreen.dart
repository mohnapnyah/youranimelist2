import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'AnimeTitle.dart';
import 'package:video_player/video_player.dart';
 
class AnimeDetailScreen extends StatefulWidget {
  final String animeTitle;

  AnimeDetailScreen({required this.animeTitle});

  @override
  _AnimeDetailScreenState createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends State<AnimeDetailScreen> {
  bool isFavorite = false;
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset(
      'assets/stas.mp4',
    );
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE0EEFF),
        title: Text('Anime Details'),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: Colors.yellow,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
              _toggleFavorite();
            },
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFE0EEFF),
        child: SingleChildScrollView(
          child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('Anime')
                .where('title', isEqualTo: widget.animeTitle)
                .get(),
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
                  child: Text('Anime not found'),
                );
              }

              final animeData =
                  snapshot.data!.docs[0].data() as Map<String, dynamic>;
              final anime = Anime(
                title: animeData['title'],
                posterUrl: animeData['posterUrl'],
                description: animeData['description'],
              );

              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        anime.posterUrl,
                        fit: BoxFit.cover,
                        width: 200.0,
                        height: 300.0,
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
                    SizedBox(height: 16.0),
                    Text(
                      'Trailer',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito',
                      ),
                    ),
                    SizedBox(height: 8.0),
                    FutureBuilder<void>(
                      future: _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return AspectRatio(
                            aspectRatio: _videoPlayerController.value.aspectRatio,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                VideoPlayer(_videoPlayerController),
                                IconButton(
                                  icon: Icon(
                                    _videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (_videoPlayerController.value.isPlaying) {
                                        _videoPlayerController.pause();
                                      } else {
                                        _videoPlayerController.play();
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final favoriteAnimeRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favoriteAnime');

      if (isFavorite) {
        final animeData =
            await _getAnimeData(widget.animeTitle); // Get anime data from Firestore

        await favoriteAnimeRef.doc(widget.animeTitle).set(animeData);
      } else {
        await favoriteAnimeRef.doc(widget.animeTitle).delete();
      }
    }
  }

  Future<Map<String, dynamic>> _getAnimeData(String title) async {
    final animeSnapshot = await FirebaseFirestore.instance
        .collection('Anime')
        .where('title', isEqualTo: title)
        .get();

    final animeData =
        animeSnapshot.docs.first.data() as Map<String, dynamic>;

    return animeData;
  }
}