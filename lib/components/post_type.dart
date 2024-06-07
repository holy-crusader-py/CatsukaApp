import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class PostTypeTag extends StatelessWidget {
  final String type;

  const PostTypeTag({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 3,
          ),
          decoration: const BoxDecoration(
            color: Color(0xffdc4520),
          ),
          child: Text(
            type,
            style: const TextStyle(
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
              "assets/images/orange_triangle.svg",
              height: 26.0,
              ),
        ),
      ],
    );
  }
}