import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/article.dart';
import '../services/api_service.dart';
import '../services/bookmark_service.dart';
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

  String _selectedNewsSite = 'Semua';
  final List<String> _newsSiteFilters = [
    'Semua', 'NASA', 'SpaceNews', 'Spaceflight Now', 'Arstechnica', 'SpacePolicyOnline.com', 'European Spaceflight'
  ];
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

  Future<void> refreshBookmarks() async {
    final bookmarks = await BookmarkService.getBookmarks();
    if (mounted) {
      setState(() => _bookmarkIds = bookmarks.map((item) => item.id).toSet());
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final articles = await ApiService.getArticles(
        newsSite: _selectedNewsSite,
        search: _searchController.text.trim(),
        limit: 20,
      );
      final bookmarks = await BookmarkService.getBookmarks();

      if (mounted) {
        setState(() {
          _articles = articles;
          _bookmarkIds = bookmarks.map((item) => item.id).toSet();
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = error.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleBookmark(Articles article) async {
    final isAdded = await BookmarkService.toggleBookmark(article);
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
        content: Text(isAdded ? '${article.title} ditambahkan!' : '${article.title} dihapus!'),
        backgroundColor: isAdded ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Color _getNewsSiteColor(String site) {
    switch (site.toLowerCase()) {
      case 'nasa': return const Color(0xFF3B82F6);
      case 'spacenews': return const Color(0xFF06B6D4);
      case 'spaceflight now': return const Color(0xFFC084FC);
      case 'arstechnica': return const Color(0xFFFB7185);
      case 'european spaceflight': return const Color(0xFF34D399);
      default: return const Color(0xFF38BDF8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SpaceNews Explorer', style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(height: 4),
              Text('Eksplorasi berita antariksa terkini dan dokumentasi kosmis dunia.', style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: const Color(0xFF8E9AA8))),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF131722),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x1FFFFFFF)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 21),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(
                    hintText: 'Cari berita antariksa, roket, galaksi...',
                    hintStyle: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _loadData(),
                ),
              ),
              IconButton(icon: const Icon(Icons.tune_rounded, color: Color(0xFF8E9AA8), size: 20), onPressed: _loadData),
            ],
          ),
        ),
        const SizedBox(height: 16),

        SizedBox(
          height: 38,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: _newsSiteFilters.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final site = _newsSiteFilters[index];
              final isSelected = _selectedNewsSite == site;
              return InkWell(
                borderRadius: BorderRadius.circular(99),
                onTap: () {
                  if (_selectedNewsSite != site) {
                    setState(() => _selectedNewsSite = site);
                    _loadData();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: isSelected ? const LinearGradient(colors: [Color(0xFF8A3FFC), Color(0xFFB55FE6)]) : null,
                    color: isSelected ? null : const Color(0xFF131722),
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(color: isSelected ? Colors.transparent : const Color(0x22FFFFFF)),
                  ),
                  child: Row(
                    children: [
                      if (site != 'Semua') ...[
                        Container(width: 6, height: 6, decoration: BoxDecoration(color: _getNewsSiteColor(site), shape: BoxShape.circle)),
                        const SizedBox(width: 7),
                      ],
                      Text(site, style: GoogleFonts.plusJakartaSans(color: isSelected ? Colors.white : const Color(0xFFE2E8F0), fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600, fontSize: 12.5)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 18),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TERBARU & UTAMA', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFFCBD5E1), letterSpacing: 0.8)),
              Text('${_articles.length} Berita', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFFB55FE6))),
            ],
          ),
        ),
        const SizedBox(height: 12),

        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator(color: Color(0xFFB55FE6)));
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: Colors.red),
            const SizedBox(height: 10),
            Text('Gagal memuat berita', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _loadData, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB55FE6)), child: const Text('Coba Lagi', style: TextStyle(color: Colors.white))),
          ],
        ),
      );
    }
    if (_articles.isEmpty) return const Center(child: Text('Tidak ada berita ditemukan', style: TextStyle(color: Color(0xFF8E9AA8))));

    return RefreshIndicator(
      onRefresh: _loadData,
      color: const Color(0xFFB55FE6),
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.58,
        ),
        itemCount: _articles.length,
        itemBuilder: (context, index) {
          final article = _articles[index];
          final isFav = _bookmarkIds.contains(article.id);
          final siteColor = _getNewsSiteColor(article.newsSite);

          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF131722),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0x1AFFFFFF)),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(article: article)));
                refreshBookmarks();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 12,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        article.imageUrl.isNotEmpty
                            ? Image.network(
                                article.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: const Color(0xFF0F131D),
                                  child: const Icon(Icons.broken_image, color: Colors.white24),
                                ),
                              )
                            : Container(color: const Color(0xFF0F131D), child: const Icon(Icons.rocket, color: Colors.white24)),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => _toggleBookmark(article),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle, border: Border.all(color: Colors.white24)),
                              child: Icon(isFav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded, color: isFav ? const Color(0xFFB55FE6) : Colors.white, size: 17),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                            decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(99), border: Border.all(color: Colors.white12)),
                            child: Row(
                              children: [
                                Container(width: 5, height: 5, decoration: BoxDecoration(color: siteColor, shape: BoxShape.circle)),
                                const SizedBox(width: 5),
                                Text(article.newsSite.isNotEmpty ? article.newsSite : 'News', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(article.publishedAt.split('T').first, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF64748B))),
                              const SizedBox(height: 3),
                              Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.white, height: 1.25)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('3 mnt baca', style: GoogleFonts.plusJakartaSans(fontSize: 9.5, color: const Color(0xFF64748B))),
                              Text('Misi APOD', style: GoogleFonts.plusJakartaSans(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFFB55FE6))),
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
      ),
    );
  }
}
