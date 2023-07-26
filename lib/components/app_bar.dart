import 'package:flutter/material.dart';

PreferredSizeWidget catsukaAppBarWidget = PreferredSize(
  preferredSize: const Size.fromHeight(90),
  child: SafeArea(
    left: false,
    right: false,
    bottom: false,
    child: Stack(
      children: [
        Container(
          width: double.infinity,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFF122E39),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Center(
            child: SizedBox(
              width: 180,
              height: 34,
              child: Stack(
                children: [
                  Container(
                    width: 180,
                    height: 34,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/catsuka_header.png",
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);
