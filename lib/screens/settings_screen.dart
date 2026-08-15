import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/history_service.dart';
import '../services/review_service.dart';
import '../theme/hazmat_theme.dart';
import '../widgets/field_card.dart';
import '../widgets/hazmat_header.dart';

// Verification pass recorded in lib/data/placards_data.dart and
// lib/data/un_numbers_data.dart — update this whenever that pass is redone.
const _kReferenceDataVerifiedOn = 'August 14, 2026';

// TODO: replace with a real support inbox before shipping.
const _kSupportEmail = 'support@dahvio.com';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _reportBug(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: _kSupportEmail,
      query: 'subject=${Uri.encodeComponent('HazMat Pro — Bug / Misclassification Report')}',
    );
    if (!await launchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open mail app.')),
        );
      }
    }
  }

  Future<void> _clearHistory(BuildContext context) async {
    await HistoryService.instance.clear();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Identify history cleared.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HMColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            HazmatHeader(
              title: 'SETTINGS',
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                children: [
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      final info = snapshot.data;
                      return FieldCard(
                        label: 'ABOUT',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('HazMat Pro', style: HMTextStyles.termLabel),
                            const SizedBox(height: 4),
                            Text(
                              info == null
                                  ? 'Loading version…'
                                  : 'Version ${info.version} (build ${info.buildNumber})',
                              style: HMTextStyles.dimBody,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  FieldCard(
                    label: 'REFERENCE DATA',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Placards and UN number guide data verified against ERG2024 and 49 CFR §172.101 as of $_kReferenceDataVerifiedOn.',
                          style: HMTextStyles.bodyText.copyWith(height: 1.6),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Always confirm against the current official guidebook before acting on this data in the field.',
                          style: HMTextStyles.dimBody.copyWith(fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 14),
                        _SettingsRow(
                          icon: Icons.delete_outline,
                          label: 'Clear Identify History',
                          onTap: () => _clearHistory(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  FieldCard(
                    label: 'SUPPORT',
                    child: Column(
                      children: [
                        _SettingsRow(
                          icon: Icons.flag_outlined,
                          label: 'Report a Bug or Misclassification',
                          onTap: () => _reportBug(context),
                        ),
                        Container(height: 1, color: HMColors.divider),
                        _SettingsRow(
                          icon: Icons.star_outline,
                          label: 'Rate HazMat Pro',
                          onTap: () => ReviewService.instance.requestExplicit(),
                        ),
                        Container(height: 1, color: HMColors.divider),
                        _SettingsRow(
                          icon: Icons.ios_share,
                          label: 'Share HazMat Pro',
                          onTap: () => Share.share(
                            'HazMat Pro — a field reference for DOT placards, UN numbers, '
                            'and GHS/SDS terminology.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsRow({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 18, color: HMColors.hazardYellow),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: HMTextStyles.bodyText)),
            const Icon(Icons.chevron_right, size: 18, color: HMColors.dimText),
          ],
        ),
      ),
    );
  }
}
