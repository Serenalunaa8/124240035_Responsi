import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/article.dart';
import '../services/bookmark_service.dart';
import 'detail_berita.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => BookmarkScreenState();
}

class BookmarkScreenState extends State<BookmarkScreen> {
  List<Articles> _bookmarks = [];
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

    final data = await BookmarkService.getBookmarks();
    if (mounted) {
      setState(() {
        _bookmarks = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteBookmark(Articles article, int index) async {
    await BookmarkService.removeBookmark(article.id);
    if (!mounted) return;

    setState(() {
      _bookmarks.removeAt(index);
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${article.title} dihapus dari bookmark!'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFB55FE6)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
          child: Row(
            children: [
              Text(
                'Berita Disimpan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF221735),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0x66B55FE6)),
                ),
                child: Text(
                  '${_bookmarks.length} TERSIMPAN',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFB55FE6),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Daftar Bookmark
        Expanded(
          child: _bookmarks.isEmpty
              ? Center(
                  child: Text(
                    'Belum ada berita tersimpan',
                    style: GoogleFonts.plusJakartaSans(color: const Color(0xFF8E9AA8)),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadBookmarks,
                  color: const Color(0xFFB55FE6),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 2, 20, 24),
                    itemCount: _bookmarks.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final article = _bookmarks[index];

                      return Dismissible(
                        key: ValueKey('bm_${article.id}'),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => _deleteBookmark(article, index),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red[800],
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
                        ),
                        child: InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(article: article),
                              ),
                            );
                            loadBookmarks();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF131722),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0x1AFFFFFF)),
                            ),
                            child: Row(
                              children: [
                                // Thumbnail
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: article.imageUrl.isNotEmpty
                                      ? Image.network(
                                          article.imageUrl,
                                          width: 74,
                                          height: 74,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            width: 74,
                                            height: 74,
                                            color: const Color(0xFF0F131D),
                                            child: const Icon(Icons.rocket, color: Colors.white24),
                                          ),
                                        )
                                      : Container(
                                          width: 74,
                                          height: 74,
                                          color: const Color(0xFF0F131D),
                                          child: const Icon(Icons.rocket, color: Colors.white24),
                                        ),
                                ),
                                const SizedBox(width: 14),

                                // Judul dan Sumber
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        article.newsSite.toUpperCase(),
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 10,
                                          color: const Color(0xFFB55FE6),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Tombol Hapus Bookmark
                                IconButton(
                                  icon: const Icon(Icons.bookmark_rounded, color: Color(0xFFB55FE6)),
                                  onPressed: () => _deleteBookmark(article, index),
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
