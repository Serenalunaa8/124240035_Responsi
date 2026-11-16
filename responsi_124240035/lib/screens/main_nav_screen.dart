import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsi_124240035/models/article.dart';
import '../theme/app_theme.dart';
import '../widget/logout_modal.dart';
import 'home_screen.dart';
import 'bookmark_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  final GlobalKey<HomeScreenState> _homeKey = GlobalKey<HomeScreenState>();
  final GlobalKey<FavoriteScreenState> _favoriteKey =
      GlobalKey<FavoriteScreenState>();

  @override
  Widget build(BuildContext context) {
    final titles = ['BERITA', 'BOOKMARK', 'EPISODES'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 20,
        title: Row(
          children: [
            const SizedBox(width: 12),
            Text(
              titles[_currentIndex],
              style: GoogleFonts.spaceGrotesk(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () => LogoutModal.show(context),
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.portalGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.onPortalGreen,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(key: _homeKey),
          BookmarkScreen(key: _bookmarkKey),
          const ArticleScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF11161B),
          border: Border(
            top: BorderSide(color: Color(0x14FFFFFF), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF11161B),
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedItemColor: AppColors.portalGreen,
          unselectedItemColor: const Color(0xFF6B7280),
          selectedLabelStyle: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.w700,
            fontSize: 9.5,
            letterSpacing: 0.8,
          ),
          unselectedLabelStyle: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.w600,
            fontSize: 9.5,
            letterSpacing: 0.8,
          ),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (index == 0) {
              _homeKey.currentState?.refreshFavorites();
            } else if (index == 1) {
              _favoriteKey.currentState?.loadFavorites();
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded, size: 21),
              label: 'BERITA',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded, size: 21),
              label: 'BOOKMARK',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.live_tv_rounded, size: 21),
              label: 'EPISODES',
            ),
          ],
        ),
      ),
    );
  }
}