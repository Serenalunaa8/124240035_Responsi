import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // Controller animasi progress
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOutCubic,
    );

    // Animasi progress bar
    _progressController.repeat(reverse: true);

    // Animasi shimmer
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Widget _buildSparkleDot(double size, {Color color = AppColors.portalGreen}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.8),
            blurRadius: size * 2,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color portalGreen = AppColors.portalGreen;
    const Color surfaceLowest = AppColors.surfaceLowest;
    const Color surfaceBg = AppColors.background;
    const Color textMain = AppColors.textPrimary;
    const Color textMuted = AppColors.textSecondary;

    return Scaffold(
      backgroundColor: surfaceBg,
      body: Stack(
        children: [
          // Partikel cahaya kosmik halus di latar belakang
          Positioned(top: 80, left: 40, child: _buildSparkleDot(3.5)),
          Positioned(top: 220, left: 30, child: _buildSparkleDot(2.5)),
          Positioned(top: 140, right: 35, child: _buildSparkleDot(3.0)),
          Positioned(bottom: 230, right: 45, child: _buildSparkleDot(3.5)),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxHeight < 680;
                final bannerSize = (constraints.maxHeight * 0.35).clamp(200.0, 280.0);

                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: isCompact ? 12.0 : 20.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(height: isCompact ? 4 : 10),

                            // Bagian Tengah: Logo, Banner Poster & Judul
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                // Banner Card dengan Glow Hijau di Sekitar Gambar Saja
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Glow hijau tepat di sekeliling gambar
                                    Container(
                                      width: bannerSize,
                                      height: bannerSize,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: portalGreen.withValues(alpha: 0.45),
                                            blurRadius: 26,
                                            spreadRadius: 3,
                                          ),
                                          BoxShadow(
                                            color: portalGreen.withValues(alpha: 0.2),
                                            blurRadius: 42,
                                            spreadRadius: 6,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Gambar Banner
                                    Container(
                                      width: bannerSize,
                                      height: bannerSize,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: portalGreen.withValues(alpha: 0.5),
                                          width: 1.5,
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        'assets/images/rickandmorty.jpg',
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Image.network(
                                          'https://upload.wikimedia.org/wikipedia/en/c/c8/Rick_and_Morty_season_5.png',
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            color: const Color(0xFF141A21),
                                            child: const Center(
                                              child: Icon(Icons.movie_filter, color: portalGreen, size: 64),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: isCompact ? 18 : 28),

                                // Judul aplikasi
                                Text(
                                  'MULTIVERSE',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: isCompact ? 19 : 22,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2.0,
                                    color: textMain,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'CHARACTER EXPLORER',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: isCompact ? 17 : 20,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.5,
                                    color: portalGreen,
                                    shadows: [
                                      Shadow(
                                        color: portalGreen.withValues(alpha: 0.6),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: isCompact ? 8 : 12),

                                Text(
                                  'Explore bizarre entities, variants, and rogue gods\nbeyond your native dimension.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: isCompact ? 12 : 13,
                                    height: 1.45,
                                    color: textMuted,
                                  ),
                                ),
                              ],
                            ),

                            // Bagian Bawah: Kalibrasi Loading bar & Tombol Aksi "Open Portal"
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 16),

                                // Status Bar Kalibrasi & Loading Bar yang Bergerak Aktif
                                AnimatedBuilder(
                                  animation: _progressAnimation,
                                  builder: (context, child) {
                                    final currentProgress = _progressAnimation.value;
                                    final percent = (currentProgress * 100).toStringAsFixed(1);
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 6,
                                                    height: 6,
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: portalGreen,
                                                      boxShadow: [
                                                        BoxShadow(color: portalGreen, blurRadius: 6),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    'FLUID CALIBRATION',
                                                    style: GoogleFonts.spaceGrotesk(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w700,
                                                      letterSpacing: 1.2,
                                                      color: textMuted,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '$percent%',
                                                style: GoogleFonts.spaceGrotesk(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color(0xFF63B3ED), // Portal blue accent
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        // Progress bar
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            height: 6,
                                            width: double.infinity,
                                            color: const Color(0xFF141A21),
                                            child: Stack(
                                              children: [
                                                FractionallySizedBox(
                                                  alignment: Alignment.centerLeft,
                                                  widthFactor: currentProgress.clamp(0.02, 1.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      gradient: const LinearGradient(
                                                        colors: [Color(0xFF4FD1C5), portalGreen],
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: portalGreen.withValues(alpha: 0.8),
                                                          blurRadius: 8,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                // Efek gelombang cahaya bergerak di atas progress bar
                                                AnimatedBuilder(
                                                  animation: _shimmerAnimation,
                                                  builder: (context, child) {
                                                    return FractionallySizedBox(
                                                      alignment: Alignment(
                                                        _shimmerAnimation.value,
                                                        0,
                                                      ),
                                                      widthFactor: 0.3,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            colors: [
                                                              Colors.transparent,
                                                              Colors.white.withValues(alpha: 0.7),
                                                              Colors.transparent,
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 10),

                                        Text(
                                          currentProgress > 0.95
                                              ? 'Portal stabilized • • •'
                                              : 'Warping across dimensions • • •',
                                          style: GoogleFonts.spaceGrotesk(
                                            fontSize: 11,
                                            color: textMuted.withValues(alpha: 0.8),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),

                                const SizedBox(height: 24),

                                // Tombol aksi utama
                                Container(
                                  width: double.infinity,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: portalGreen.withValues(alpha: 0.4),
                                        blurRadius: 18,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: portalGreen,
                                      foregroundColor: surfaceLowest,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: _navigateToLogin,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Open Portal',
                                          style: GoogleFonts.spaceGrotesk(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.bolt, size: 20),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}