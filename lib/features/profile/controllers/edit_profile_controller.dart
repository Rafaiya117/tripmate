import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:trip_mate/config/colors/colors.dart';
import 'package:trip_mate/features/profile/models/edit_profile_model.dart';

class EditProfileController extends ChangeNotifier {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  String? _successMessage;
  
  // Visibility toggles for password fields
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  
  // Profile image
  File? _selectedImage;
  String _currentImageUrl = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face';

  // Getters
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isOldPasswordVisible => _isOldPasswordVisible;
  bool get isNewPasswordVisible => _isNewPasswordVisible;
  File? get selectedImage => _selectedImage;
  String get currentImageUrl => _currentImageUrl;

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

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );
      
      if (image != null) {
        _selectedImage = File(image.path);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to pick image. Please try again.';
      notifyListeners();
    }
  }



  // Show image picker options
  Future<void> showImagePickerOptions(BuildContext context) async {
    await pickImageFromGallery();
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
    _selectedImage = null;
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
