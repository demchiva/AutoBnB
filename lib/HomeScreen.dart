import 'package:autobnb/FavouriteScreen.dart';
import 'package:autobnb/ProfileScreen.dart';
import 'package:autobnb/ReservationsScreen.dart';
import 'package:autobnb/SearchScreen.dart';
import 'package:flutter/material.dart';

import 'CarListScreen.dart';

class HomeScreen extends StatefulWidget {
  static const String ROUTE_NAME = '/';
  static const String ROUTE_NAME_RESERVATIONS = '/reservations';

  final int barIndex;

  const HomeScreen({Key? key, required this.barIndex}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  static const List<Widget> _children = [
    CarListScreen(),
    ReservationsScreen(),
    // SearchScreen(),
    FavouriteScreen(),
    ProfileScreen()
  ];

  late int index;

  @override
  void initState() {
    index = widget.barIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: Container(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: _children[index],
    );
  }

  Widget _buildBottomNavigationBar() => SizedBox(
        height: 70,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 23,
          currentIndex: index,
          onTap: _onTabTapped,
          selectedFontSize: 12.0,
          items: const [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Reservations",
              icon: Icon(Icons.list),
            ),
            // BottomNavigationBarItem(
            //   label: "Search",
            //   icon: Icon(Icons.search),
            // ),
            BottomNavigationBarItem(
              label: "Favourites",
              icon: Icon(Icons.favorite),
            ),
            BottomNavigationBarItem(
              label: "Profile",
              icon: Icon(Icons.manage_accounts),
            ),
          ],
        ),
      );

  void _onTabTapped(final int tappedIndex) {
    setState(() {
      index = tappedIndex;
    });
  }
}
