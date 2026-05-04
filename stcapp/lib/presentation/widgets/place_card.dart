import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/place_model.dart';
import '../../core/constants/app_colors.dart';

class PlaceCard extends StatelessWidget {
  final PlaceModel place;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const PlaceCard({
    Key? key,
    required this.place,
    required this.onTap,
    required this.onFavoriteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: place.thumbnailUrl != null
                  ? CachedNetworkImage(
                      imageUrl: place.thumbnailUrl!,
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      placeholder: (context, url) => Container(
                        height: 280,
                        color: AppColors.shimmerBase,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 280,
                        color: AppColors.background,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              color: AppColors.textGrey,
                              size: 48,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Image unavailable',
                              style: TextStyle(color: AppColors.textGrey),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      height: 280,
                      color: AppColors.background,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            color: AppColors.textGrey,
                            size: 48,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'No image',
                            style: TextStyle(color: AppColors.textGrey),
                          ),
                        ],
                      ),
                    ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Favorite Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              place.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              place.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: onFavoriteTap,
                        child: Icon(
                          place.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: place.isFavorite
                              ? AppColors.secondary
                              : AppColors.textGrey,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Description
                  Text(
                    place.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
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
