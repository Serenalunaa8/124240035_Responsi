import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Model untuk menampung data user
class UserModel {
  final String username;
  final String email;
  final String password;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() => {
        'username': username,
        'email': email,
        'password': password,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        username: map['username'] ?? '',
        email: map['email'] ?? '',
        password: map['password'] ?? '',
      );
}

// Layanan otentikasi user (registrasi, login, dan sesi)
class AuthService {
  static const String _keyRegisteredUsers = 'registered_users_list';
  static const String _keyIsLoggedIn = 'loginData';
  static const String _keySessionUsername = 'session_username';
  static const String _keySessionEmail = 'session_email';

  // Fungsi registrasi akun baru
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final cleanUsername = username.trim();
    final cleanEmail = email.trim();
    final cleanPassword = password.trim();

    // Validasi form kosong
    if (cleanUsername.isEmpty || cleanPassword.isEmpty) {
      return {'success': false, 'message': 'Username dan password wajib diisi!'};
    }

    if (cleanEmail.isEmpty) {
      return {'success': false, 'message': 'Email wajib diisi!'};
    }

    // Validasi format email
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(cleanEmail)) {
      return {
        'success': false,
        'message': 'Format email tidak valid! (contoh: user@dimension.com)',
      };
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();

      // Simpan data user ke SharedPreferences
      final List<String> rawUsers = prefs.getStringList(_keyRegisteredUsers) ?? [];
      final List<UserModel> users = rawUsers
          .map((item) => UserModel.fromMap(jsonDecode(item)))
          .toList();

      final newUser = UserModel(
        username: cleanUsername,
        email: cleanEmail,
        password: cleanPassword,
      );

      users.removeWhere((u) => u.username.toLowerCase() == cleanUsername.toLowerCase());
      users.add(newUser);

      final List<String> updatedRaw = users.map((u) => jsonEncode(u.toMap())).toList();
      await prefs.setStringList(_keyRegisteredUsers, updatedRaw);

      await prefs.setString('reg_user_${cleanUsername.toLowerCase()}', cleanPassword);
      await prefs.setString('reg_email_${cleanUsername.toLowerCase()}', cleanEmail);
      await prefs.setString('reg_by_email_${cleanEmail.toLowerCase()}', cleanUsername.toLowerCase());

      await prefs.setString('registered_username', cleanUsername);
      await prefs.setString('registered_email', cleanEmail);
      await prefs.setString('registered_password', cleanPassword);

      // Simpan juga ke Hive Box
      try {
        if (!Hive.isBoxOpen('users')) {
          await Hive.openBox('users');
        }
        final userBox = Hive.box('users');
        await userBox.put(cleanUsername.toLowerCase(), cleanPassword);
        await userBox.put(cleanUsername, cleanPassword);
        await userBox.flush();

        if (!Hive.isBoxOpen('user_emails')) {
          await Hive.openBox('user_emails');
        }
        final emailBox = Hive.box('user_emails');
        await emailBox.put(cleanUsername.toLowerCase(), cleanEmail);
        await emailBox.put(cleanEmail.toLowerCase(), cleanUsername.toLowerCase());
        await emailBox.flush();
      } catch (hiveErr) {
        debugPrint('Catatan Hive: $hiveErr');
      }

      return {'success': true, 'message': 'Registrasi berhasil! Silakan login.'};
    } catch (e) {
      return {'success': false, 'message': 'Gagal menyimpan data: $e'};
    }
  }

  // Fungsi proses login
  static Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    final cleanIdentifier = identifier.trim();
    final cleanPassword = password.trim();

    if (cleanIdentifier.isEmpty || cleanPassword.isEmpty) {
      return {'success': false, 'message': 'Username/email dan password tidak boleh kosong!'};
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();

      UserModel? foundUser;

      // Cari user di daftar SharedPreferences
      final List<String> rawUsers = prefs.getStringList(_keyRegisteredUsers) ?? [];
      final List<UserModel> users = rawUsers
          .map((item) => UserModel.fromMap(jsonDecode(item)))
          .toList();

      for (final u in users) {
        final matchUser = u.username.toLowerCase() == cleanIdentifier.toLowerCase();
        final matchEmail = u.email.toLowerCase() == cleanIdentifier.toLowerCase();
        if (matchUser || matchEmail) {
          foundUser = u;
          break;
        }
      }

      // Cari berdasarkan key langsung jika belum ditemukan
      if (foundUser == null) {
        final savedPass = prefs.getString('reg_user_${cleanIdentifier.toLowerCase()}');
        if (savedPass != null) {
          final savedEmail = prefs.getString('reg_email_${cleanIdentifier.toLowerCase()}') ?? '';
          foundUser = UserModel(username: cleanIdentifier, email: savedEmail, password: savedPass);
        } else if (cleanIdentifier.contains('@')) {
          final mappedUser = prefs.getString('reg_by_email_${cleanIdentifier.toLowerCase()}');
          if (mappedUser != null) {
            final pass = prefs.getString('reg_user_$mappedUser');
            if (pass != null) {
              final savedEmail = prefs.getString('reg_email_$mappedUser') ?? cleanIdentifier;
              foundUser = UserModel(username: mappedUser, email: savedEmail, password: pass);
            }
          }
        }
      }

      // Cari dari data user terakhir
      if (foundUser == null) {
        final regUser = prefs.getString('registered_username');
        final regEmail = prefs.getString('registered_email');
        final regPass = prefs.getString('registered_password');

        if (regUser != null && regPass != null) {
          if (regUser.toLowerCase() == cleanIdentifier.toLowerCase() ||
              (regEmail != null && regEmail.toLowerCase() == cleanIdentifier.toLowerCase())) {
            foundUser = UserModel(
              username: regUser,
              email: regEmail ?? '',
              password: regPass,
            );
          }
        }
      }

      // Cari di Hive box jika belum ditemukan
      if (foundUser == null) {
        try {
          if (!Hive.isBoxOpen('users')) {
            await Hive.openBox('users');
          }
          final userBox = Hive.box('users');
          var savedPass = userBox.get(cleanIdentifier.toLowerCase()) ?? userBox.get(cleanIdentifier);

          String resolvedUser = cleanIdentifier;
          String resolvedEmail = '';

          if (savedPass == null && cleanIdentifier.contains('@')) {
            if (!Hive.isBoxOpen('user_emails')) {
              await Hive.openBox('user_emails');
            }
            final emailBox = Hive.box('user_emails');
            final uname = emailBox.get(cleanIdentifier.toLowerCase()) ?? emailBox.get(cleanIdentifier);
            if (uname != null) {
              resolvedUser = uname.toString();
              resolvedEmail = cleanIdentifier;
              savedPass = userBox.get(resolvedUser.toLowerCase()) ?? userBox.get(resolvedUser);
            }
          }

          if (savedPass != null) {
            if (resolvedEmail.isEmpty && Hive.isBoxOpen('user_emails')) {
              resolvedEmail = Hive.box('user_emails').get(resolvedUser.toLowerCase())?.toString() ?? '';
            }
            foundUser = UserModel(
              username: resolvedUser,
              email: resolvedEmail,
              password: savedPass.toString(),
            );
          }
        } catch (hiveErr) {
          debugPrint('Catatan Hive: $hiveErr');
        }
      }

      // Cek apakah akun ditemukan
      if (foundUser == null) {
        return {
          'success': false,
          'message': 'Akun belum terdaftar! Silakan registrasi terlebih dahulu.',
        };
      }

      // Cek kecocokan password
      if (foundUser.password != cleanPassword) {
        return {
          'success': false,
          'message': 'Password salah! Periksa kembali password Anda.',
        };
      }

      // Simpan sesi login aktif
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keySessionUsername, foundUser.username);
      await prefs.setString(_keySessionEmail, foundUser.email);
      await prefs.setString('username', foundUser.username);

      return {
        'success': true,
        'message': 'Selamat datang kembali, ${foundUser.username}!',
        'user': foundUser,
      };
    } catch (e) {
      return {'success': false, 'message': 'Gagal melakukan login: $e'};
    }
  }

  // Fungsi cek status login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Fungsi ambil username sesi aktif
  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    return prefs.getString(_keySessionUsername) ?? prefs.getString('username') ?? '';
  }

  // Fungsi ambil email sesi aktif
  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    return prefs.getString(_keySessionEmail) ?? prefs.getString('email') ?? '';
  }

  // Fungsi ambil username terakhir yang terdaftar
  static Future<String?> getLastRegisteredUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    return prefs.getString('registered_username');
  }

  // Fungsi logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    await prefs.remove(_keySessionUsername);
    await prefs.remove(_keySessionEmail);
  }
}