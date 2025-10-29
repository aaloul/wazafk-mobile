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
  bool? _previousMode;

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleModeChange(bool isFreelancerMode) {
    if (_previousMode != null && _previousMode != isFreelancerMode) {
      // Mode has changed
      if (isFreelancerMode && _selectedIndex == 3) {
        // Switching from employer to freelancer and user was on Activity tab
        // Reset to Home since Activity tab doesn't exist in freelancer mode
        setState(() {
          _selectedIndex = 0;
        });
      } else if (_selectedIndex >= (isFreelancerMode ? 4 : 5)) {
        // Index is out of bounds for the new mode
        setState(() {
          _selectedIndex = 0;
        });
      }
    }
    _previousMode = isFreelancerMode;
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

    // If controller exists, use Obx to observe changes
    if (homeController != null) {
      return Obx(() {
        final isFreelancerMode = homeController.isFreelancerMode.value;

        // Handle mode changes and adjust selected index if needed
        _handleModeChange(isFreelancerMode);

        final screens = _getScreens(isFreelancerMode);

        // Safety check: ensure selected index is within bounds
        final safeIndex = _selectedIndex.clamp(0, screens.length - 1);

        return Scaffold(
          body: screens[safeIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: safeIndex,
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

    // Default view when controller is not available yet (freelancer mode by default)
    final isFreelancerMode = true;
    _handleModeChange(isFreelancerMode);

    final screens = _getScreens(isFreelancerMode);

    // Safety check: ensure selected index is within bounds
    final safeIndex = _selectedIndex.clamp(0, screens.length - 1);

    return Scaffold(
      body: screens[safeIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: safeIndex,
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
