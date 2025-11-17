import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../models/media.dart';

class DetailScreen extends StatelessWidget {
  final Media media;
  final List<MediaImage> images;

  const DetailScreen({Key? key, required this.media, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(media.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (media.image?.original != null)
              Center(
                child: Image.network(media.image!.original!.url, height: 250, fit: BoxFit.cover),
              ),
            const SizedBox(height: 16),
            Text(media.name, style: Theme.of(context).textTheme.headlineSmall),
            Text(media.genres.join(', '), style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('Language: ${media.language}'),
            Text('Type: ${media.type}'),
            Text('Status: ${media.status}'),
            if (media.premiered != null) Text('Premiered: ${media.premiered}'),
            if (media.ended != null) Text('Ended: ${media.ended}'),
            if (media.officialSite != null)
              Text('Official Site: ${media.officialSite}'),
            if (media.summary != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Html(data: media.summary!),
              ),
            const SizedBox(height: 16),
            Text('Images:', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(
              height: 120,
              child: images.isEmpty
                ? const Center(child: Text('No images available'))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final img = images[index];
                      final url = img.medium?.url ?? img.original?.url;
                      print('Image URL: $url');
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: url != null
                          ? Image.network(url, width: 100, fit: BoxFit.cover)
                          : const Icon(Icons.image_not_supported, size: 100),
                      );
                    },
                  ),
            ),
            const SizedBox(height: 16),
            if (media.network != null)
              Text('Network: ${media.network!.name} (${media.network!.country?.name ?? ''})'),
            if (media.rating?.average != null)
              Text('Rating: ${media.rating!.average}'),
            if (media.schedule != null)
              Text('Schedule: ${media.schedule!.days.join(', ')} at ${media.schedule!.time}'),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
