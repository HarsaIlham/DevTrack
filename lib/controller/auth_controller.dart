import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracedev/services/api_services.dart';

class AuthController extends ChangeNotifier {
  final ApiServices _apiService = ApiServices();

  String? _token;
  int? _userId;

  String? get token => _token;
  int? get userId => _userId;

  Future<void> login(String email, String password) async {
    try {
      final result = await _apiService.login(email, password);
      _token = result['token'];
      _userId = int.tryParse(result['UserId'].toString());

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      await prefs.setInt('userId', _userId!);

      notifyListeners();
    } catch (e) {
      debugPrint('Login Error: $e');
      rethrow;
    }
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _userId = prefs.getInt('userId');
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');

    _token = null;
    _userId = null;

    notifyListeners();
  }
}
