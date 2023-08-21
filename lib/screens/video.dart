import 'dart:convert';

import 'package:file/file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:jiffy/jiffy.dart';
import 'package:xml2json/xml2json.dart';

import '../components/video.dart';

class Video extends StatefulWidget {
  const Video({super.key});

  @override
  State<Video> createState() => _Video();
}

class _Video extends State<Video> {
  late Future<List<Widget>> futureVideos;

  @override
  void initState() {
    super.initState();
    futureVideos = getVideos();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future: futureVideos,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return RefreshIndicator(
          onRefresh: () async {
            List<Widget> freshVideos = await getVideos(reload: true);
            setState(() {
              futureVideos = Future.value(freshVideos);
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

  Widget _listView(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.only(top: 125),
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

  Future<List<Widget>> getVideos({bool reload = false}) async {
    List<Widget> videos = [];
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

      final String imageUrl =
          str.substring(startIndex + start.length, endIndex).trim();

      videos.add(
        VideoWidget(
          title: item["title"],
          link: item["link"],
          author: item["author"],
          date: date,
          imageUrl: imageUrl,
        ),
      );
    }

    videos.add(
      Center(
        child: Container(
          width: 400 * 0.5,
          height: 463 * 0.5,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Image.asset("assets/images/capsuka_video.png"),
        ),
      ),
    );

    return videos;
  }
}
