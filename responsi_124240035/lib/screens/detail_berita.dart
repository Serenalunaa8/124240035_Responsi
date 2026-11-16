import 'package:flutter/material.dart';
import '../models/episode.dart';
import '../theme/app_theme.dart';
import '../widgets/logout_modal.dart';
import '../widgets/rick_morty_logo.dart';

class EpisodeDetailScreen extends StatelessWidget {
  final Episode episode;

  const EpisodeDetailScreen({super.key, required this.episode});

  String _formatSeasonEpisode(String code) {
    final regex = RegExp(r'S(\d+)E(\d+)', caseSensitive: false);
    final match = regex.firstMatch(code);
    if (match != null) {
      final season = int.tryParse(match.group(1) ?? '1') ?? 1;
      final ep = int.tryParse(match.group(2) ?? '1') ?? 1;
      return 'Season $season, Episode $ep';
    }
    return code;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            const RickMortyLogo(
              height: 22,
              glowRadius: 12,
              glowSpread: 2,
              glowOpacity: 0.6,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                episode.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header episode
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.rickBlue.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.rickBlue.withValues(alpha: 0.4)),
                    ),
                    child: const Icon(
                      Icons.movie_creation_outlined,
                      size: 36,
                      color: AppColors.rickBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    episode.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Badge episode
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.rickBlue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(color: AppColors.rickBlue.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      _formatSeasonEpisode(episode.episode),
                      style: const TextStyle(
                        color: AppColors.rickBlue,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Rincian informasi
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TRANSMISSION DETAILS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.portalGreen,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Divider(color: Color(0x1AFFFFFF), thickness: 1, height: 20),

                  _buildDetailTile(
                    icon: Icons.title,
                    label: 'Judul Episode',
                    value: episode.name,
                  ),
                  _buildDetailTile(
                    icon: Icons.tag,
                    label: 'Kode Episode',
                    value: episode.episode,
                  ),
                  _buildDetailTile(
                    icon: Icons.calendar_month_outlined,
                    label: 'Tanggal Rilis',
                    value: episode.airDate,
                  ),
                  _buildDetailTile(
                    icon: Icons.groups_outlined,
                    label: 'Karakter Tampil',
                    value: '${episode.characters.length} Karakter',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.rickBlue, size: 20),
          const SizedBox(width: 12),
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(color: AppColors.textSecondary)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}