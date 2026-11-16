import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'main_nav_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _checkLogin();
    _loadLastUser();
  }

  void _loadLastUser() async {
    final lastUser = await AuthService.getLastRegisteredUsername();
    if (lastUser != null && lastUser.isNotEmpty && mounted) {
      setState(() => _usernameController.text = lastUser);
    }
  }

  void _checkLogin() async {
    if (await AuthService.isLoggedIn() && mounted) {
      final username = await AuthService.getUsername();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainNavScreen(initialUsername: username)),
      );
    }
  }

  void _login() async {
    final identifier = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (identifier.isEmpty || password.isEmpty) {
      _showMessage('Username dan password tidak boleh kosong!', isError: true);
      return;
    }

    final result = await AuthService.login(identifier: identifier, password: password);
    if (!mounted) return;

    if (result['success'] == true) {
      final UserModel user = result['user'];
      _showMessage('Selamat datang, ${user.username}!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainNavScreen(initialUsername: user.username)),
      );
    } else {
      _showMessage(result['message'] ?? 'Login gagal!', isError: true);
    }
  }

  void _showMessage(String text, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: isError ? const Color(0xFFEF4444) : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecor({required String hint, required IconData icon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(color: const Color(0xFF64748B), fontSize: 13.5),
      prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFF0F131D),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0x1AFFFFFF))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0x1AFFFFFF))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFB55FE6), width: 1.5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090C13),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131722),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0x22FFFFFF)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 7, height: 7, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFB55FE6))),
                      const SizedBox(width: 8),
                      Text('SPACENEWS EXPLORER', style: GoogleFonts.plusJakartaSans(color: const Color(0xFFB55FE6), fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text('SpaceNews Access', style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 8),
                Text('Kredensial akun diperlukan untuk mengakses\nportal berita antariksa.', textAlign: TextAlign.center, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xFF8E9AA8))),
                const SizedBox(height: 28),

                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131722),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0x1AFFFFFF)),
                    boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 16, offset: Offset(0, 4))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('USERNAME / EMAIL', style: GoogleFonts.plusJakartaSans(color: const Color(0xFF8E9AA8), fontSize: 11, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _usernameController,
                        style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13.5),
                        decoration: _inputDecor(hint: 'Masukkan username atau email', icon: Icons.person_outline_rounded),
                      ),
                      const SizedBox(height: 18),
                      Text('PASSWORD', style: GoogleFonts.plusJakartaSans(color: const Color(0xFF8E9AA8), fontSize: 11, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13.5),
                        decoration: _inputDecor(
                          hint: 'Masukkan password Anda',
                          icon: Icons.lock_outline_rounded,
                          suffix: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF64748B), size: 20),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(colors: [Color(0xFF8A3FFC), Color(0xFFB55FE6)]),
                          boxShadow: [BoxShadow(color: const Color(0xFFB55FE6).withValues(alpha: 0.35), blurRadius: 14, offset: const Offset(0, 4))],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                          onPressed: _login,
                          child: Text('Masuk ke Sistem', style: GoogleFonts.plusJakartaSans(fontSize: 14.5, fontWeight: FontWeight.w800, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Belum punya akun? ', style: GoogleFonts.plusJakartaSans(color: const Color(0xFF8E9AA8), fontSize: 13)),
                    GestureDetector(
                      onTap: () async {
                        final newUser = await Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                        if (newUser != null && newUser is String) {
                          _usernameController.text = newUser;
                        }
                      },
                      child: Text('Daftar Sekarang', style: GoogleFonts.plusJakartaSans(color: const Color(0xFFB55FE6), fontWeight: FontWeight.w700, fontSize: 13)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
