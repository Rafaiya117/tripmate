import 'dart:async';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  int _resendTimer = 0;
  Timer? _timer;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get resendTimer => _resendTimer;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void startResendTimer() {
    _resendTimer = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        _resendTimer--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<bool> login(String email, String password) async {
    setLoading(true);
    setErrorMessage(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock validation
      if (email.isEmpty || password.isEmpty) {
        setErrorMessage('Please fill in all fields');
        return false;
      }

      if (!email.contains('@')) {
        setErrorMessage('Please enter a valid email');
        return false;
      }

      // Mock successful login
      setLoading(false);
      return true;
    } catch (e) {
      setErrorMessage('Login failed. Please try again.');
      setLoading(false);
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password, String confirmPassword) async {
    setLoading(true);
    setErrorMessage(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock validation
      if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        setErrorMessage('Please fill in all fields');
        return false;
      }

      if (!email.contains('@')) {
        setErrorMessage('Please enter a valid email');
        return false;
      }

      if (password != confirmPassword) {
        setErrorMessage('Passwords do not match');
        return false;
      }

      if (password.length < 6) {
        setErrorMessage('Password must be at least 6 characters');
        return false;
      }

      // Mock successful signup
      setLoading(false);
      return true;
    } catch (e) {
      setErrorMessage('Sign up failed. Please try again.');
      setLoading(false);
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    setLoading(true);
    setErrorMessage(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock validation
      if (email.isEmpty) {
        setErrorMessage('Please enter your email address');
        return false;
      }

      if (!email.contains('@')) {
        setErrorMessage('Please enter a valid email address');
        return false;
      }

      // Mock successful OTP sent
      setLoading(false);
      startResendTimer();
      return true;
    } catch (e) {
      setErrorMessage('Failed to send OTP. Please try again.');
      setLoading(false);
      return false;
    }
  }

  Future<bool> verifyOTP(String otp) async {
    setLoading(true);
    setErrorMessage(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock validation
      if (otp.isEmpty || otp.length != 4) {
        setErrorMessage('Please enter a valid 4-digit OTP');
        return false;
      }

      // Mock successful OTP verification
      setLoading(false);
      return true;
    } catch (e) {
      setErrorMessage('Invalid OTP. Please try again.');
      setLoading(false);
      return false;
    }
  }

  void resendOTP() {
    if (_resendTimer == 0) {
      startResendTimer();
      // Mock resend OTP
      print('Resending OTP...');
    }
  }

  Future<bool> resetPassword(String newPassword, String confirmPassword) async {
    setLoading(true);
    setErrorMessage(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock validation
      if (newPassword.isEmpty || confirmPassword.isEmpty) {
        setErrorMessage('Please fill in all fields');
        return false;
      }

      if (newPassword != confirmPassword) {
        setErrorMessage('Passwords do not match');
        return false;
      }

      if (newPassword.length < 6) {
        setErrorMessage('Password must be at least 6 characters');
        return false;
      }

      // Mock successful password reset
      setLoading(false);
      return true;
    } catch (e) {
      setErrorMessage('Password reset failed. Please try again.');
      setLoading(false);
      return false;
    }
  }
}
