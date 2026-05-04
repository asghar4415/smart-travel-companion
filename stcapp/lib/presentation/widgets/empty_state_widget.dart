import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyStateWidget({
    Key? key,
    this.title = 'No places found',
    this.subtitle =
        'Try adjusting your search or filter to find what you\'re looking for.',
    this.onAction,
    this.actionLabel = 'Clear Filters',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Magnifying glass icon with gradient background
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.2),
                  AppColors.secondary.withOpacity(0.2),
                ],
              ),
            ),
            child: Center(
              child: Icon(Icons.search, size: 60, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.textGrey,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Action button
          if (onAction != null && actionLabel != null)
            SizedBox(
              width: 160,
              child: ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
