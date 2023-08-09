import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/dotted_horizontal_line.dart';

class ShortWidget extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String date;
  final String link;

  const ShortWidget({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    var unescape = HtmlUnescape();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          child: Column(
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
                          'Brève',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                              color: Colors.white,
                            fontFamily: "Exo 2",
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(-1, 0),
                        child: SvgPicture.asset(
                            "assets/images/orange_triangle.svg",),
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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          unescape.convert(title),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            fontFamily: "Exo 2",
                            color: Color(0xFF122E39),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/breve', arguments: [link, date]);
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
                              SvgPicture.asset(
                                "assets/images/forward_triangle.svg",
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Lire la brève",
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
                  const SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Center(
                        child: Container(
                          width: 138,
                          height: 79,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                imageUrl,
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        CustomPaint(
          painter: DrawDottedhorizontalline(color: const Color(0xFF122E39)),
        ),
      ],
    );
  }
}
