import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_mate/features/auths/controllers/ui_controller.dart';
import 'package:trip_mate/features/auths/services/auth_service.dart';
import 'package:trip_mate/features/profile/models/profile_model.dart';

class ProfileController extends ChangeNotifier {
  ProfileModel? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  final String _token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzU4MjA2ODU2LCJpYXQiOjE3NTgxODg4NTYsImp0aSI6ImRhYzhlZGU5MDE5NzRjMmVhOWFjYjc2Mjc0ZTMyMWQyIiwidXNlcl9pZCI6IjYifQ.w-nWctzslsJ6Dt1zItTSAr4VOKt22tbKeQCQpzcgG5c";
  ProfileController() {
    _loadProfile();
  }

  // Load profile data
  Future<void> _loadProfile() async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    const String apiUrl = "https://tourapi.dailo.app/api/payments/profile/"; 
    final dio = Dio();

    final response = await dio.get(
      apiUrl,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $_token",
        },
      ),
    );

    debugPrint("✅ Profile Response Status: ${response.statusCode}");
    debugPrint("✅ Profile Response Data: ${response.data}");

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;

      _profile = ProfileModel(
        id: data['id']?.toString() ?? '',
        name: data['username'] ?? '',
        email: data['email'] ?? '',
        profileImageUrl: data['profile_picture'] ?? '',
        isBoosted: data['plan_type'] != 'free',
        remainingDays: data['time_remaining']?['days'] ?? 0,
        remainingHours: data['time_remaining']?['hours'] ?? 0,
        remainingMinutes: data['time_remaining']?['minutes'] ?? 0,
      );

      _isLoading = false;
      notifyListeners();
    } else {
      _errorMessage = 'Failed to load profile';
      _isLoading = false;
      notifyListeners();
    }
  } catch (e) {
    debugPrint("🔥 Profile fetch error: $e");
    _errorMessage = 'Failed to load profile';
    _isLoading = false;
    notifyListeners();
  }
}


  // Refresh profile
  Future<void> refreshProfile() async {
    await _loadProfile();
  }

  // Update profile
  Future<void> updateProfile(ProfileModel updatedProfile) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      _profile = updatedProfile;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update profile';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Get AuthService and logout
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.logout();
      
      // Clear profile data
      _profile = null;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      
      // Clear all form fields in UIController
      try {
        final uiController = Provider.of<UIController>(context, listen: false);
        uiController.clearAllFormFields();
      } catch (e) {
        // Handle case where UIController is not available
        print('UIController not available during logout');
      }
      
    } catch (e) {
      _errorMessage = 'Failed to logout';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
