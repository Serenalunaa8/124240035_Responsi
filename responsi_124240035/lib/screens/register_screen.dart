import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = true;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
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

  void _register() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _showMessage('Semua kolom wajib diisi!', isError: true);
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _showMessage('Format email tidak valid! Contoh: name@domain.com', isError: true);
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Konfirmasi password tidak cocok!', isError: true);
      return;
    }

    if (!_agreedToTerms) {
      _showMessage('Harap setujui syarat & ketentuan!', isError: true);
      return;
    }

    final result = await AuthService.register(username: username, email: email, password: password);
    if (!mounted) return;

    if (result['success'] == true) {
      _showMessage('Registrasi berhasil! Silakan login.');
      Navigator.pop(context, username);
    } else {
      _showMessage(result['message'] ?? 'Registrasi gagal!', isError: true);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13.5),
      decoration: InputDecoration(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090C13),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Text('Daftar Akun Baru', style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(height: 6),
              Text('Buat akun untuk mengakses SpaceNews Explorer.', style: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xFF8E9AA8))),
              const SizedBox(height: 24),

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
                    Text('USERNAME', style: GoogleFonts.plusJakartaSans(color: const Color(0xFF8E9AA8), fontSize: 11, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    _inputField(controller: _usernameController, hint: 'Pilih username Anda', icon: Icons.person_outline_rounded),
                    const SizedBox(height: 16),

                    Text('EMAIL', style: GoogleFonts.plusJakartaSans(color: const Color(0xFF8E9AA8), fontSize: 11, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    _inputField(controller: _emailController, hint: 'nama@domain.com', icon: Icons.mail_outline_rounded, keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 16),

                    Text('PASSWORD', style: GoogleFonts.plusJakartaSans(color: const Color(0xFF8E9AA8), fontSize: 11, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    _inputField(
                      controller: _passwordController,
                      hint: 'Minimal 6 karakter',
                      icon: Icons.lock_outline_rounded,
                      obscure: _obscurePassword,
                      suffix: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF64748B), size: 20),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text('KONFIRMASI PASSWORD', style: GoogleFonts.plusJakartaSans(color: const Color(0xFF8E9AA8), fontSize: 11, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    _inputField(
                      controller: _confirmPasswordController,
                      hint: 'Ulangi password',
                      icon: Icons.lock_reset_rounded,
                      obscure: _obscureConfirm,
                      suffix: IconButton(
                        icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF64748B), size: 20),
                        onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          activeColor: const Color(0xFFB55FE6),
                          checkColor: Colors.white,
                          side: const BorderSide(color: Color(0xFFB55FE6), width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          onChanged: (val) => setState(() => _agreedToTerms = val ?? true),
                        ),
                        Expanded(
                          child: Text(
                            'Saya menyetujui Syarat, Ketentuan & Kebijakan Privasi SpaceNews Explorer.',
                            style: GoogleFonts.plusJakartaSans(color: const Color(0xFF8E9AA8), fontSize: 11.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),

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
                        onPressed: _register,
                        child: Text('Daftarkan Akun', style: GoogleFonts.plusJakartaSans(fontSize: 14.5, fontWeight: FontWeight.w800, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sudah punya akun? ', style: GoogleFonts.plusJakartaSans(color: const Color(0xFF8E9AA8), fontSize: 13)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text('Masuk di Sini', style: GoogleFonts.plusJakartaSans(color: const Color(0xFFB55FE6), fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
