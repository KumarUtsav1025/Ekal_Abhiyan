import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './home_screen.dart';
import './create_class_screen.dart';
import './new_class_screen.dart';
import './previous_class_screen.dart';
import './my_profile_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tab-screen';
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late List<Map<String, Object>> _pages;

  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {'page': HomeScreen(), 'title': 'Home'},
      {'page': NewClassScreen(), 'title': 'New Class'},
      {'page': PreviousClass(), 'title': 'Your Classes'},
      {'page': MyProfile(), 'title': 'My Profile'},
    ];
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pages[_selectedPageIndex]['title'] as String,
        ),
      ),

      body: _pages[_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.new_label),
            label: 'Create Class',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.analytics),
            label: 'Your Classes',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.info),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
