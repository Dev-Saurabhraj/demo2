import 'package:flutter/material.dart';
import 'package:swaasthi/RemedyShop/shop_home_screen.dart';
import 'package:swaasthi/screens/home_screen.dart';
import 'package:swaasthi/screens/my_health.dart';
import 'package:swaasthi/screens/profile_screen.dart';
import 'package:swaasthi/screens/remedy_screen.dart';


class PageViewForHome extends StatefulWidget {
  const PageViewForHome({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<PageViewForHome>{
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: [
            HomeScreen(),
            RemedyScreen(),
            MyHealth(),
            ShopHomePage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green[800],
          unselectedItemColor: Colors.green[400],
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.local_hospital), label: 'Remedies'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'My Health'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Shop'),
          ],
        )
    );
  }
}
