import 'package:catsuka/api/short.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../components/read_on_website_button.dart';
import '../utils/tools.dart';

class Breve extends StatelessWidget {
  const Breve({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> arguments =
        ModalRoute.of(context)!.settings.arguments as List<String>;
    final link = arguments[0];
    final date = arguments[1];

    return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: snapshot.data,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xffe04a25),
              ),
            );
          }
        },
        future: getNews(link, date));
  }

  Future<Widget> getNews(String link, dynamic date) async {
    BreveObject breve = await fetchBreve(link);
    List<Widget> breveWidget = [];

    for (var item in breve.content) {
      if (item.contains('blockquote')) {
        continue;
      } else if (item.contains('<b>English audience</b>')) {
        break;
      } else if (item.contains('Catsuka on Twitter')) {
        break;
      }

      if (item.trim().isNotEmpty) {
        breveWidget.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: HtmlWidget(
              "${item.trim()}\n",
              customStylesBuilder: (element) {
                if (element.localName == 'a') {
                  return {'color': '#e04a25', 'text-decoration': 'none'};
                }
                return null;
              },
              onTapUrl: (url) {
                UrlLauncher.launch(url);
                return true;
              },
              textStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      }
    }

    breveWidget.add(ReadOnWebsiteButton(link: link,));

    return ListView(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(top: 100),
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                breve.title,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Exo 2",
                  color: Color(0xFF122E39),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Image.network(width: double.infinity, breve.imageUrl),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: Column(
            children: breveWidget,
          ),
        ),
        // testHtml
      ],
    );
  }
}