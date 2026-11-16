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

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOutCubic,
    );

    _progressController.repeat(reverse: true);

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

  Widget _buildSparkleDot(double size, {Color color = const Color(0xFFB55FE6)}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.8),
            blurRadius: size * 2.5,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryViolet = Color(0xFFB55FE6);
    const Color surfaceBg = AppColors.background;
    const Color textMain = AppColors.textPrimary;
    const Color textMuted = Color(0xFF8E9AA8);

    return Scaffold(
      backgroundColor: surfaceBg,
      body: Stack(
        children: [
          Positioned(top: 80, left: 40, child: _buildSparkleDot(3.5)),
          Positioned(top: 220, left: 30, child: _buildSparkleDot(2.5, color: const Color(0xFF38BDF8))),
          Positioned(top: 140, right: 35, child: _buildSparkleDot(3.0)),
          Positioned(bottom: 230, right: 45, child: _buildSparkleDot(3.5, color: const Color(0xFFFBBF24))),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxHeight < 680;
                final bannerSize = (constraints.maxHeight * 0.35).clamp(180.0, 260.0);

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

                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: bannerSize,
                                      height: bannerSize,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(28),
                                        boxShadow: [
                                          BoxShadow(
                                            color: primaryViolet.withValues(alpha: 0.3),
                                            blurRadius: 36,
                                            spreadRadius: 4,
                                          ),
                                          BoxShadow(
                                            color: const Color(0xFF8A3FFC).withValues(alpha: 0.2),
                                            blurRadius: 50,
                                            spreadRadius: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: bannerSize,
                                      height: bannerSize,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF131722),
                                        borderRadius: BorderRadius.circular(28),
                                        border: Border.all(
                                          color: primaryViolet.withValues(alpha: 0.5),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(22),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: primaryViolet.withValues(alpha: 0.12),
                                                border: Border.all(
                                                  color: primaryViolet.withValues(alpha: 0.35),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.rocket_launch_rounded,
                                                color: primaryViolet,
                                                size: 52,
                                              ),
                                            ),
                                            const SizedBox(height: 14),
                                            Text(
                                              'MISSION FEED',
                                              style: GoogleFonts.plusJakartaSans(
                                                color: const Color(0xFF38BDF8),
                                                fontWeight: FontWeight.w800,
                                                fontSize: 11,
                                                letterSpacing: 2.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: isCompact ? 18 : 28),

                                Text(
                                  'SPACENEWS',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: isCompact ? 24 : 28,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.5,
                                    color: textMain,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'EXPLORER',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: isCompact ? 18 : 22,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.5,
                                    color: primaryViolet,
                                    shadows: [
                                      Shadow(
                                        color: primaryViolet.withValues(alpha: 0.6),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: isCompact ? 8 : 12),

                                Text(
                                  'Eksplorasi berita antariksa terkini,\nmisi luar angkasa, dan dokumentasi kosmis dunia.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: isCompact ? 12 : 13.5,
                                    height: 1.45,
                                    color: textMuted,
                                  ),
                                ),
                              ],
                            ),

                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 16),

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
                                                      color: primaryViolet,
                                                      boxShadow: [
                                                        BoxShadow(color: primaryViolet, blurRadius: 6),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    'TELEMETRY SYNC',
                                                    style: GoogleFonts.plusJakartaSans(
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
                                                style: GoogleFonts.plusJakartaSans(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color(0xFF38BDF8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            height: 6,
                                            width: double.infinity,
                                            color: const Color(0xFF131722),
                                            child: Stack(
                                              children: [
                                                FractionallySizedBox(
                                                  alignment: Alignment.centerLeft,
                                                  widthFactor: currentProgress.clamp(0.02, 1.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      gradient: const LinearGradient(
                                                        colors: [Color(0xFF8A3FFC), primaryViolet],
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: primaryViolet.withValues(alpha: 0.8),
                                                          blurRadius: 8,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
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
                                              ? 'Telemetry synchronized • • •'
                                              : 'Connecting to space network • • •',
                                          style: GoogleFonts.plusJakartaSans(
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

                                Container(
                                  width: double.infinity,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF8A3FFC), Color(0xFFB55FE6)],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryViolet.withValues(alpha: 0.4),
                                        blurRadius: 18,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: _navigateToLogin,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Mulai Eksplorasi',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.rocket_launch_rounded, size: 20, color: Colors.white),
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
