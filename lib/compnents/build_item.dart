import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/article.dart';

Widget buildItem(Article _article) {
  var _format = DateFormat("dd.MM.yyyy ' at ' hh:mm aaa");
  var _d = DateTime.fromMillisecondsSinceEpoch(_article.time * 1000);
  var _date = _format.format(_d);

  var _dd = DateTime.now().difference(_d);
  String timeAgo() {
    if (_dd.inHours > 24) {
      return "${_dd.inDays == 1 ? '1 day ago' : '${_dd.inDays} days ago'}";
    }
    if (_dd.inMinutes > 60) {
      return "${_dd.inHours == 1 ? '1 hr ago' : '${_dd.inHours} hrs ago'}";
    }
    if (_dd.inSeconds > 60) {
      return "${_dd.inMinutes == 1 ? '1 min ago' : '${_dd.inMinutes} mins ago'}";
    } else {
      return _date.toString();
    }
  }

  return Card(
    margin: EdgeInsets.all(8),
    child: ExpansionTile(
      key: PageStorageKey<String>(_article.title),

      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          _article.title,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "${timeAgo()}",
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
        ),
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _article.by,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              ),
            ),
            SizedBox(width: 20),
            _article.url != null
                ? IconButton(
                    icon: Icon(Icons.launch),
                    onPressed: () => _launchUrl(_article.url),
                  )
                : Container(),
          ],
        ),
      ],
    ),
  );
}

_launchUrl(url) async {
  if (await canLaunch(url)) {
    await launch(url, forceWebView: true, enableJavaScript: true);
  } else {
    throw 'Couldn\'t launch $url';
  }
}
