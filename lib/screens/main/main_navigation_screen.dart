import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/screens/main/activity/activity_screen.dart';
import 'package:wazafak_app/screens/main/home/home_screen.dart';
import 'package:wazafak_app/screens/main/profile/profile_screen.dart';
import 'package:wazafak_app/screens/main/projects/projects_screen.dart';
import 'package:wazafak_app/screens/main/search/search_screen.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ProjectsScreen(),
    SearchScreen(),
    ActivityScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    changeStatusBarColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: context.resources.color.background,
        selectedItemColor: context.resources.color.colorPrimary,
        unselectedItemColor: context.resources.color.colorGrey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              AppIcons.home,
              width: 22,
              color: context.resources.color.colorGrey,
            ),
            activeIcon: Image.asset(
              AppIcons.home,
              width: 22,
              color: context.resources.color.colorPrimary,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              AppIcons.projects,
              width: 22,
              color: context.resources.color.colorGrey,
            ),
            activeIcon: Image.asset(
              AppIcons.projects,
              width: 22,
              color: context.resources.color.colorPrimary,
            ),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              AppIcons.search,
              width: 22,
              color: context.resources.color.colorGrey,
            ),
            activeIcon: Image.asset(
              AppIcons.search,
              width: 22,
              color: context.resources.color.colorPrimary,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              AppIcons.activity,
              width: 22,
              color: context.resources.color.colorGrey,
            ),
            activeIcon: Image.asset(
              AppIcons.activity,
              width: 22,
              color: context.resources.color.colorPrimary,
            ),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              AppIcons.profile,
              width: 22,
              color: context.resources.color.colorGrey,
            ),
            activeIcon: Image.asset(
              AppIcons.profile,
              width: 22,
              color: context.resources.color.colorPrimary,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void changeStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Get.context!.resources.color.colorPrimary,
        statusBarColor: Get.context!.resources.color.colorPrimary,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }
}
