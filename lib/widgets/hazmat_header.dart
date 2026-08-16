import 'package:flutter/material.dart';
import '../theme/hazmat_theme.dart';

class HazmatHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onBack;
  final VoidCallback? onQuiz;
  final VoidCallback? onSettings;

  const HazmatHeader({
    required this.title,
    this.subtitle = '',
    this.onBack,
    this.onQuiz,
    this.onSettings,
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
                          _HeaderIconButton(
                            icon: Icons.arrow_back_ios,
                            iconSize: 16,
                            color: HMColors.dimText,
                            label: 'Back',
                            onTap: onBack!,
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
                        if (onQuiz != null)
                          _HeaderIconButton(
                            icon: Icons.school_outlined,
                            iconSize: 22,
                            color: HMColors.secondaryText,
                            label: 'Quiz',
                            onTap: onQuiz!,
                          ),
                        if (onSettings != null)
                          _HeaderIconButton(
                            icon: Icons.settings_outlined,
                            iconSize: 22,
                            color: HMColors.secondaryText,
                            label: 'Settings',
                            onTap: onSettings!,
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

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.iconSize,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(child: Icon(icon, size: iconSize, color: color)),
        ),
      ),
    );
  }
}
