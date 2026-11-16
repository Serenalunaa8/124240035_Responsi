import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article.dart';
import '../services/bookmark_service.dart';
import '../widget/logout_modal.dart';

class DetailScreen extends StatefulWidget {
  final Articles article;
  const DetailScreen({super.key, required this.article});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkBookmarkStatus();
  }

  void _checkBookmarkStatus() async {
    final status = await BookmarkService.isBookmark(widget.article.id);
    if (mounted) {
      setState(() {
        _isBookmarked = status;
      });
    }
  }

  void _toggleBookmark() async {
    final isAdded = await BookmarkService.toggleBookmark(widget.article);
    if (!mounted) return;

    setState(() {
      _isBookmarked = isAdded;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.article.title} ${isAdded ? "berhasil ditambahkan ke simpanan" : "dihapus dari simpanan"}!',
        ),
        backgroundColor: isAdded ? Colors.green : Colors.red,
      ),
    );
  }

  void _openArticleUrl() async {
    final uri = Uri.parse(widget.article.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return Scaffold(
      backgroundColor: const Color(0xFF090C13),
      appBar: AppBar(
        backgroundColor: const Color(0xFF090C13),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detail Berita',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _isBookmarked ? const Color(0xFFB55FE6) : Colors.white,
            ),
            onPressed: _toggleBookmark,
          ),
          IconButton(
            icon: const Icon(Icons.person_rounded, color: Colors.white),
            onPressed: () => LogoutModal.show(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: article.imageUrl.isNotEmpty
                  ? Image.network(
                      article.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF131722),
                        child: const Icon(Icons.rocket, color: Colors.white24),
                      ),
                    )
                  : Container(color: const Color(0xFF131722)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB55FE6).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          article.newsSite.toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFB55FE6),
                          ),
                        ),
                      ),
                      Text(
                        article.publishedAt.split('T').first,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: const Color(0xFF8E9AA8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    article.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131722),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0x1AFFFFFF)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person_pin_rounded, color: Color(0xFFB55FE6), size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            article.authors.isEmpty ? 'Unknown' : article.authors,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Ringkasan Berita',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.summary.isNotEmpty ? article.summary : 'Tidak ada ringkasan.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      color: const Color(0xFF94A3B8),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 30),

                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8A3FFC), Color(0xFFB55FE6)],
                      ),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _openArticleUrl,
                      icon: const Icon(Icons.open_in_browser_rounded, color: Colors.white),
                      label: Text(
                        'Read Full Article',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
