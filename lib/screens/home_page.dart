import 'package:api_example/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:api_example/repository/media_repository.dart';
import 'package:api_example/models/media.dart';
import 'package:api_example/screens/detail.dart';
import 'package:api_example/widgets/media_list_tile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final MediaRepository repo = MediaRepository();
  List<Media> _results = [];
  bool _isLoading = false;
  String? _error;
  int _tabIndex = 0;
  List<Media> _favoriteMedias = [];
  bool _isLoadingFavorites = false;

  Future<void> _search() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      print("i will ho to search: ${_searchController.text}");
      final results = await repo.searchShows(_searchController.text);
      print('Search results: $results');
      setState(() {
        _results = results;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _openDetail(Media media) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final images = await repo.getShowImages(media.id);
      //for each image
      print('Images total : ${images.length}');
      
      for (var image in images) {
        print(image);
      }

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(media: media, images: images),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading details: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadFavorites() async {
    setState(() { _isLoadingFavorites = true; });
    final ids = await repo.getFavorites();
    List<Media> favs = [];
    for (final id in ids) {
      try {
        final media = await repo.getShowById(id);
        favs.add(media);
      } catch (_) {}
    }
    setState(() {
      _favoriteMedias = favs;
      _isLoadingFavorites = false;
    });
  }

  Future<void> _toggleFavorite(Media media) async {
    final isFav = await repo.isFavorite(media.id);
    if (isFav) {
      await repo.removeFavorite(media.id);
    } else {
      await repo.addFavorite(media.id);
    }
    if (_tabIndex == 1) _loadFavorites();
    setState(() {});
  }

  Future<bool> _isFavorite(Media media) async {
    return await repo.isFavorite(media.id);
  }

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: _tabIndex,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(AppLocalizations.of(context)!.title),
          bottom: TabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context)!.homeTitle),
              Tab(text: AppLocalizations.of(context)!.favTitle),
            ],
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            onTap: (i) {
              setState(() { _tabIndex = i; });
              if (i == 1) _loadFavorites();
            },
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            labelText: 'Search TV Shows',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _search,
                        child: Text(AppLocalizations.of(context)!.searchButton),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_isLoading) const CircularProgressIndicator(),
                  if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
                  if (!_isLoading && _error == null)
                    Expanded(
                      child: _results.isEmpty
                        ? const Center(child: Text('No results'))
                        : ListView.builder(
                            itemCount: _results.length,
                            itemBuilder: (context, index) {
                              final media = _results[index];
                              return FutureBuilder<bool>(
                                future: _isFavorite(media),
                                builder: (context, snapshot) {
                                  final isFav = snapshot.data ?? false;
                                  return MediaListTile(
                                    media: media,
                                    isFavorite: isFav,
                                    onFavoriteToggle: () => _toggleFavorite(media),
                                    onDetail: () => _openDetail(media),
                                  );
                                },
                              );
                            },
                          ),
                    ),
                ],
              ),
            ),
            _isLoadingFavorites
              ? const Center(child: CircularProgressIndicator())
              : _favoriteMedias.isEmpty
                ? const Center(child: Text('No favorites'))
                : ListView.builder(
                    itemCount: _favoriteMedias.length,
                    itemBuilder: (context, index) {
                      final media = _favoriteMedias[index];
                      return MediaListTile(
                        media: media,
                        isFavorite: true,
                        onFavoriteToggle: () => _toggleFavorite(media),
                        onDetail: () => _openDetail(media),
                        showDelete: true,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
