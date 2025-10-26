import 'package:flutter/material.dart';
import 'package:admin_app/theme/app_theme.dart';
import 'package:admin_app/widgets/gradient_background.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: GradientBackground(
        child: ListView(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          children: [
            _buildSectionHeader('Appearance'),
            _buildSettingCard(
              title: 'Dark Mode',
              subtitle: 'Enable dark theme for the app',
              icon: Icons.dark_mode_outlined,
              trailing: Switch(
                value: _darkMode,
                onChanged: (value) => setState(() => _darkMode = value),
                activeColor: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),

            _buildSectionHeader('Notifications'),
            _buildSettingCard(
              title: 'Push Notifications',
              subtitle: 'Receive push notifications',
              icon: Icons.notifications_outlined,
              trailing: Switch(
                value: _notifications,
                onChanged: (value) => setState(() => _notifications = value),
                activeColor: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              title: 'Email Notifications',
              subtitle: 'Receive email updates',
              icon: Icons.email_outlined,
              trailing: Switch(
                value: _emailNotifications,
                onChanged: (value) => setState(() => _emailNotifications = value),
                activeColor: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              title: 'SMS Notifications',
              subtitle: 'Receive SMS alerts',
              icon: Icons.sms_outlined,
              trailing: Switch(
                value: _smsNotifications,
                onChanged: (value) => setState(() => _smsNotifications = value),
                activeColor: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),

            _buildSectionHeader('About'),
            _buildSettingCard(
              title: 'App Version',
              subtitle: '1.0.0',
              icon: Icons.info_outlined,
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              title: 'Privacy Policy',
              subtitle: 'View our privacy policy',
              icon: Icons.privacy_tip_outlined,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              title: 'Terms of Service',
              subtitle: 'View terms and conditions',
              icon: Icons.description_outlined,
              onTap: () {},
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required IconData icon,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 24),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: trailing ?? (onTap != null
            ? Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textSecondary)
            : null),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
