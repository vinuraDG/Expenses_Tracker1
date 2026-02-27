import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/category_provider.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/loading_indicator.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<CategoryProvider>().fetchCategories());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: () async {
          await Navigator.pushNamed(context, AppRoutes.addEditCategory);
          context.read<CategoryProvider>().fetchCategories();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: provider.isLoading
          ? const LoadingIndicator()
          : provider.categories.isEmpty
              ? const Center(
                  child: Text('No categories yet.',
                      style: TextStyle(color: AppTheme.textSecondary)))
              : ListView.builder(
                  itemCount: provider.categories.length,
                  itemBuilder: (_, i) {
                    final cat = provider.categories[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.primary.withOpacity(0.1),
                        child: Text(cat.icon,
                            style: const TextStyle(fontSize: 20)),
                      ),
                      title: Text(cat.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined,
                                color: AppTheme.primary),
                            onPressed: () async {
                              await Navigator.pushNamed(
                                  context, AppRoutes.addEditCategory,
                                  arguments: cat);
                              context.read<CategoryProvider>().fetchCategories();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: AppTheme.expense),
                            onPressed: () => _confirmDelete(context, cat.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Delete this category?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CategoryProvider>().deleteCategory(id);
            },
            child:
                const Text('Delete', style: TextStyle(color: AppTheme.expense)),
          ),
        ],
      ),
    );
  }
}