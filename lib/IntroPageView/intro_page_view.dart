import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage {
  final String title;
  final String lottieAnimationPath;
  final List<String> features;

  OnboardingPage({
    required this.title,
    required this.lottieAnimationPath,
    required this.features,
  });
}

class IntroPageView extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<IntroPageView>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: "Say Goodbye to Chemicals!",
      lottieAnimationPath: "assets/animations/Animation_meditation.json",
      features: [
        "Home remedies for common health issues.",
        "Herbal alternatives to synthetic medicines.",
        "Ayurveda remedies for mental health"
      ],
    ),
    OnboardingPage(
      title: "Smart AI, Ancient Wisdom -\n Tailored Just for you!",
      lottieAnimationPath: "assets/animations/Page_view_2.json",
      features: [
        "Ai suggested customised home remedies \nand yoga based on use inputs",
        "Deadline trackingxx",
        "Performance analyticsxx"
      ],
    ),
    OnboardingPage(
      title: "Track Your Health, and Stay Fit!",
      lottieAnimationPath: "assets/animations/Animation_meditation.json",
      features: [
        "Yoga tutorials for holistic lifestyles",
        "My Health section to track history \nand saved remedies.",
        "A store for Ayurvedic Products."
      ],
    ),
  ];

  @override
  void initState(){
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToNextPage(){
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateToLogin() {
    GoRouter.of(context).pushNamed('login_page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                    _animationController.reset();
                    _animationController.forward();
                  });
                },
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_pages[index]);
                },
              ),
            ),
            _buildPageIndicator(),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            page.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          // Lottie Animation with scale and fade transition
          TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 500),
            tween: Tween(begin: 0.8, end: 1.0),
            builder: (context, scale, child) {
              return Opacity(
                opacity: scale,
                child: Transform.scale(
                  scale: scale,
                  child: Lottie.asset(
                    page.lottieAnimationPath,
                    controller: _animationController,
                    height: 250,
                    width: 250,
                    onLoaded: (composition) {
                      _animationController
                        ..duration = composition.duration
                        ..forward();
                    },
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 32),
          Text(
            'Key Features:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          ...page.features.map((feature) => AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(0, 0.4, curve: Curves.easeInOut),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.green),
                      SizedBox(width: 8),
                      Text(feature),
                    ],
                  ),
                ),
              );
            },
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _pages.map((page) {
        int index = _pages.indexOf(page);
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: _currentPage == index ? 16 : 10,
          height: 10,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: _currentPage == index ? Colors.green : Colors.grey[300],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          if (_currentPage > 0)
            ElevatedButton(
              onPressed: _navigateToPreviousPage,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.green),
              ),
              child: Row(
                children: [
                  Icon(Icons.arrow_back),
                  SizedBox(width: 8),
                  Text('Previous'),
                ],
              ),
            ),

          // Spacer to push Next/Get Started button to the right
          Spacer(),

          // Next/Get Started button
          ElevatedButton(
            onPressed: _navigateToNextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Row(
              children: [
                Text(_currentPage < _pages.length - 1 ? 'Next' : 'Get Started'),
                SizedBox(width: 8),
                Icon(_currentPage < _pages.length - 1
                    ? Icons.arrow_forward
                    : Icons.check),
              ],
            ),
          ),
        ],
      ),
    );
  }
}