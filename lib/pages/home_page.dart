import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/box_model.dart';
import '../providers/box_provider.dart';
import '../widgets/box_card.dart';
import 'box_detail_page.dart';
import 'search_page.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BoxProvider>().loadBoxes();
    });
  }

  void _showCreateBoxDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Box'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Box Name',
            hintText: 'Enter a name for the box',
            prefixIcon: Icon(Icons.archive_outlined),
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => _createBox(ctx, controller),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => _createBox(ctx, controller),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _createBox(BuildContext ctx, TextEditingController controller) {
    final name = controller.text.trim();
    if (name.isEmpty) return;
    context.read<BoxProvider>().addBox(name).then((_) {
      Navigator.pop(ctx);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Box "$name" created'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aram Archive'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchPage()),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.favorite_outline),
          tooltip: 'Favorites',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FavoritesPage()),
          ),
        ),
      ),
      body: Consumer<BoxProvider>(
        builder: (context, provider, _) {
          final boxes = provider.boxes;
          if (boxes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.archive_outlined,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No boxes yet',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to create your first box',
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
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: boxes.length,
            itemBuilder: (context, index) {
              return BoxCard(
                box: boxes[index],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BoxDetailPage(box: boxes[index]),
                  ),
                ).then((_) => context.read<BoxProvider>().loadBoxes()),
                onEdit: () => _showEditBoxDialog(boxes[index]),
                onDelete: () => _confirmDeleteBox(boxes[index]),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateBoxDialog,
        icon: const Icon(Icons.add),
        label: const Text('New Box'),
      ),
    );
  }

  void _showEditBoxDialog(BoxModel box) {
    final controller = TextEditingController(text: box.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Box'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Box Name',
            prefixIcon: Icon(Icons.archive_outlined),
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => _updateBox(ctx, box, controller),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => _updateBox(ctx, box, controller),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _updateBox(BuildContext ctx, BoxModel box, TextEditingController controller) {
    final name = controller.text.trim();
    if (name.isEmpty) return;
    context.read<BoxProvider>().updateBox(box.copyWith(name: name)).then((_) {
      Navigator.pop(ctx);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Box updated'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void _confirmDeleteBox(BoxModel box) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Box'),
        content: Text(
          'Delete "${box.name}"? All books inside will also be deleted.',
        ),
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
              context.read<BoxProvider>().deleteBox(box.id!).then((_) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Box "${box.name}" deleted'),
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
}
