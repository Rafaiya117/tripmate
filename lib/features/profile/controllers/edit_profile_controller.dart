import 'package:flutter/material.dart';
import 'package:trip_mate/features/profile/models/edit_profile_model.dart';

class EditProfileController extends ChangeNotifier {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  String? _successMessage;
  
  // Visibility toggles for password fields
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;

  // Getters
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isOldPasswordVisible => _isOldPasswordVisible;
  bool get isNewPasswordVisible => _isNewPasswordVisible;

  EditProfileController() {
    _loadInitialData();
  }

  // Load initial data from profile
  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Set initial values (in real app, this would come from API)
      fullNameController.text = 'Arif Hossain';
      emailController.text = 'example@mail.com';
      oldPasswordController.text = '**********';
      newPasswordController.text = '**********';
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load profile data';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle password visibility
  void toggleOldPasswordVisibility() {
    _isOldPasswordVisible = !_isOldPasswordVisible;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    _isNewPasswordVisible = !_isNewPasswordVisible;
    notifyListeners();
  }

  // Validate form
  bool validateForm() {
    if (formKey.currentState?.validate() ?? false) {
      return true;
    }
    return false;
  }

  // Save profile changes
  Future<bool> saveProfile() async {
    if (!validateForm()) {
      return false;
    }

    _isSaving = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Create updated profile model
      final updatedProfile = EditProfileModel(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
      );

      // In real app, this would be an API call
      // await profileService.updateProfile(updatedProfile);
      
      _successMessage = 'Profile updated successfully!';
      _isSaving = false;
      notifyListeners();
      
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update profile. Please try again.';
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  // Clear messages
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSuccess() {
    _successMessage = null;
    notifyListeners();
  }

  // Reset form
  void resetForm() {
    fullNameController.clear();
    emailController.clear();
    oldPasswordController.clear();
    newPasswordController.clear();
    _errorMessage = null;
    _successMessage = null;
    _isOldPasswordVisible = false;
    _isNewPasswordVisible = false;
    notifyListeners();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }
}
