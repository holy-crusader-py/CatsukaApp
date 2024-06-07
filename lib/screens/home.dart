import 'package:flutter/material.dart';
import 'package:file/file.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:xml2json/xml2json.dart';
import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:jiffy/jiffy.dart';

import '../components/short.dart';
import '../components/news.dart';
import '../components/update_dialog.dart';
import '../utils/update_manager.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  late Future<List<Widget>> futureNews;
  late Future<bool> update;

  @override
  void initState() {
    super.initState();
    futureNews = getNews();
    update = checkForUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: update,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        update.then((result) {
          if (result) Overlay.of(context).insert(updateDialog());
        });

        return FutureBuilder<List<Widget>>(
          future: futureNews,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return RefreshIndicator(
              onRefresh: () async {
                List<Widget> freshNews = await getNews(reload: true);
                setState(() {
                  futureNews = Future.value(freshNews);
                });
              },
              edgeOffset: 100,
              color: const Color(0xffe04a25),
              backgroundColor: const Color(0xFF122E39),
              child: _listView(context, snapshot),
            );
          },
        );
      }
    );
  }

  Widget _listView(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.only(top: 100),
          children: snapshot.data,
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xffe04a25),
        ),
      );
    }
  }

  Future<List<Widget>> getNews({bool reload = false}) async {
    List<Widget> news = [];
    Uri uri = Uri.parse('https://feeds.feedburner.com/catsuka-news');

    if (reload) {
      DefaultCacheManager().removeFile(uri.toString());
    }

    File cacheFile = await DefaultCacheManager().getSingleFile(uri.toString());

    if (!cacheFile.existsSync()) {
      return [
        const Padding(
          padding: EdgeInsets.only(top: 50),
          child: Center(
            child: Text(
              "Sorry, we failed to load news...",
              style: TextStyle(
                color: Color(0xffe04a25),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ];
    }
    final transformer = Xml2Json();

    transformer.parse(await cacheFile.openRead().bytesToString());
    var data = jsonDecode(transformer.toOpenRally())["rss"]["channel"]["item"];

    const start = '<img src=\\"';
    const end = '\\"';

    for (var item in data) {
      final str = item['description'];
      final startIndex = str.indexOf(start);
      final endIndex = str.indexOf(end, startIndex + start.length);

      await Jiffy.setLocale('en');
      final jiffy = Jiffy.parse(
        item["pubDate"].substring(5, 25),
        pattern: 'dd MMM yyyy hh:mm:ss',
      );

      await Jiffy.setLocale('fr');
      String date = jiffy.format(pattern: 'EEEE, dd MMMM HH[h]mm');
      date = date[0].toUpperCase() + date.substring(1);

      if (item["title"].indexOf('(Brève)') == -1) {
        news.add(
          NewsWidget(
            title: item["title"],
            description: item["description"],
            imageUrl: str.substring(startIndex + start.length, endIndex).trim(),
            date: date,
            link: item["link"],
          ),
        );
      } else {
        news.add(
          ShortWidget(
            title: item["title"].replaceAll('(Brève)', '').trim(),
            imageUrl: str.substring(startIndex + start.length, endIndex).trim(),
            date: date,
            link: item["link"],
          ),
        );
      }
    }
    news.add(
      Center(
        child: Container(
          width: 350 * 0.5,
          height: 593 * 0.5,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Image.asset("assets/images/capsuka_news.png"),
        ),
      ),
    );

    return news;
  }
}
