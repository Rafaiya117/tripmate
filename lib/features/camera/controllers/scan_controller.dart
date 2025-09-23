import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:trip_mate/config/baseurl/baseurl.dart';
import 'package:trip_mate/features/auths/services/auth_service.dart';

class ScanController extends ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: Baseurl.baseUrl));

  bool isLoading = false;
  Map<String, dynamic>? lastScanResult;
  String? _token;

  Future<void> uploadScan(String imagePath) async {
  try {
    isLoading = true;
    notifyListeners();

    print("Uploading file: $imagePath");

    final file = await MultipartFile.fromFile(imagePath, filename: imagePath.split('/').last);
    final authService = AuthService();
    await authService.loadAuthState();
    _token = authService.token;

    final formData = FormData.fromMap({
      "image": file,
      "latitude": "22.5784",
      "longitude": "89.9671",
      "source": "gallery",
      "language": "Traditional Chinese",
    });

    final response = await _dio.post(
      "/api/scans/scan/",
      data: formData,
      options: Options(headers: {"Authorization": "Bearer $_token"}),
    );

    if (response.data is Map) {
      lastScanResult = Map<String, dynamic>.from(response.data as Map);
      print("✅ Scan uploaded successfully: $lastScanResult");
    } else {
      print("❌ Unexpected response format: ${response.data}");
      lastScanResult = _fakeScanResult();
    }
  } catch (e) {
    if (e is DioException) {
      print("❌ Upload failed: ${e.response?.statusCode} -> ${e.response?.data}");
    } else {
      print("❌ Unexpected error: $e");
    }

    lastScanResult = _fakeScanResult();
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

Map<String, dynamic> _fakeScanResult() {
  return {
    "scan": {
      "id": 0,
      "user": 0,
      "user_email": "placeholder@example.com",
    },
    "analysis": {
      "landmark_name": "Unknown Landmark",
      "location": "Unknown City",
      "year_completed": 1900,
      "historical_overview": "This is a placeholder description of the landmark's history.",
      "materials": "Brick, Stone",
      "architectural_style": "Neo-Classical",
    },
  };
}

}
