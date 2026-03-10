import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/category_model.dart';
import '../../providers/category_provider.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/loading_indicator.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<CategoryProvider>().fetchCategories());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();

    final incomeCategories =
        provider.categories.where((c) => c.isIncome).toList();
    final expenseCategories =
        provider.categories.where((c) => c.isExpense).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primary,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.textSecondary,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.arrow_downward_rounded, size: 18, color: AppTheme.cardBg),
                  SizedBox(width: 6),
                  Text('Income',style: TextStyle(color: AppTheme.cardBg),),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.arrow_upward_rounded, size: 18, color: AppTheme.cardBg),
                  SizedBox(width: 6),
                  Text('Expense',style: TextStyle(color: AppTheme.cardBg)),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primary,
        onPressed: () async {
          // Pass current tab type as default
          final defaultType =
              _tabController.index == 0 ? 'income' : 'expense';
          await Navigator.pushNamed(
            context,
            AppRoutes.addEditCategory,
            arguments: {'defaultType': defaultType},
          );
          if (context.mounted) {
            context.read<CategoryProvider>().fetchCategories();
          }
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Category',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: provider.isLoading
          ? const LoadingIndicator()
          : TabBarView(
              controller: _tabController,
              children: [
                _CategoryTab(
                  categories: incomeCategories,
                  type: 'income',
                  emptyMessage: 'No income categories yet.',
                  accentColor: AppTheme.income,
                ),
                _CategoryTab(
                  categories: expenseCategories,
                  type: 'expense',
                  emptyMessage: 'No expense categories yet.',
                  accentColor: AppTheme.expense,
                ),
              ],
            ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  final List<CategoryModel> categories;
  final String type;
  final String emptyMessage;
  final Color accentColor;

  const _CategoryTab({
    required this.categories,
    required this.type,
    required this.emptyMessage,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              type == 'income'
                  ? Icons.savings_outlined
                  : Icons.shopping_bag_outlined,
              size: 56,
              color: AppTheme.textSecondary.withOpacity(0.4),
            ),
            const SizedBox(height: 12),
            Text(
              emptyMessage,
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemCount: categories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final cat = categories[i];
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(cat.icon, style: const TextStyle(fontSize: 22)),
              ),
            ),
            title: Text(
              cat.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              type == 'income' ? 'Income' : 'Expense',
              style: TextStyle(
                color: accentColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionButton(
                  icon: Icons.edit_outlined,
                  color: AppTheme.primary,
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      AppRoutes.addEditCategory,
                      arguments: cat,
                    );
                    if (context.mounted) {
                      context.read<CategoryProvider>().fetchCategories();
                    }
                  },
                ),
                const SizedBox(width: 4),
                _ActionButton(
                  icon: Icons.delete_outline,
                  color: AppTheme.expense,
                  onTap: () => _confirmDelete(context, cat.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Category',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CategoryProvider>().deleteCategory(id);
            },
            child: Text(
              'Delete',
              style: TextStyle(
                  color: AppTheme.expense, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}