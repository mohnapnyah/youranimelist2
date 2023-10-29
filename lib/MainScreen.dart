import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'AnimeDetailsScreen.dart';
import 'AnimeTitle.dart';
import 'AnimeCard.dart';
import 'WaitingPage.dart';
import 'Profile.dart';





class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget singleChild(BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 255, 195, 214), // Обновленный фоновый цвет
          child: Column(
            children: [
              // Блок "Летний аниме сезон"
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Summer Anime Season',
                  style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 132, 20, 45), // Цвет сакуры
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                height: 200.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: summerAnimeList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnimeDetailScreen(animeTitle: summerAnimeList[index].title),
                          ),
                        );
                      },
                      child: AnimeCard(
                        anime: summerAnimeList[index],
                      ),
                    );
                  },
                ),
              ),
              // Блок "Зимний аниме сезон"
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Winter Anime Season',
                  style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 132, 20, 45), // Цвет сакуры
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                height: 200.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: winterAnimeList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnimeDetailScreen(animeTitle: winterAnimeList[index].title),
                          ),
                        );
                      },
                      child: AnimeCard(
                        anime: winterAnimeList[index],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Manga',
                  style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 132, 20, 45), // Мятный цвет
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                height: 200.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: mangaAnimeList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnimeDetailScreen(animeTitle: mangaAnimeList[index].title),
                          ),
                        );
                      },
                      child: AnimeCard(
                        anime: mangaAnimeList[index],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    List<Widget> _pages = [
      singleChild(context),
      WaitingPage(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: _pages.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color.fromARGB(255, 145, 248, 219)), // Мятная икона
            label: 'Main page',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_empty, color: Color.fromARGB(255, 145, 248, 219)), // Мятная икона
            label: 'Waiting Titles',
          ),
          BottomNavigationBarItem(
      icon: Icon(Icons.person, color: Color.fromARGB(255, 145, 248, 219)), // Иконка человечка
      label: 'Профиль', // Или 'User' или что угодно другое
    ),
        ],
      ),
    );
  }
}