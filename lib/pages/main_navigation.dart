import 'package:flutter/material.dart';
import 'home_page.dart';
import 'explore_page.dart';
import 'profile_page.dart';
import 'my_reviews_page.dart'; 
import '../widgets/drawer_widget.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;
  const MainNavigation({this.initialIndex = 0});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  final List<Widget> _screens = [
    HomePage(),
    ExplorePage(),
    MyReviewsPage(), 
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF2F5249),
        selectedItemColor: const Color(0xFFE3DE61),
        unselectedItemColor: const Color(0xFF97B067),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reviews), 
            label: 'My Reviews', 
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
