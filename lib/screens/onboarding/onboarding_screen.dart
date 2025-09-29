import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/utils/Prefs.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/AppIcons.dart';

import '../../model/BannersResponse.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  PageController pageController = PageController();
  int currentIndex = 0;
  List<BoardingBanner> onboardingData = [];

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    onboardingData = Prefs.getStartBanners;

    // Initialize animation controllers
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    // Initialize animations
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Start initial animations
    _startAnimations();
  }

  void _startAnimations() {
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  void _resetAndStartAnimations() {
    _fadeController.reset();
    _slideController.reset();
    _scaleController.reset();
    _startAnimations();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: onboardingData.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                        _resetAndStartAnimations();
                      },
                      itemCount: onboardingData.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Animated Image
                              AnimatedBuilder(
                                animation: _scaleAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _scaleAnimation.value,
                                    child: FadeTransition(
                                      opacity: _fadeAnimation,
                                      child: Container(
                                        height: 190,
                                        width: double.infinity,
                                        child: PrimaryNetworkImage(
                                          url: onboardingData[index].source
                                              .toString(),
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 50),
                              // Animated Title
                              SlideTransition(
                                position: _slideAnimation,
                                child: FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: PrimaryText(
                                    text: onboardingData[index].title
                                        .toString(),
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    textColor:
                                        context.resources.color.colorBlackMain,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Animated Content
                              SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: const Offset(0, 0.5),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: _slideController,
                                        curve: const Interval(
                                          0.3,
                                          1.0,
                                          curve: Curves.easeOutBack,
                                        ),
                                      ),
                                    ),
                                child: FadeTransition(
                                  opacity: Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(
                                        CurvedAnimation(
                                          parent: _fadeController,
                                          curve: const Interval(
                                            0.2,
                                            1.0,
                                            curve: Curves.easeInOut,
                                          ),
                                        ),
                                      ),
                                  child: PrimaryText(
                                    text: onboardingData[index].description
                                        .toString(),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    textColor:
                                        context.resources.color.colorGrey,
                                    textAlign: TextAlign.center,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // Animated Page indicators
                  const SizedBox(height: 32),

                  const SizedBox(height: 32),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: PrimaryButton(
                      title: currentIndex == onboardingData.length - 1
                          ? 'Get Started'
                          : 'Next',
                      onPressed: _nextPage,
                      icon: AppIcons.arrowRight,
                    ),
                  ),
                  // Animated Skip button
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextButton(
                        onPressed: _skipOnboarding,
                        child: PrimaryText(
                          text: 'Skip',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          textColor: context.resources.color.colorBlackMain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _nextPage() {
    if (currentIndex < onboardingData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      Get.offAllNamed(RouteConstant.phoneNumberScreen);
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    Prefs.setOnboardingCompleted(true);
    // Navigate to main screen or login screen
    // You can replace this with your desired navigation
    Get.back(); // Go back to splash screen which will then navigate appropriately
  }
}
