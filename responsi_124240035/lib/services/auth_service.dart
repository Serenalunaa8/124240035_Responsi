import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final String username;
  final String email;
  final String password;

  UserModel({required this.username, required this.email, required this.password});
}

class AuthService {
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final cleanUsername = username.trim();
    final cleanEmail = email.trim();
    final cleanPassword = password.trim();

    if (cleanUsername.isEmpty || cleanEmail.isEmpty || cleanPassword.isEmpty) {
      return {'success': false, 'message': 'Semua kolom wajib diisi!'};
    }

    try {
      final userBox = Hive.box('users');
      final emailBox = Hive.box('user_emails');

      await userBox.put(cleanUsername.toLowerCase(), cleanPassword);
      await emailBox.put(cleanUsername.toLowerCase(), cleanEmail);
      await emailBox.put(cleanEmail.toLowerCase(), cleanUsername.toLowerCase());

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_user', cleanUsername);

      return {'success': true, 'message': 'Registrasi berhasil!'};
    } catch (e) {
      return {'success': false, 'message': 'Gagal mendaftar: $e'};
    }
  }

  static Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    final cleanId = identifier.trim().toLowerCase();
    final cleanPassword = password.trim();

    final userBox = Hive.box('users');
    final emailBox = Hive.box('user_emails');

    String usernameKey = cleanId;
    if (cleanId.contains('@')) {
      final foundUser = emailBox.get(cleanId);
      if (foundUser != null) {
        usernameKey = foundUser.toString();
      }
    }

    final savedPassword = userBox.get(usernameKey);
    if (savedPassword == null) {
      return {'success': false, 'message': 'Akun tidak ditemukan!'};
    }

    if (savedPassword.toString() != cleanPassword) {
      return {'success': false, 'message': 'Password salah!'};
    }

    final email = emailBox.get(usernameKey)?.toString() ?? '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loginData', true);
    await prefs.setString('session_username', usernameKey);
    await prefs.setString('session_email', email);

    return {
      'success': true,
      'user': UserModel(username: usernameKey, email: email, password: cleanPassword),
    };
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loginData') ?? false;
  }

  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session_username') ?? 'User';
  }

  static Future<String?> getLastRegisteredUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_user');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loginData', false);
    await prefs.remove('session_username');
    await prefs.remove('session_email');
  }
}
