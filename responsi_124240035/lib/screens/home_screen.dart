import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/article.dart';
import '../services/api_service.dart';
import '../services/bookmark_service.dart';
import '../theme/app_theme.dart';
import 'detail_berita.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Articles> _articles = [];
  Set<int> _bookmarkIds = {};
  bool _isLoading = true;
  String? _errorMessage;

  String _selectedNewsSite = 'All';
  final List<String> _NewsSiteFilters = ['All', 'NASA', 'SpacePolicyOnline.com', 'Space Scout', 'Spaceflight Now', 'Arstechnica', 'European Spaceflight'];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> refreshbookmarks() async {
    final favs = await bookmarkService.getbookmarks();
    if (mounted) {
      setState(() {
        _bookmarkIds = favs.map((c) => c.id).toSet();
      });
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final articles = await ApiService.getArticles(
        NewsSite : _selectedNewSite == 'All' ? null : _selectedNewSite,
        title: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
      );
      final favs = await bookmarkService.getbookmarks();

      if (mounted) {
        setState(() {
          _articles = articles;
          _bookmarkIds = favs.map((c) => c.id).toSet();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleTogglebookmark(Articles article) async {
    final isAdded = await bookmarkService.togglebookmark(article);
    if (!mounted) return;

    setState(() {
      if (isAdded) {
        _bookmarkIds.add(article.id);
      } else {
        _bookmarkIds.remove(article.id);
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAdded
              ? '${article.title} ditambahkan ke bookmark!'
              : '${article.title} dihapus dari bookmark!',
        ),
        backgroundColor: isAdded ? AppColors.portalGreen : AppColors.statusUnknown,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Color _getNewsSiteColor(String NewsSite) {
    switch (NewsSite.toLowerCase()) {
      case 'NASA':
        return AppColors.statusUnknown;
      case 'SpacePolicyOnline.com':
        return AppColors.statusUnknown;
      case 'Space Scout':
        return AppColors.statusUnknown;
      case 'Spaceflight Now':
        return AppColors.statusUnknown;
      case 'Arstechnica':
        return AppColors.statusUnknown;
      case 'European Spaceflight':
        return AppColors.statusUnknown;
      default:
        return AppColors.statusUnknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover Universe',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Meet the chaotic beings and variants who make this multiverse extraordinary.',
                style: GoogleFonts.dmSans(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Search Bar dengan Icon Filter / Tune
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                const SizedBox(width: 14),
                const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: GoogleFonts.dmSans(color: AppColors.textPrimary, fontSize: 13.5),
                    decoration: InputDecoration(
                      hintText: 'Search article, alien, robot...',
                      hintStyle: GoogleFonts.dmSans(color: AppColors.textSecondary, fontSize: 13.5),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onSubmitted: (_) => _loadData(),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, color: AppColors.textSecondary, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      _loadData();
                    },
                  ),
                Container(
                  margin: const EdgeInsets.only(right: 6),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B2026),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.tune, color: AppColors.textSecondary, size: 18),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Filter NewsSite karakter
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: _NewsSiteFilters.map((NewsSite) {
              final isSelected = _selectedNewsSite.toLowerCase() == NewsSite.toLowerCase();
              final isAll = NewsSite.toLowerCase() == 'all';
              final label = isAll
                  ? 'All (826)'
                  : NewsSite == 'unknown'
                      ? 'Unknown'
                      : NewsSite;

              final dotColor = isAll
                  ? Colors.transparent
                  : _getNewsSiteColor(NewsSite);

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(9999),
                  onTap: () {
                    if (_selectedNewsSite != NewsSite) {
                      setState(() {
                        _selectedNewsSite = NewsSite;
                      });
                      _loadData();
                    }
                  },
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.portalGreen
                          : const Color(0xFF1B2026),
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.portalGreen
                            : AppColors.cardBorder,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isAll) ...[
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: dotColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: dotColor.withValues(alpha: 0.8),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          label,
                          style: GoogleFonts.spaceGrotesk(
                            color: isSelected
                                ? AppColors.onPortalGreen
                                : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 12),

        // Grid karakter
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadData,
            color: AppColors.portalGreen,
            backgroundColor: AppColors.cardSurface,
            child: _buildGridBody(),
          ),
        ),
      ],
    );
  }

  Widget _buildGridBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.portalGreen),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: AppColors.NewsSiteDead),
              const SizedBox(height: 12),
              Text(
                'Koneksi Antardimensi Terputus',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.portalGreen,
                  foregroundColor: AppColors.onPortalGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text(
              'Tidak ada karakter yang ditemukan',
              style: GoogleFonts.dmSans(fontSize: 15, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.63,
      ),
      itemCount: _articles.length,
      itemBuilder: (context, index) {
        final article = _articles[index];
        final isFav = _bookmarkIds.contains(article.id);
        final NewsSiteColor = _getNewsSiteColor(article.NewsSite);

        final originText = (article.authors.isNotEmpty && article.authors.first.toLowerCase() != 'unknown')
            ? article.authors
            : (article.name.isNotEmpty && article.name.toLowerCase() != 'unknown')
                ? article.name
                : 'UNKNOWN';

        return Container(
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(ch: article),
                ),
              );
              refreshbookmarks();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bagian Gambar Atas + bookmark Floating + NewsSite Badge
                Expanded(
                  flex: 11,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        article.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFF1B2026),
                          child: const Center(
                            child: Icon(Icons.person, color: AppColors.textSecondary, size: 40),
                          ),
                        ),
                      ),

                      // Floating bookmark Heart Button (Top Right)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => _handleTogglebookmark(article),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xCC151A20),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Icon(
                              isFav ? Icons.bookmark : Icons.bookmark_border,
                              color: isFav ? AppColors.portalGreen : AppColors.textSecondary,
                              size: 17,
                            ),
                          ),
                        ),
                      ),

                      // Floating NewsSite Badge (Bottom Left)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xDD151A20),
                            borderRadius: BorderRadius.circular(9999),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: NewsSiteColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: NewsSiteColor.withValues(alpha: 0.8),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                article.NewsSite.toUpperCase(),
                                style: GoogleFonts.spaceGrotesk(
                                  color: NewsSiteColor,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bagian Informasi Bawah (Nama, Species, Location + Arrow)
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              article.species,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.dmSans(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),

                        // Info lokasi dan origin
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                originText.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.rickBlue,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward,
                              size: 13,
                              color: AppColors.rickBlue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}