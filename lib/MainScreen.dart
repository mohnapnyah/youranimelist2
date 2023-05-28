import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youranimelist/User.dart';
import 'AnimeDetailsScreen.dart';
import 'AnimeTitle.dart';
import 'AnimeCard.dart';
import 'WaitingPage.dart';





class MainScreen extends StatefulWidget {
  
  

 @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
   User? currentUser;


  @override
  Widget build(BuildContext context) {
    Widget singelChild(BuildContext context)
    {
      return SingleChildScrollView(
        child: Container(
        color:  Color(0xFFE0EEFF),
        child: Column(
          children: [
            // Блок "Летний аниме сезон"
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Summer Anime Season',
                style: GoogleFonts.nunito(textStyle:   TextStyle(fontSize: 20.0,  fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              height: 200.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:summerAnimeList.length, // Здесь нужно получить из AnimeTitle
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
                style:  GoogleFonts.nunito(textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              height: 200.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: winterAnimeList.length, // Здесь нужно получить из AnimeTitle
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
                style:  GoogleFonts.nunito(textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              height: 200.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: mangaAnimeList.length, // Здесь нужно получить из AnimeTitle
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
      )
      );
    }
  List<Anime> animeListFav = summerAnimeList ;
   List<Widget> _pages = [
    singelChild(context),
    // MainScreen(),
    WaitingPage(favoriteAnimeList: animeListFav),
  ];
    return Scaffold(
      appBar: AppBar(
        title: Text('YourAnimeList'),
        backgroundColor: Color(0xFF2E51A2),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: Row(
              children: [
                SizedBox(width: 10.0),
                CircleAvatar(
                  // Здесь можете добавить код для отображения аватарки пользователя
                ),
              ],
            ),
          ),
        ],
      ),
      
      // Это блоки сезонов со скролом
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
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_empty),
            label: 'Waiting Titles',
          ),
        ],
      ),
    );
  }
}