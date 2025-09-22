import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:trip_mate/features/auths/services/auth_service.dart';

class ScanController extends ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://ppp7rljm-8000.inc1.devtunnels.ms"));

  bool isLoading = false;
  Map<String, dynamic>? lastScanResult;
  String? _token;

  Future<void> uploadScan(String imagePath) async {
  try {
    isLoading = true;
    notifyListeners();

    print("Uploading file: $imagePath");

    final file = await MultipartFile.fromFile(imagePath,filename: imagePath.split('/').last);
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
      "/api/scans/scan/?image=",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $_token",
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    lastScanResult = response.data;
    print("✅ Scan uploaded successfully: $lastScanResult");
  } catch (e) {
    if (e is DioException) {
      print("❌ Upload failed: ${e.response?.statusCode} -> ${e.response?.data}");
    } else {
      print("❌ Unexpected error: $e");
    }
    rethrow;
  } finally {
    isLoading = false;
    notifyListeners();
  }
}
}
