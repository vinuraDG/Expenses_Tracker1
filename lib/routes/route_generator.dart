import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../screens/home/home_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/category/category_list_screen.dart';
import '../screens/category/add_edit_category_screen.dart';
import '../screens/transaction/add_edit_transaction_screen.dart';
import '../screens/profile/profile_screen.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case AppRoutes.home:
        return _route(const HomeScreen());

      case AppRoutes.login:
        return _route(const LoginScreen());

      case AppRoutes.register:
        return _route(const RegisterScreen());

      case AppRoutes.categoryList:
        return _route(const CategoryListScreen());

      case AppRoutes.addEditCategory:
        // Arguments can be CategoryModel (edit) or Map<String, dynamic> (add with default type)
        return MaterialPageRoute(
          builder: (_) => const AddEditCategoryScreen(),
          settings: settings, // pass settings so screen can read args via ModalRoute
        );

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