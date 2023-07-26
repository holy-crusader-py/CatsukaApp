import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CatsukaNavBarWidget extends StatefulWidget {
  final int navBarIndex;

  const CatsukaNavBarWidget({super.key, required this.navBarIndex});

  @override
  State<CatsukaNavBarWidget> createState() => _CatsukaNavBarWidget();
}

class _CatsukaNavBarWidget extends State<CatsukaNavBarWidget> {
  int _selectedIndex = 0;
  Color newsColor = const Color(0xffe04a25);
  Color videoColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    _selectedIndex = widget.navBarIndex;
    _updateItems();
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: const Color(0xFF122E39),
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Text(
              'NEWS',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Exo 2',
                color: newsColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Text(
              'VIDEO',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Exo 2',
                color: videoColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int value) {
    setState(() {
      if (value == 1) {
        Get.offNamed('/video');
      } else {
        Get.offNamed('/');
      }
      _selectedIndex = value;
      _updateItems();
    });
  }

  void _updateItems() {
    if (_selectedIndex == 1) {
      newsColor = Colors.white;
      videoColor = const Color(0xffe04a25);
    } else {
      newsColor = const Color(0xffe04a25);
      videoColor = Colors.white;
    }
  }
}
