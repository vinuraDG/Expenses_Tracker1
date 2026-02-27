import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final email = auth.user?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const CircleAvatar(
              radius: 48,
              backgroundColor: AppTheme.primary,
              child: Icon(
                Icons.person_4_rounded,
                size: 52,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              email,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 40),
            ListTile(
              leading: const Icon(
                Icons.category_outlined,
                color: AppTheme.primary,
              ),
              title: const Text(
                'Manage Categories',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.categoryList),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: AppTheme.expense,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: AppTheme.expense,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onTap: () => _confirmLogout(context),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(
          child: Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              textAlign: TextAlign.center,
            ),
          ),
          TextButton(
            onPressed: () async {
              
              final authProvider = context.read<AuthProvider>();
              Navigator.pop(context); 
              await authProvider.logout(context); 
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppTheme.expense),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}