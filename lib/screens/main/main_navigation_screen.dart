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
import 'package:wazafak_app/utils/res/Resources.dart';

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
      return [
        HomeScreen(),
        ProjectsScreen(),
        SearchScreen(fromBottomNav: true),
        ProfileScreen()
      ];
    } else {
      // Employer: Home, Activity, Search, Profile
      return [
        HomeScreen(),
        ActivityScreen(),
        SearchScreen(fromBottomNav: true),
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
        : Get.put(HomeController());

    // If controller exists, use Obx to observe changes
      return Obx(() {
        final isFreelancerMode = homeController.isFreelancerMode.value;

        // Handle mode changes and adjust selected index if needed
        _handleModeChange(isFreelancerMode);

        final screens = _getScreens(isFreelancerMode);

        // Safety check: ensure selected index is within bounds
        final safeIndex = _selectedIndex.clamp(0, screens.length - 1);

        return WillPopScope(
          onWillPop: () async {
            if (safeIndex == 0) {
              // Already on home screen, exit the app
              SystemNavigator.pop();
              return false;
            } else {
              // Not on home screen, navigate to home
              setState(() {
                _selectedIndex = 0;
              });
              return false;
            }
          },
          child: Scaffold(
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
              items: _buildNavigationItems(context),
            ),
          ),
        );
      });

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
        items: _buildNavigationItems(context),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNavigationItems(BuildContext context) {
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
        label: Resources
            .of(context)
            .strings
            .home,
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
        label: Resources
            .of(context)
            .strings
            .projects ,
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
        label: Resources
            .of(context)
            .strings
            .search,
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
        label: Resources
            .of(context)
            .strings
            .profile,
      ),
    ];

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
