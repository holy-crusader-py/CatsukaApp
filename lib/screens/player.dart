import 'package:flutter/material.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;

class Tag {
  final String name;
  String link;

  Tag(this.name, this.link) {
    link = "https://www.catsuka.com/$link";
  }
}

class Player extends StatelessWidget {
  const Player({super.key});

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
        future: getVideo(link, date));
  }

  Future<Widget> getVideo(String link, dynamic date) async {
    var client = Client();
    Response response = await client.get(Uri.parse(link));

    if (response.statusCode != 200) {
      return const Text("Error", style: TextStyle(color: Colors.red));
    }

    dom.Element document = parse(response.body, generateSpans: true)
        .body!
        .getElementsByTagName("main")[0];

    dom.Element videoWrapper = document.querySelectorAll('.videoWrapper').first;
    dom.Element videosInfos = document.querySelectorAll('.videosinfos').first;

    // Title
    String title =
        videosInfos.querySelector('.videosinfos_left > span.txtblanc25')!.text;

    // Details
    Widget detailsWidget = HtmlWidget(
      videosInfos
          .querySelector(
            '.videosinfos_left > div > div > span.txtblanc14',
          )!
          .outerHtml
          .split("<br>Video")[0],
      customStylesBuilder: (element) {
        if (element.parent?.className == 'txtorange17') {
          return {'color': '#e04a25', 'font-size': '16px'};
        }
        return {'font-size': '16px'};
      },
    );

    // // Tags
    // late List<Tag> tags = [];
    // videosInfos.querySelectorAll('div.videosinfos_left > a').forEach((e) {
    //   tags.add(Tag(e.querySelector("u")!.text, e.attributes['href']!));
    // });

    List<Widget> tagsWidget = [];

    // for (Tag tag in tags) {
    //   tagsWidget.add(
    //     GestureDetector(
    //       onTap: () async {
    //         _launchUrl(tag.link);
    //       },
    //       child: Container(
    //         padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
    //         decoration: BoxDecoration(
    //           color: const Color(0xFF122E39),
    //           borderRadius: BorderRadius.circular(5),
    //         ),
    //         child: Text(
    //           tag.name,
    //           style: const TextStyle(
    //             fontSize: 12,
    //             fontWeight: FontWeight.w700,
    //             fontFamily: "Exo 2",
    //             color: Colors.white,
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    // }

    return ListView(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(top: 100),
      children: [
        const SizedBox(height: 25),
        Center(
          child: HtmlWidget(
            videoWrapper.outerHtml,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
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
                date,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Exo 2",
                  color: Color(0xFF122E39),
                ),
              ),
              const SizedBox(height: 10),
              detailsWidget,
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tags :",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Exo 2",
                      color: Color(0xffe04a25),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: Wrap(
                        spacing: 5.0,
                        runSpacing: 5.0,
                        children: tagsWidget,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}
