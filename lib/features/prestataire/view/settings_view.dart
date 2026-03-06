import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_card.dart';

class ProviderSettingsView extends StatefulWidget {
  const ProviderSettingsView({super.key});

  @override
  State<ProviderSettingsView> createState() => _ProviderSettingsViewState();
}

class _ProviderSettingsViewState extends State<ProviderSettingsView> {
  // Notification toggles
  bool _newBookingsNotif = true;
  bool _confirmationsNotif = true;
  bool _messagesNotif = true;
  bool _reviewsNotif = true;
  bool _marketingNotif = false;

  // Privacy toggles
  bool _profileVisible = true;
  bool _searchVisible = true;

  // App settings
  String _theme = 'Light';
  String _language = 'Français';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: ListView(
        // MODIFIÉ: Ajouté padding bottom pour la barre système
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 40,
        ),
        children: [
          // ACCOUNT SECTION
          _buildSectionHeader('Account'),
          _buildSettingItem(
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your password',
            onTap: () => _showChangePasswordDialog(),
          ),
          _buildSettingItem(
            icon: Icons.email_outlined,
            title: 'Email Preferences',
            subtitle: 'Manage email notifications',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Email preferences - Coming soon')),
              );
            },
          ),
          _buildSettingItem(
            icon: Icons.verified_user_outlined,
            title: 'Verification & Security',
            subtitle: 'ID verification, 2FA',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Security settings - Coming soon')),
              );
            },
          ),
          Divider(height: 1, thickness: 8, color: AppColors.background),

          // NOTIFICATIONS SECTION
          _buildSectionHeader('Notifications'),
          _buildSwitchItem(
            icon: Icons.calendar_today,
            title: 'New Bookings',
            subtitle: 'Get notified of new booking requests',
            value: _newBookingsNotif,
            onChanged: (v) => setState(() => _newBookingsNotif = v),
          ),
          _buildSwitchItem(
            icon: Icons.check_circle_outline,
            title: 'Confirmations',
            subtitle: 'Booking confirmations and updates',
            value: _confirmationsNotif,
            onChanged: (v) => setState(() => _confirmationsNotif = v),
          ),
          _buildSwitchItem(
            icon: Icons.chat_bubble_outline,
            title: 'Messages',
            subtitle: 'New messages from clients',
            value: _messagesNotif,
            onChanged: (v) => setState(() => _messagesNotif = v),
          ),
          _buildSwitchItem(
            icon: Icons.star_outline,
            title: 'Reviews',
            subtitle: 'When clients leave reviews',
            value: _reviewsNotif,
            onChanged: (v) => setState(() => _reviewsNotif = v),
          ),
          _buildSwitchItem(
            icon: Icons.campaign_outlined,
            title: 'Marketing',
            subtitle: 'Promotions and tips',
            value: _marketingNotif,
            onChanged: (v) => setState(() => _marketingNotif = v),
          ),
          Divider(height: 1, thickness: 8, color: AppColors.background),

          // PRIVACY SECTION
          _buildSectionHeader('Privacy'),
          _buildSwitchItem(
            icon: Icons.visibility_outlined,
            title: 'Profile Visibility',
            subtitle: 'Show profile to clients',
            value: _profileVisible,
            onChanged: (v) => setState(() => _profileVisible = v),
          ),
          _buildSwitchItem(
            icon: Icons.search,
            title: 'Appear in Search',
            subtitle: 'Visible in client searches',
            value: _searchVisible,
            onChanged: (v) => setState(() => _searchVisible = v),
          ),
          _buildSettingItem(
            icon: Icons.shield_outlined,
            title: 'Data & Permissions',
            subtitle: 'Manage your data',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Data settings - Coming soon')),
              );
            },
          ),
          Divider(height: 1, thickness: 8, color: AppColors.background),

          // PAYMENTS SECTION
          _buildSectionHeader('Payments'),
          _buildSettingItem(
            icon: Icons.account_balance,
            title: 'Bank Account',
            subtitle: 'Manage payout account',
            onTap: () => _showBankAccountDialog(),
          ),
          _buildSettingItem(
            icon: Icons.schedule,
            title: 'Payout Schedule',
            subtitle: 'Weekly automatic payouts',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Payout schedule - Coming soon')),
              );
            },
          ),
          _buildSettingItem(
            icon: Icons.receipt_long,
            title: 'Transaction History',
            subtitle: 'View all transactions',
            onTap: () {
              Navigator.pushNamed(context, '/earnings'); // Navigate to Earnings
            },
          ),
          Divider(height: 1, thickness: 8, color: AppColors.background),

          // APP SETTINGS SECTION
          _buildSectionHeader('App Settings'),
          _buildSelectItem(
            icon: Icons.palette_outlined,
            title: 'Theme',
            subtitle: _theme,
            onTap: () => _showThemeSelector(),
          ),
          _buildSelectItem(
            icon: Icons.language,
            title: 'Language',
            subtitle: _language,
            onTap: () => _showLanguageSelector(),
          ),
          _buildSettingItem(
            icon: Icons.straighten,
            title: 'Units',
            subtitle: 'Metric (km, kg)',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Units settings - Coming soon')),
              );
            },
          ),
          Divider(height: 1, thickness: 8, color: AppColors.background),

          // DANGER ZONE
          _buildSectionHeader('Danger Zone', color: AppColors.error),
          _buildSettingItem(
            icon: Icons.delete_forever,
            title: 'Delete Account',
            subtitle: 'Permanently delete your account',
            onTap: () => _showDeleteAccountDialog(),
            isDanger: true,
          ),
          // MODIFIÉ: Removed extra SizedBox as bottom padding handles it now
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {Color? color}) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color ?? AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: AppColors.surface,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (isDanger ? AppColors.error : AppColors.providerPrimary)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isDanger ? AppColors.error : AppColors.providerPrimary,
                size: 20,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isDanger ? AppColors.error : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.providerPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.providerPrimary, size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: AppColors.providerPrimary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: AppColors.surface,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.providerPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.providerPrimary, size: 20),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.providerPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Password updated successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showBankAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Bank Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Account',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.providerPrimary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bank Populaire',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'IBAN: MA** **** **** **** 5678',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Update bank account - Coming soon')),
              );
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showThemeSelector() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,  // AJOUTÉ
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Theme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            RadioListTile<String>(
              title: Text('Light'),
              value: 'Light',
              groupValue: _theme,
              onChanged: (v) {
                setState(() => _theme = v!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('Dark'),
              subtitle: Text('Coming soon'),
              value: 'Dark',
              groupValue: _theme,
              onChanged: null,
            ),
            RadioListTile<String>(
              title: Text('System'),
              subtitle: Text('Coming soon'),
              value: 'System',
              groupValue: _theme,
              onChanged: null,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,  // AJOUTÉ
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            RadioListTile<String>(
              title: Text('Français'),
              value: 'Français',
              groupValue: _language,
              onChanged: (v) {
                setState(() => _language = v!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('العربية'),
              value: 'العربية',
              groupValue: _language,
              onChanged: (v) {
                setState(() => _language = v!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('English'),
              value: 'English',
              groupValue: _language,
              onChanged: (v) {
                setState(() => _language = v!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning, color: AppColors.error),
            SizedBox(width: 8),
            Text('Delete Account'),
          ],
        ),
        content: Text(
          'This action is permanent and cannot be undone. All your data, bookings, and earnings will be deleted.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Account deletion - Contact support'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}