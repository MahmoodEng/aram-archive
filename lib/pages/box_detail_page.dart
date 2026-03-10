import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import '../models/box_model.dart';
import '../models/book_model.dart';
import '../providers/book_provider.dart';
import '../widgets/book_card.dart';

class BoxDetailPage extends StatefulWidget {
  final BoxModel box;

  const BoxDetailPage({super.key, required this.box});

  @override
  State<BoxDetailPage> createState() => _BoxDetailPageState();
}

class _BoxDetailPageState extends State<BoxDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookProvider>().loadBooks(widget.box.id!);
    });
  }

  void _showAddBookSheet() {
    _showBookSheet(null);
  }

  void _showBookSheet(BookModel? existing) {
    final nameController =
        TextEditingController(text: existing?.name ?? '');
    final pageController =
        TextEditingController(text: existing?.pageCount.toString() ?? '');
    String? pdfPath = existing?.pdfPath;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    existing == null ? 'Add Book' : 'Edit Book',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Book Name',
                      prefixIcon: Icon(Icons.book_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: pageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Page Count',
                      prefixIcon: Icon(Icons.pages_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );
                      if (result != null &&
                          result.files.single.path != null) {
                        setSheetState(() {
                          pdfPath = result.files.single.path;
                        });
                      }
                    },
                    icon: const Icon(Icons.upload_file),
                    label: Text(
                      pdfPath != null
                          ? 'PDF: ${pdfPath!.split('/').last}'
                          : 'Upload PDF',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () =>
                              _saveBook(ctx, existing, nameController,
                                  pageController, pdfPath),
                          child:
                              Text(existing == null ? 'Add' : 'Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _saveBook(
    BuildContext ctx,
    BookModel? existing,
    TextEditingController nameController,
    TextEditingController pageController,
    String? pdfPath,
  ) {
    final name = nameController.text.trim();
    if (name.isEmpty) return;
    final pages = int.tryParse(pageController.text.trim()) ?? 0;

    final provider = context.read<BookProvider>();

    if (existing == null) {
      final book = BookModel(
        boxId: widget.box.id!,
        name: name,
        pageCount: pages,
        pdfPath: pdfPath,
        createdAt: DateTime.now().toIso8601String(),
      );
      provider.addBook(book).then((_) {
        Navigator.pop(ctx);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Book "$name" added'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    } else {
      final updated = existing.copyWith(
        name: name,
        pageCount: pages,
        pdfPath: pdfPath,
      );
      provider.updateBook(updated).then((_) {
        Navigator.pop(ctx);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Book updated'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    }
  }

  void _confirmDeleteBook(BookModel book) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Book'),
        content: Text('Delete "${book.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              context
                  .read<BookProvider>()
                  .deleteBook(book.id!, book.boxId)
                  .then((_) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Book "${book.name}" deleted'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              });
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _openPdf(String? path) {
    if (path == null || path.isEmpty) return;
    final file = File(path);
    if (!file.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF file not found'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    OpenFile.open(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.box.name),
        centerTitle: true,
      ),
      body: Consumer<BookProvider>(
        builder: (context, provider, _) {
          final books = provider.books;
          if (books.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.book_outlined,
                    size: 80,
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No books yet',
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
                    'Tap + to add your first book',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.4),
                        ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              return BookCard(
                book: books[index],
                onEdit: () => _showBookSheet(books[index]),
                onDelete: () => _confirmDeleteBook(books[index]),
                onToggleFavorite: () =>
                    context.read<BookProvider>().toggleFavorite(books[index]),
                onOpenPdf: () => _openPdf(books[index].pdfPath),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddBookSheet,
        icon: const Icon(Icons.add),
        label: const Text('Add Book'),
      ),
    );
  }
}
