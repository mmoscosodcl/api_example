import 'package:flutter/material.dart';
import 'package:api_example/models/media.dart';

class MediaListTile extends StatelessWidget {
  final Media media;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onDetail;
  final bool showDelete;

  const MediaListTile({
    Key? key,
    required this.media,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onDetail,
    this.showDelete = false,
  }) : super(key: key);

  String getShortSummary(String? summary) {
    if (summary == null || summary.isEmpty) return '';
    final plain = summary.replaceAll(RegExp(r'<[^>]*>'), '');
    if (plain.length <= 114) return plain;
    return plain.substring(0, 111) + '...';
  }

  @override
  Widget build(BuildContext context) {
    final summary = getShortSummary(media.summary);
    final imageUrl = media.image?.medium?.url ?? media.image?.original?.url;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background image
          if (imageUrl != null)
            Positioned.fill(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.25),
                colorBlendMode: BlendMode.darken,
              ),
            )
          else
            Positioned.fill(
              child: Container(
                color: Colors.grey[300],
                child: const Icon(Icons.tv, size: 60, color: Colors.black26),
              ),
            ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        media.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        showDelete
                            ? Icons.delete
                            : (isFavorite ? Icons.favorite : Icons.favorite_border),
                        color: Colors.red,
                        size: 28,
                      ),
                      onPressed: onFavoriteToggle,
                      splashRadius: 24,
                      tooltip: showDelete ? 'Remove from favorites' : 'Add to favorites',
                    ),
                  ],
                ),
                if (media.genres.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 6),
                    child: Text(
                      media.genres.join(', '),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (summary.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      summary,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Icons.info_outline, color: Colors.white),
                    onPressed: onDetail,
                    tooltip: 'Show details',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
