import 'package:catsuka/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReadOnWebsiteButton extends StatelessWidget {
  final String link;

  const ReadOnWebsiteButton({
    super.key, required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        UrlLauncher.launch(link);
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
    );
  }
}