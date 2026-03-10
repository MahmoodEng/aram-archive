import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../database/database_helper.dart';
import '../models/book_model.dart';
import 'box_detail_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookProvider>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: Consumer<BookProvider>(
        builder: (context, provider, _) {
          final favorites = provider.favorites;
          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_outline,
                    size: 80,
                    color: Theme.of(context)
                        .colorScheme
                        .error
                        .withOpacity(0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style:
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the heart icon on a book to favorite it',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.4),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final book = favorites[index];
              return _FavoriteBookTile(
                book: book,
                onTap: () async {
                  final box =
                      await DatabaseHelper().getBoxById(book.boxId);
                  if (box != null && context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BoxDetailPage(box: box),
                      ),
                    ).then(
                        (_) => context.read<BookProvider>().loadFavorites());
                  }
                },
                onUnfavorite: () async {
                  await context.read<BookProvider>().toggleFavorite(book);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '"${book.name}" removed from favorites'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _FavoriteBookTile extends StatelessWidget {
  final BookModel book;
  final VoidCallback onTap;
  final VoidCallback onUnfavorite;

  const _FavoriteBookTile({
    required this.book,
    required this.onTap,
    required this.onUnfavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.book,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          book.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: FutureBuilder(
          future: DatabaseHelper().getBoxById(book.boxId),
          builder: (context, snapshot) {
            final boxName = snapshot.data?.name ?? '...';
            return Text('In: $boxName • ${book.pageCount} pages');
          },
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: onUnfavorite,
          tooltip: 'Remove from favorites',
        ),
        onTap: onTap,
      ),
    );
  }
}
