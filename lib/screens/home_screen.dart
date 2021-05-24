import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../compnents/build_item.dart';
import '../compnents/loading.dart';
import '../compnents/splash.dart';
import '../services/article.dart';
import '../services/hacker_news_bloc.dart';
import '../services/hacker_news_inherited_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.hackerNewsSquare,
              color: Colors.black,
            ),
            SizedBox(width: 5),
            Text(
              'Hacker News',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<UnmodifiableListView<Article>>(
          stream: HackerNewsInheritedWidget.of(context).bloc.articles,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Loading(
                loading:
                    HackerNewsInheritedWidget.of(context).bloc.loadingState,
                child: ListView.builder(
                  itemCount: snapshot.data.length + 1,
                  itemBuilder: (context, ind) {
                    if (ind == snapshot.data.length) {
                      return Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.all(8),
                        child: RaisedButton(
                          color: Colors.white,
                          padding: EdgeInsets.all(12),
                          onPressed: () {
                              _moreArticles();
                          },
                          child: Text(
                            "View More Articles",
                            style: TextStyle(

                            ),
                          ),
                        ),
                      );
                    } else {
                      return buildItem(snapshot.data[ind]);
                    }
                  },
                ),
              );
            } else {
              return Splash();
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 12,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.rssSquare), title: Text('Top News')),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.bullhorn),
              title: Text('Recent News')),
        ],
        currentIndex: _index,
        onTap: (ind) {
          setState(() {
            _index = ind;
          });
          if (ind == 0) {
            HackerNewsInheritedWidget.of(context)
                .bloc
                .storiesType
                .add(StoriesType.topArticles);
          } else {
            HackerNewsInheritedWidget.of(context)
                .bloc
                .storiesType
                .add(StoriesType.newArticles);
          }
        },
      ),
    );
  }

  void _moreArticles() {
    HackerNewsInheritedWidget.of(context).bloc.moreArticles.add(_index == 0 ? StoriesType.topArticles : StoriesType.newArticles);
  }
}
