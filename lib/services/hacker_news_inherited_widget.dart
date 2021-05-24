import 'package:flutter/material.dart';

import '../services/hacker_news_bloc.dart';

class HackerNewsInheritedWidget extends InheritedWidget {
  final HackerNewsBloc bloc;

  HackerNewsInheritedWidget(
      {Key key, @required this.bloc, @required Widget child})
      : super(key: key, child: child);

  static HackerNewsInheritedWidget of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType(aspect: HackerNewsInheritedWidget);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
