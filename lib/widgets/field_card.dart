import 'package:flutter/material.dart';
import '../theme/hazmat_theme.dart';

/// Flat card with a colored left-edge accent stripe. The shared building
/// block for the app's "field tool" look — no gradients, no glow, just a
/// hazard-stripe accent doing the work color does on a placard.
class FieldCard extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color accent;
  final Widget child;

  const FieldCard({
    required this.label,
    required this.child,
    this.icon,
    this.accent = HMColors.hazardYellow,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HMColors.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border(
          top: const BorderSide(color: HMColors.divider),
          right: const BorderSide(color: HMColors.divider),
          bottom: const BorderSide(color: HMColors.divider),
          left: BorderSide(color: accent, width: 4),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: accent),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: HMTextStyles.sectionHeader.copyWith(
                  color: accent,
                  fontSize: 10,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
