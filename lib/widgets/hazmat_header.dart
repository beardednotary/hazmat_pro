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
      color: const Color(0xFF111111),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children: [
                Text(
                  'HAZMAT PRO',
                  style: HMTextStyles.sectionHeader.copyWith(
                    color: HMColors.hazardYellow,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: HMColors.hazardYellow,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'FIELD REFERENCE',
                  style: HMTextStyles.sectionHeader,
                ),
                const Spacer(),
                const _HazardStripe(),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: HMColors.panelBg,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: HMColors.panelBorder, width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x30FFD400),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (onBack != null) ...[
                    GestureDetector(
                      onTap: onBack,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 16,
                          color: HMColors.dimText,
                        ),
                      ),
                    ),
                  ],
                  Text(title, style: HMTextStyles.placardDisplay()),
                  const Spacer(),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: HMTextStyles.sectionHeader.copyWith(
                        color: const Color(0xFF4A4000),
                        fontSize: 9,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: HMColors.divider),
        ],
      ),
    );
  }
}

class _HazardStripe extends StatelessWidget {
  const _HazardStripe();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        return Container(
          margin: const EdgeInsets.only(left: 3),
          width: 4,
          height: 6.0 + i * 3,
          decoration: BoxDecoration(
            color: i.isEven
                ? HMColors.hazardYellow
                : HMColors.hazardYellow.withAlpha(60),
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }
}
