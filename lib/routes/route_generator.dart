import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../screens/category/category_list_screen.dart';
import '../screens/category/add_edit_category_screen.dart';
import '../screens/transaction/transaction_list_screen.dart';
import '../screens/transaction/add_edit_transaction_screen.dart';
import '../screens/profile/profile_screen.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.categoryList:
        return _route(const CategoryListScreen());

      case AppRoutes.addEditCategory:
        final category = settings.arguments as CategoryModel?;
        return _route(AddEditCategoryScreen(category: category));

      case AppRoutes.transactionList:
        return _route(const TransactionListScreen());

      case AppRoutes.addEditTransaction:
        final transaction = settings.arguments as TransactionModel?;
        return _route(AddEditTransactionScreen(transaction: transaction));

      case AppRoutes.profile:
        return _route(const ProfileScreen());

      default:
        return _route(const Scaffold(
          body: Center(child: Text('Page not found')),
        ));
    }
  }

  static MaterialPageRoute _route(Widget page) =>
      MaterialPageRoute(builder: (_) => page);
}