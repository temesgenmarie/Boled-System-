import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_app/providers/auth_provider.dart';
import 'package:admin_app/theme/app_theme.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryDark,
                ],
              ),
            ),
            child: DrawerHeader(
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    authState.user?.fullName ?? 'Admin',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    authState.organization?.name ?? 'Organization',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          _DrawerItem(
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
            onTap: () {
              context.go('/dashboard');
              Navigator.pop(context);
            },
          ),
          _DrawerItem(
            icon: Icons.people_outline,
            label: 'Members',
            onTap: () {
              context.go('/members');
              Navigator.pop(context);
            },
          ),
          _DrawerItem(
            icon: Icons.mail_outline,
            label: 'Send Message',
            onTap: () {
              context.go('/messages');
              Navigator.pop(context);
            },
          ),
          _DrawerItem(
            icon: Icons.history,
            label: 'Message History',
            onTap: () {
              context.go('/messages/history');
              Navigator.pop(context);
            },
          ),
          const Divider(height: 24),
          _DrawerItem(
            icon: Icons.person_outline,
            label: 'Profile',
            onTap: () {
              context.go('/profile');
              Navigator.pop(context);
            },
          ),
          _DrawerItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () {
              context.go('/settings');
              Navigator.pop(context);
            },
          ),
          _DrawerItem(
            icon: Icons.info_outline,
            label: 'About',
            onTap: () {
              context.go('/about');
              Navigator.pop(context);
            },
          ),
          const Divider(height: 24),
          _DrawerItem(
            icon: Icons.logout,
            label: 'Logout',
            onTap: () async {
              await ref.read(authStateProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
                Navigator.pop(context);
              }
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppTheme.errorColor : AppTheme.primaryColor,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isDestructive ? AppTheme.errorColor : AppTheme.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
