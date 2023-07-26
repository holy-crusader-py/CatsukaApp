import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/dotted_horizontal_line.dart';

class NewsWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String date;
  final String link;

  const NewsWidget({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    var unescape = HtmlUnescape();

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xffdc4520),
                          ),
                          child: const Text(
                            'News',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Exo 2",
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(-1, 0),
                          child: SvgPicture.asset(
                              "assets/images/orange_triangle.svg"),
                        ),
                      ],
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
                Text(
                  unescape.convert(title),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    fontFamily: "Exo 2",
                    color: Color(0xFF122E39),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
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
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unescape.convert(description.split("<br />")[0]),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Exo 2",
                    color: Color(0x80122E39),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed('/news', arguments: [link, date]);
                  },
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Color(0xFF122E39)),
                    padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                    ),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset("assets/images/forward_triangle.svg"),
                      const SizedBox(width: 10),
                      const Text(
                        "Lire la news",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Exo 2",
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          CustomPaint(
            painter: DrawDottedhorizontalline(color: const Color(0xFF122E39)),
          ),
        ],
      ),
    );
  }
}
