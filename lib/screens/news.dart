import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;

class News extends StatelessWidget {
  const News({super.key});

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
    var client = Client();
    Response response = await client.get(Uri.parse(link));

    if (response.statusCode != 200) {
      return const Text("Error", style: TextStyle(color: Colors.red));
    }

    var document = parse(response.body);

    dom.Element content = document.querySelectorAll('div.zoneintro')[0];
    String title = content.querySelector('div.newsinfos_desktop > a > b')!.text;
    String subtitle =
        content.querySelector('div.newsinfos_desktop > span.txtnoir17')!.text;

    String imageUrl =
        "https://www.catsuka.com/${content.querySelector('div > div.newsheaddroite > img')!.attributes['src']!.replaceAll('vignettes_news/', 'vignettes_news/big/')}";

    dom.Element newsContainer =
        content.getElementsByClassName("txtnoir14").first;
    List<Widget> newsWidget = [];

    // Widget testHtml = Html(
    //   data: newsContainer.innerHtml,
    // );

    for (var item in newsContainer.innerHtml.split('<br>')) {
      if (item.contains('blockquote')) {
        continue;
      } else if (item.contains('<b>English audience</b>')) {
        break;
      }

      if (item.trim().isNotEmpty) {
        newsWidget.add(
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
                _launchUrl(url);
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

    newsWidget.add(TextButton(
      onPressed: () {
        _launchUrl(link);
      },
      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Color(0xFF122E39)),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 7,
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            "assets/images/forward_triangle.svg",
          ),
          const SizedBox(width: 10),
          const Text(
            "Lire sur le site",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              fontFamily: "Exo 2",
              color: Color(0xFFFFFFFF),
            ),
          ),
        ],
      ),
    ));

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
                title,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
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
          child: Image.network(width: double.infinity, imageUrl),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: Column(
            children: newsWidget,
          ),
        ),
        // testHtml
      ],
    );
  }
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}
