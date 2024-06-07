import 'package:catsuka/screens/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'components/app_bar.dart';
import 'components/nav_bar.dart';
import 'screens/home.dart';
import 'screens/video.dart';
import 'screens/news.dart';
import 'screens/breve.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CatsukaApp());
}

class CatsukaApp extends StatelessWidget {
  const CatsukaApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Color(0xFF122E39)),
    );

    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'Exo 2',
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const Screen(navBarIndex: 0, child: Home()),
          transition: Transition.noTransition,
          children: [
            GetPage(
              name: '/breve',
              page: () => const Screen(navBarIndex: 0, child: Breve()),
              transition: Transition.cupertino,
              transitionDuration: const Duration(milliseconds: 200),
              popGesture: true,
            ),
            GetPage(
              name: '/news',
              page: () => const Screen(navBarIndex: 0, child: News()),
              transition: Transition.cupertino,
              transitionDuration: const Duration(milliseconds: 200),
              popGesture: true,
            ),
          ]
        ),
        GetPage(
          name: '/video',
          page: () => const Screen(navBarIndex: 1, child: Video()),
          transition: Transition.noTransition,
          children: [
            GetPage(
              name: '/player',
              page: () => const Screen(navBarIndex: 1, child: Player()),
              transition: Transition.cupertino,
              transitionDuration: const Duration(milliseconds: 200),
              popGesture: true,
            ),
          ],
        ),
      ],
    );
  }
}

class Screen extends StatelessWidget {
  final Widget child;
  final int navBarIndex;

  const Screen({super.key, required this.child, this.navBarIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: catsukaAppBarWidget,
      body: child,
      bottomNavigationBar: CatsukaNavBarWidget(navBarIndex: navBarIndex),
    );
  }
}