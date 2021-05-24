import 'package:flutter/material.dart';

import './screens/home_screen.dart';
import './services/hacker_news_bloc.dart';
import './services/hacker_news_inherited_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker News',
      theme: ThemeData(
        primaryColor: Color(0xff22272C),
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: HackerNewsInheritedWidget(
        child: HomeScreen(),
        bloc: HackerNewsBloc(),
      ),
    );
  }
}
