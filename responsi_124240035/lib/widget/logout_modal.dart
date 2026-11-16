import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/login_screen.dart';
import '../services/bookmark_service.dart';
import '../theme/app_theme.dart';

class LogoutModal {
  static Future<void> show(BuildContext context) async {
    final shouldLogout = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          decoration: const BoxDecoration(
            color: Color(0xFF0F131D),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: Color(0x33B55FE6), width: 1.5),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFB55FE6),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFB55FE6),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'SPACENEWS TERMINAL',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: const Color(0xFFB55FE6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1E172E),
                  border: Border.all(
                    color: const Color(0xFFB55FE6).withValues(alpha: 0.8),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFB55FE6).withValues(alpha: 0.35),
                      blurRadius: 20,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.rocket_launch_rounded,
                    size: 38,
                    color: Color(0xFFB55FE6),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Keluar dari SpaceNews?',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Apakah Anda yakin ingin logout? Berita yang telah Anda simpan di bookmark akan tetap aman untuk sesi penjelajahan berikutnya.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: const Color(0xFF8E9AA8),
                    height: 1.45,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8A3FFC), Color(0xFFB55FE6)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFB55FE6).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context, true),
                  icon: const Icon(Icons.power_settings_new_rounded, size: 19, color: Colors.white),
                  label: Text(
                    'Ya, Logout',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF131722),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: Color(0x1AFFFFFF)),
                    ),
                  ),
                  child: Text(
                    'Batal',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (shouldLogout == true && context.mounted) {
      await BookmarkService.clearSession();
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }
}
