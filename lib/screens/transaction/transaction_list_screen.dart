import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/category_provider.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/transaction_tile.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().fetchCategories();
      context.read<TransactionProvider>().fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final catProvider = context.watch<CategoryProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: () async {
          await Navigator.pushNamed(context, AppRoutes.addEditTransaction);
          context.read<TransactionProvider>().fetchTransactions();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Month picker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    final m = txProvider.selectedMonth;
                    txProvider.changeMonth(DateTime(m.year, m.month - 1));
                  },
                ),
                Text(AppDateUtils.monthYear(txProvider.selectedMonth),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary)),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    final m = txProvider.selectedMonth;
                    txProvider.changeMonth(DateTime(m.year, m.month + 1));
                  },
                ),
              ],
            ),
          ),
          if (txProvider.isLoading)
            const Expanded(child: LoadingIndicator())
          else if (txProvider.transactions.isEmpty)
            const Expanded(
              child: Center(
                  child: Text('No transactions this month.',
                      style: TextStyle(color: AppTheme.textSecondary))),
            )
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => txProvider.fetchTransactions(),
                child: ListView.builder(
                  itemCount: txProvider.transactions.length,
                  itemBuilder: (_, i) {
                    final t = txProvider.transactions[i];
                    final cat = catProvider.findById(t.categoryId);
                    return TransactionTile(
                      transaction: t,
                      category: cat,
                      onEdit: () async {
                        await Navigator.pushNamed(
                            context, AppRoutes.addEditTransaction,
                            arguments: t);
                        context.read<TransactionProvider>().fetchTransactions();
                      },
                      onDelete: () => _confirmDelete(t.id),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<TransactionProvider>().deleteTransaction(id);
            },
            child:
                const Text('Delete', style: TextStyle(color: AppTheme.expense)),
          ),
        ],
      ),
    );
  }
}