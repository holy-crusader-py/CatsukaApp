import 'package:flutter/material.dart';

import 'package:html_unescape/html_unescape.dart';
import 'package:get/get.dart';

import '../utils/dotted_horizontal_line.dart';

class VideoWidget extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;
  final String date;
  final String link;

  const VideoWidget({
    super.key,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.date,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    var unescape = HtmlUnescape();

    return Material(
      child: InkWell(
        onTap: () {
          Get.toNamed('/video/player', arguments: [link, date]);
        },
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(
                  child: Image.network(imageUrl, width: double.infinity),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      unescape.convert(title),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: "Exo 2",
                        color: Color(0xFF122E39),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomPaint(
              painter: DrawDottedhorizontalline(color: const Color(0xFF122E39)),
            ),
          ],
        ),
      ),
    );
  }
}
