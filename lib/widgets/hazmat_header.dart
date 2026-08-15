import 'package:flutter/material.dart';
import '../theme/hazmat_theme.dart';

class HazmatHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onBack;

  const HazmatHeader({
    required this.title,
    this.subtitle = '',
    this.onBack,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HMColors.headerBg,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: HMColors.hazardYellow),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 16, 0),
                    child: Text(
                      'HAZMAT PRO',
                      style: HMTextStyles.sectionHeader.copyWith(
                        color: HMColors.hazardYellow,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 16, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (onBack != null)
                          GestureDetector(
                            onTap: onBack,
                            child: const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 16,
                                color: HMColors.dimText,
                              ),
                            ),
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: HMTextStyles.screenTitle()),
                              if (subtitle.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  subtitle,
                                  style: HMTextStyles.sectionHeader.copyWith(
                                    color: HMColors.secondaryText,
                                    fontSize: 9.5,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 1, color: HMColors.divider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
