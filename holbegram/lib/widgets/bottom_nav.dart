import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../screens/pages/feed.dart';
//import '../screens/pages/search.dart';
import '../screens/pages/add_image.dart';
//import '../screens/pages/favorite.dart';
//import '../screens/pages/profile_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).refreshUser();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: const [
          Feed(),
          //Search(),
          AddImage(),
          //Favorite(),
          //ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        items: [
          BottomNavyBarItem(
            icon: const Icon(Icons.home_outlined),
            title: const Text(
              "Home",
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Billabong',
              ),
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.search),
            title: const Text(
              "Search",
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Billabong',
              ),
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.add),
            title: const Text(
              "Add",
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Billabong',
              ),
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.favorite_border),
            title: const Text(
              "Likes",
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Billabong',
              ),
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.person_outline),
            title: const Text(
              "Profile",
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Billabong',
              ),
              textAlign: TextAlign.center,
            ),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
