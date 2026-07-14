import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/socket_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final SocketService socketService = SocketService();
  
  User? _user;
  String? _token;
  bool _isLoading = true;

  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _user != null && _token != null;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _loadStoredAuth();
  }

  Future<void> _loadStoredAuth() async {
    final data = await _authService.getStoredAuthData();
    if (data != null) {
      _token = data['token'];
      _user = data['user'];
      // Initialize socket immediately if we have a token
      socketService.connect(_token!);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<String?> login(String username) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.loginGuest(username);
    
    if (result['success']) {
      _token = result['token'];
      _user = result['user'];
      socketService.connect(_token!);
      _isLoading = false;
      notifyListeners();
      return null; // No error
    } else {
      _isLoading = false;
      notifyListeners();
      return result['error']; // Return error message
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    socketService.disconnect();
    _token = null;
    _user = null;
    notifyListeners();
  }
}
