import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swaasthi/HomePageView/Page_view.dart';
import 'package:swaasthi/screens/home_screen.dart';
import 'package:swaasthi/screens/my_health.dart';
import 'package:swaasthi/screens/remedy_screen.dart';
import '../IntroPageView/intro_page_view.dart';
import '../LoginPage/login_page.dart';
import '../PoseDectector/pose_detector.dart';
import '../screens/profile_screen.dart';

class GoRoutes {
  static GoRouter router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
            path: '/',
            name: 'intro_page_view',
            pageBuilder: (context, state) {
              return MaterialPage(child: IntroPageView());
            }),
        GoRoute(path: '/home_screen',
            name: 'home_screen',
            pageBuilder: (context, state) {
              return MaterialPage(child: HomeScreen());
            }),
        GoRoute(path: '/page_view',
            name: 'page_view',
            pageBuilder: (context, state) {
              return MaterialPage(child: PageViewForHome());
            }),
        GoRoute(
            path: '/my_health',
            name: 'my_health',
            pageBuilder: (context, state) {
              return MaterialPage(child: MyHealth());
            }),
        GoRoute(
            path: '/profile_screen',
            name: 'profile_screen',
            pageBuilder: (context, state) {
              return MaterialPage(child: ProfileScreen());
            }),
        GoRoute(
            path: '/pose_detector',
            name: 'pose_detector',
            pageBuilder: (context, state) {
              return MaterialPage(child: PoseDetectorScreen());
            }),

        GoRoute(
            path: '/login_page',
            name: 'login_page',
            pageBuilder: (context, state) {
              return MaterialPage(
                  child: LoginPage());
            }),

        GoRoute(
            path: '/remedy_screen',
            name: 'remedy_screen',
            pageBuilder: (context, state) {
              return MaterialPage(
                  child: RemedyScreen());
            }),
      ],
      errorPageBuilder: (context, state) {
        return MaterialPage(child: HomeScreen());
      });
}