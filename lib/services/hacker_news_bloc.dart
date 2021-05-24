import 'dart:async';
import 'dart:collection';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../services/article.dart';
import '../services/serializers.dart';

const apiPrefix = 'https://hacker-news.firebaseio.com/v0/';
enum StoriesType { topArticles, newArticles }

//.......................................................................................

class HackerNewsBloc {
  List<int> _idsList = [];
  List<Article> _articlesList = [];
  HashMap<int, Article> _cashedArticles;
  int n = 10;

//.......................................................................................

  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();

  Stream<List<Article>> get articles => _articlesSubject.stream;

  final _loadingStateSubject = BehaviorSubject.seeded(false);

  Stream<bool> get loadingState => _loadingStateSubject.stream;

  final _storiesTypeController = StreamController<StoriesType>();

  Sink<StoriesType> get storiesType => _storiesTypeController.sink;

  final _moreArticlesController = StreamController<StoriesType>();

  Sink<StoriesType> get moreArticles => _moreArticlesController.sink;

//.......................................................................................

  close() {
    _articlesSubject.close();
    _loadingStateSubject.close();
    _storiesTypeController.close();
    _moreArticlesController.close();
  }

//.......................................................................................

  HackerNewsBloc() {
    _cashedArticles = HashMap<int, Article>();
    _initialize(StoriesType.topArticles);
    _storiesTypeController.stream.listen((storiesType) {
      _initialize(storiesType);
    });
    _moreArticlesController.stream.listen((storiesType) {
      n += 10;
      _initialize(storiesType);
    });
  }

//.......................................................................................

  void _initialize(storiesType) async {
    _loadingStateSubject.add(true);
    List<Article> _list = await _updateArticles(storiesType);
    _articlesSubject.add(UnmodifiableListView(_list));
    _loadingStateSubject.add(false);
  }

  Future<List<Article>> _updateArticles(StoriesType type) async {

    ///getting list of Articles Ids
    _idsList = await _getArticlesIds(type);

    _articlesList.clear();

    ///adding the new Articles in the Articles list
    for (int id in _idsList) {
      Article _article = await _getArticle(id);
        _articlesList.add(_article);
    }

    ///sorting the Articles list by date
    _articlesList.sort((Article a, Article b) {
      int aDate = a.time;
      int bDate = b.time;
      return bDate.compareTo(aDate);
    });
    return _articlesList;
  }

  Future<List<int>> _getArticlesIds(StoriesType type) async {
    final url = type == StoriesType.topArticles
        ? '${apiPrefix}topstories.json'
        : '${apiPrefix}newstories.json';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<int> list =
          List<int>.from(convert.jsonDecode(response.body)).take(n).toList();
      return list;
    } else {
      throw ("Articles Ids List Request failed with status: ${response.statusCode}.");
    }
  }

  Future<Article> _getArticle(int id) async {
    if (!_cashedArticles.containsKey(id)) {
      final apiItemsUrl =
          'https://hacker-news.firebaseio.com/v0/item/$id.json?print=pretty';
      final response = await http.get(apiItemsUrl);
      if (response.statusCode == 200) {
        var articleData = convert.jsonDecode(response.body);
        _cashedArticles[id] = _deserializeArticle(articleData);
      } else {
        throw ("Article Request failed with status: ${response.statusCode}.");
      }
    }
    return _cashedArticles[id];
  }

  Article _deserializeArticle(var jsonResponse) {
    Article article =
        serializers.deserializeWith(Article.serializer, jsonResponse);
    return article;
  }
}
