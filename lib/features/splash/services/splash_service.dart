import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashService {
  static void navigateToLogin(BuildContext context) {
    Timer(const Duration(milliseconds: 500), () {
      if (context.mounted) {
        context.go('/login_page');
      }
    });
  }

  static void navigateToHome(BuildContext context) {
    Timer(const Duration(milliseconds: 500), () {
      if (context.mounted) {
        context.go('/home');
      }
    });
  }

  static void navigateToSignUp(BuildContext context) {
    Timer(const Duration(milliseconds: 500), () {
      if (context.mounted) {
        context.go('/');
      }
    });
  }
}
