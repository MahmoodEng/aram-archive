import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/box_model.dart';
import '../models/book_model.dart';
import 'box_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final DatabaseHelper _db = DatabaseHelper();

  List<BoxModel> _boxResults = [];
  List<BookModel> _bookResults = [];
  bool _isSearching = false;

  void _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _boxResults = [];
        _bookResults = [];
        _isSearching = false;
      });
      return;
    }
    setState(() => _isSearching = true);
    final results = await _db.search(query.trim());
    setState(() {
      _boxResults = (results['boxes'] as List).cast<BoxModel>();
      _bookResults = (results['books'] as List).cast<BookModel>();
      _isSearching = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasResults = _boxResults.isNotEmpty || _bookResults.isNotEmpty;
    final hasQuery = _controller.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search boxes and books...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          _search('');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
                filled: true,
              ),
              onChanged: _search,
            ),
          ),
          if (_isSearching)
            const LinearProgressIndicator()
          else
            const SizedBox.shrink(),
          Expanded(
            child: !hasQuery
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 80,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Type to search',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.5),
                              ),
                        ),
                      ],
                    ),
                  )
                : !hasResults && !_isSearching
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 60,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.3),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No results found',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.5),
                                  ),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          if (_boxResults.isNotEmpty) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Boxes (${_boxResults.length})',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                    ),
                              ),
                            ),
                            ..._boxResults.map(
                              (box) => Card(
                                child: ListTile(
                                  leading: Icon(
                                    Icons.archive,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                                  title: Text(box.name),
                                  trailing:
                                      const Icon(Icons.chevron_right),
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BoxDetailPage(box: box),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          if (_bookResults.isNotEmpty) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Books (${_bookResults.length})',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                    ),
                              ),
                            ),
                            ..._bookResults.map(
                              (book) => FutureBuilder<BoxModel?>(
                                future: DatabaseHelper()
                                    .getBoxById(book.boxId),
                                builder: (context, snapshot) {
                                  final boxName =
                                      snapshot.data?.name ?? 'Unknown Box';
                                  return Card(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.book,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      title: Text(book.name),
                                      subtitle: Text(
                                        'In: $boxName • ${book.pageCount} pages',
                                      ),
                                      trailing: const Icon(
                                          Icons.chevron_right),
                                      onTap: () async {
                                        final box = await DatabaseHelper()
                                            .getBoxById(book.boxId);
                                        if (box != null &&
                                            context.mounted) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => BoxDetailPage(
                                                  box: box),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}
