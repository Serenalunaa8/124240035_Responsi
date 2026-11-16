import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/article.dart';
import '../services/bookmark_service.dart';
import '../theme/app_theme.dart';
import 'detail_berita.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => BookmarkScreenState();
}

class BookmarkScreenState extends State<BookmarkScreen> {
  List<Articles> _bookmark = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    setState(() {
      _isLoading = true;
    });

    final favs = await bookmarkService.getBookmarks();

    if (mounted) {
      setState(() { 
        _bookmark = favs;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleDeletebookmark(Articles article, int index) async {
    await bookmarkService.removebookmark(article.id);

    setState(() {
      _bookmark.removeAt(index);
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${article.title} dihapus dari bookmark!'),
        backgroundColor: AppColors.NewsSiteDead,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Color _getNewsSiteColor(String NewsSite) {
    switch (NewsSite.toLowerCase()) {
      case 'NASA':
        return AppColors.NewsSiteNASA;
      case 'SpacePolicyOnline.com':
        return AppColors.NewsSiteSpacePolicyOnline;
      case 'Space Scout':
        return AppColors.NewsSiteSpaceScout;
      case 'Spaceflight Now':
        return AppColors.NewsSiteSpaceflightNow;
      case 'Arstechnica':
        return AppColors.NewsSiteArstechnica;
      case 'European Spaceflight':
        return AppColors.NewsSiteEuropeanSpaceflight;
      default:
        return AppColors.NewsSiteUnknown;
    }
  }

  String _formatSpeciesType(Articles article) {
    if (article.type.isNotEmpty) {
      return '${article.species} (${article.type})';
    }
    return article.species;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.portalGreen),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Row(
            children: [
              Text(
                'My bookmarks',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B231D),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.portalGreen.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5.5,
                      height: 5.5,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.portalGreen,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.portalGreen,
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_bookmark.length} SAVED',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.portalGreen,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Daftar favorit
        Expanded(
          child: _bookmark.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bookmark_border_rounded,
                          size: 64,
                          color: AppColors.textSecondary.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Dimensional bookmarks Yet',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the heart icon on any character to save them to your telemetry dashboard.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadbookmarks,
                  color: AppColors.portalGreen,
                  backgroundColor: const Color(0xFF1B222A),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 2, 20, 24),
                    itemCount: _bookmarks.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final char = _bookmarks[index];
                      final NewsSiteColor = _getNewsSiteColor(char.NewsSite);

                      return Dismissible(
                        key: ValueKey('fav_${char.id}'),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          _handleDeletebookmark(char, index);
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 22),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB91C1C),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'DISMISS',
                                style: GoogleFonts.spaceGrotesk(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(character: char),
                              ),
                            );
                            loadbookmarks();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A2128),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0x1FFFFFFF),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Foto karakter
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    char.image,
                                    width: 58,
                                    height: 58,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(
                                      width: 58,
                                      height: 58,
                                      color: AppColors.cardSurface,
                                      child: const Icon(Icons.person,
                                          color: AppColors.textSecondary),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 14),

                                // Informasi karakter
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        char.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _formatSpeciesType(char),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.dmSans(
                                          fontSize: 12,
                                          color: const Color(0xFF82CFEA),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Container(
                                            width: 5,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: NewsSiteColor,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            char.NewsSite,
                                            style: GoogleFonts.dmSans(
                                              fontSize: 11.5,
                                              color: NewsSiteColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.public_rounded,
                                            size: 11,
                                            color: AppColors.textSecondary,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              char.origin,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.dmSans(
                                                fontSize: 11,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 8),

                                // Tombol favorit
                                GestureDetector(
                                  onTap: () => _handleDeletebookmark(char, index),
                                  child: Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF222B34),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.bookmark_rounded,
                                      color: AppColors.portalGreen,
                                      size: 19,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}