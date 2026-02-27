import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';

import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/category_provider.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../widgets/transaction_tile.dart';
import '../../widgets/loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<String> _tabLabels = const [
    "Dashboard",
    "Transactions",
    "Categories",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    await context.read<CategoryProvider>().fetchCategories();
    await context.read<TransactionProvider>().fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker',style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_4_rounded),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
        ],
      ),

      body: _buildBody(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: () async {
          await Navigator.pushNamed(context, AppRoutes.addEditTransaction);
          _loadData();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      bottomNavigationBar: MotionTabBar(
        initialSelectedTab: _tabLabels[_selectedIndex],

        labels: _tabLabels,

        icons: const [
          Icons.dashboard,
          Icons.receipt_long,
          Icons.category,
        ],

        onTabItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },

        tabSize: 50,
        tabBarHeight: 60,

        textStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),

        tabIconColor: Colors.grey,
        tabIconSelectedColor: Colors.white,
        tabSelectedColor: AppTheme.primary,
        tabBarColor: Colors.white,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _dashboardTab();
      case 1:
        return _transactionsTab();
      case 2:
        return _categoriesTab();
      default:
        return _dashboardTab();
    }
  }

  Widget _dashboardTab() {
    final txProvider = context.watch<TransactionProvider>();

    if (txProvider.isLoading) return const LoadingIndicator();

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _summaryCard(txProvider),
            const SizedBox(height: 8),
            _monthPicker(txProvider),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),
            _transactionList(txProvider, limit: 5),
          ],
        ),
      ),
    );
  }

  Widget _transactionsTab() {
    final txProvider = context.watch<TransactionProvider>();

    if (txProvider.isLoading) return const LoadingIndicator();

    return Column(
      children: [
        _monthPicker(txProvider),
        Expanded(
          child: SingleChildScrollView(
            child: _transactionList(txProvider),
          ),
        ),
      ],
    );
  }

  Widget _categoriesTab() {
    final catProvider = context.watch<CategoryProvider>();

    if (catProvider.isLoading) {
      return const LoadingIndicator();
    }

    if (catProvider.categories.isEmpty) {
      return const Center(
        child: Text("No categories found"),
      );
    }

    return ListView.builder(
      itemCount: catProvider.categories.length,
      itemBuilder: (context, index) {
        final category = catProvider.categories[index];

        return ListTile(
          leading: const Icon(Icons.category),
          title: Text(category.name),
        );
      },
    );
  }

  Widget _summaryCard(TransactionProvider txProvider) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFF9C97FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            AppDateUtils.monthYear(txProvider.selectedMonth),
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${txProvider.balance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Balance',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  'Income',
                  txProvider.totalIncome,
                  Icons.arrow_downward,
                  AppTheme.income,
                ),
              ),
              Container(width: 1, height: 40, color: Colors.white30),
              Expanded(
                child: _summaryItem(
                  'Expense',
                  txProvider.totalExpense,
                  Icons.arrow_upward,
                  Colors.redAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(
      String label, double amount, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _monthPicker(TransactionProvider txProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
          Text(
            AppDateUtils.monthYear(txProvider.selectedMonth),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              final m = txProvider.selectedMonth;
              txProvider.changeMonth(DateTime(m.year, m.month + 1));
            },
          ),
        ],
      ),
    );
  }

  Widget _transactionList(TransactionProvider txProvider, {int? limit}) {
    final catProvider = context.watch<CategoryProvider>();

    final list = limit != null && txProvider.transactions.length > limit
        ? txProvider.transactions.sublist(0, limit)
        : txProvider.transactions;

    if (list.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No transactions this month.',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final t = list[i];
        final cat = catProvider.findById(t.categoryId);

        return TransactionTile(
          transaction: t,
          category: cat,
          onEdit: () async {
            await Navigator.pushNamed(
              context,
              AppRoutes.addEditTransaction,
              arguments: t,
            );
            _loadData();
          },
          onDelete: () => _confirmDelete(t.id),
        );
      },
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Transaction'),
        content:
            const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<TransactionProvider>().deleteTransaction(id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.expense),
            ),
          ),
        ],
      ),
    );
  }
}