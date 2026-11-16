import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/bookmark_service.dart';
import '../theme/app_theme.dart';
import '../widget/logout_modal.dart';
import 'home_screen.dart';
import 'bookmark_screen.dart';

class MainNavScreen extends StatefulWidget {
  final String? initialUsername;
  const MainNavScreen({super.key, this.initialUsername});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;
  late String _username;

  final _homeKey = GlobalKey<HomeScreenState>();
  final _bookmarkKey = GlobalKey<BookmarkScreenState>();

  @override
  void initState() {
    super.initState();
    _username = widget.initialUsername ?? 'User';
    _loadUsername();
  }

  void _loadUsername() async {
    final user = await BookmarkService.getUsername();
    if (mounted && user.isNotEmpty) {
      setState(() {
        _username = user;
      });
    }
  }

  void _goToBookmark() {
    setState(() => _currentIndex = 1);
    _bookmarkKey.currentState?.loadBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFB55FE6),
                boxShadow: [BoxShadow(color: Color(0xFFB55FE6), blurRadius: 8, spreadRadius: 2)],
              ),
            ),
            const SizedBox(width: 10),
            Text('Halo, $_username!', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF131722), border: Border.all(color: const Color(0x24FFFFFF))),
              child: const Icon(Icons.bookmark_border_rounded, color: Colors.white, size: 19),
            ),
            onPressed: _goToBookmark,
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1E172E),
                border: Border.all(color: const Color(0xFFB55FE6), width: 1.5),
              ),
              child: const Icon(Icons.person_rounded, color: Color(0xFFB55FE6), size: 19),
            ),
            onPressed: () => LogoutModal.show(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(key: _homeKey),
          BookmarkScreen(key: _bookmarkKey),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0A0D15),
          border: Border(top: BorderSide(color: Color(0x18FFFFFF), width: 1)),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF0A0D15),
          elevation: 0,
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xFFB55FE6),
          unselectedItemColor: const Color(0xFF64748B),
          selectedLabelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 10),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 10),
          onTap: (index) {
            setState(() => _currentIndex = index);
            if (index == 0) _homeKey.currentState?.refreshBookmarks();
            if (index == 1) _bookmarkKey.currentState?.loadBookmarks();
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize_rounded, size: 21), label: 'BERITA'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark_rounded, size: 21), label: 'DISIMPAN'),
          ],
        ),
      ),
    );
  }
}
