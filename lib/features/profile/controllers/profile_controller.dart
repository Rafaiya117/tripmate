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

  ProfileController() {
    _loadProfile();
  }

  // Load profile data
  Future<void> _loadProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock profile data
      _profile = ProfileModel(
        id: '1',
        name: 'Jason Wancs',
        email: 'jason@mail.com',
        profileImageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        isBoosted: true,
        remainingDays: 6,
        remainingHours: 12,
        remainingMinutes: 45,
      );
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
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
