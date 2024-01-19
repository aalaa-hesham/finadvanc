import 'package:advanc_task_10/pages/home.dart';
import 'package:advanc_task_10/pages/profile.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/app_bar_ex.widget.dart';

class MasterPage extends StatefulWidget {
  const MasterPage({
    super.key,
  });

  @override
  State<MasterPage> createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Home(),
    const Text(
      'Categories Page',
    ),
    const Profile(),
    const Text(
      'Cart Page',
    ),
    const Text(
      'More Page',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        height: 50,
        onTap: (index) {
          _selectedIndex = index;
          setState(() {});
        },
        backgroundColor: Colors.black.withOpacity(.002),
        elevation: 0,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.smoothEdge,
        leftCornerRadius: 15,
        rightCornerRadius: 15,
        activeIndex: _selectedIndex,
        itemCount: 5,
        tabBuilder: ((index, isActive) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                index == 0
                    ? Icons.home
                    : index == 1
                        ? Icons.image
                        : index == 2
                            ? Icons.person
                            : index == 3
                                ? Icons.share_arrival_time
                                : Icons.more_vert_rounded,
                size: 25,
                color: isActive ? Colors.green : Colors.grey,
              ),
              Text(
                index == 0
                    ? 'Home'
                    : index == 1
                        ? 'Category'
                        : index == 2
                            ? 'Profile'
                            : index == 3
                                ? 'Cart'
                                : 'More',
                style: TextStyle(
                  color: isActive ? Colors.green : Colors.grey,
                ),
              )
            ],
          );
        }),
      ),
      appBar: AppBarEx.getAppBar,
      body: Column(
        children: <Widget>[Expanded(child: _pages[_selectedIndex])],
      ),
    );
  }
}
