import 'package:flutter/material.dart';

class Video extends StatelessWidget {
  const Video({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: 400 * 0.5,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Image.asset("assets/images/capsuka_video.png"),
        ),
        const Text(
          "Cet espace est en cours de développement...",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            fontFamily: "Exo 2",
            color: Color(0xFF122E39),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
