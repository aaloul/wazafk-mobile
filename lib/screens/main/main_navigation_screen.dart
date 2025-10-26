import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/screens/main/activity/activity_screen.dart';
import 'package:wazafak_app/screens/main/home/home_controller.dart';
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

  List<Widget> _getScreens(bool isFreelancerMode) {
    if (isFreelancerMode) {
      // Freelancer: Home, Projects, Search, Profile (no Activity)
      return [HomeScreen(), ProjectsScreen(), SearchScreen(), ProfileScreen()];
    } else {
      // Employer: Home, Projects, Search, Activity, Profile
      return [
        HomeScreen(),
        ProjectsScreen(),
        SearchScreen(),
        ActivityScreen(),
        ProfileScreen(),
      ];
    }
  }

  vvoid _onItemTapped(int index) {
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
    // Try to find existing HomeController, if not found, it will be created when HomeScreen is displayed
    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : null;

    return Obx(() {
      final isFreelancerMode = homeController?.isFreelancerMode.value ?? true;
      final screens = _getScreens(isFreelancerMode);

      // Ensure selected index is valid
      if (_selectedIndex >= screens.length) {
        _selectedIndex = 0;
      }

      return Scaffold(
        body: screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: context.resources.color.background,
          selectedItemColor: context.resources.color.colorPrimary,
          unselectedItemColor: context.resources.color.colorGrey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: _buildNavigationItems(context, isFreelancerMode),
        ),
      );
    });
  }

  List<BottomNavigationBarItem> _buildNavigationItems(BuildContext context,
      bool isFreelancerMode) {
    final items = <BottomNavigationBarItem>[
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
    ];

    // Add Activity tab only for employers
    if (!isFreelancerMode) {
      items.add(
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
      );
    }

    // Profile tab is always shown
    items.add(
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
    );

    return items;
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
