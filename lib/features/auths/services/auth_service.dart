import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userIdKey = 'userId';
  static const String _userEmailKey = 'userEmail';
  static const String _pendingImagePathKey = 'pendingImagePath';
  
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _userId;
  String? _userEmail;
  String? _pendingImagePath;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get userId => _userId;
  String? get userEmail => _userEmail;
  String? get pendingImagePath => _pendingImagePath;

  AuthService() {
    _loadAuthState();
  }

  // Load authentication state from SharedPreferences
  Future<void> _loadAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      _userId = prefs.getString(_userIdKey);
      _userEmail = prefs.getString(_userEmailKey);
      _pendingImagePath = prefs.getString(_pendingImagePathKey);
      notifyListeners();
    } catch (e) {
      print('Error loading auth state: $e');
    }
  }

  // Save authentication state to SharedPreferences
  Future<void> _saveAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, _isLoggedIn);
      if (_userId != null) {
        await prefs.setString(_userIdKey, _userId!);
      }
      if (_userEmail != null) {
        await prefs.setString(_userEmailKey, _userEmail!);
      }
      if (_pendingImagePath != null) {
        await prefs.setString(_pendingImagePathKey, _pendingImagePath!);
      }
    } catch (e) {
      print('Error saving auth state: $e');
    }
  }

  // Login user
  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // For demo purposes, accept any valid email/password
      if (email.isNotEmpty && password.isNotEmpty) {
        _isLoggedIn = true;
        _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
        _userEmail = email;
        
        await _saveAuthState();
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print('Login error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign up user
  Future<bool> signUp(String name, String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // For demo purposes, accept any valid data
      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        _isLoggedIn = true;
        _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
        _userEmail = email;
        
        await _saveAuthState();
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print('Sign up error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    _isLoggedIn = false;
    _userId = null;
    _userEmail = null;
    
    await _saveAuthState();
    notifyListeners();
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return _isLoggedIn;
  }

  // Store pending image path for after login
  Future<void> setPendingImagePath(String imagePath) async {
    _pendingImagePath = imagePath;
    await _saveAuthState();
    notifyListeners();
  }

  // Clear pending image path
  Future<void> clearPendingImagePath() async {
    _pendingImagePath = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_pendingImagePathKey);
    } catch (e) {
      print('Error clearing pending image path: $e');
    }
    notifyListeners();
  }

  // Clear all auth data
  Future<void> clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_isLoggedInKey);
      await prefs.remove(_userIdKey);
      await prefs.remove(_userEmailKey);
      await prefs.remove(_pendingImagePathKey);
      
      _isLoggedIn = false;
      _userId = null;
      _userEmail = null;
      _pendingImagePath = null;
      notifyListeners();
    } catch (e) {
      print('Error clearing auth data: $e');
    }
  }
}
