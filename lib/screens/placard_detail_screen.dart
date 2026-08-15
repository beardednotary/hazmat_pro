import 'package:flutter/material.dart';
import '../data/placards_data.dart';
import '../theme/hazmat_theme.dart';
import '../widgets/hazmat_header.dart';

class PlacardDetailScreen extends StatelessWidget {
  final Placard placard;

  const PlacardDetailScreen({required this.placard, super.key});

  Color get _bg => Color(int.parse('0x${placard.colorHex}'));

  Color get _fg {
    final luminance = _bg.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
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
              title: 'CLASS ${placard.division}',
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    decoration: BoxDecoration(
                      color: _bg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: HMColors.border, width: 1.5),
                    ),
                    child: Column(
                      children: [
                        Text(
                          placard.division,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: _fg,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          placard.name.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: HMTextStyles.sectionHeader.copyWith(
                            color: _fg,
                            fontSize: 12,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _InfoCard(
                    label: 'SYMBOL',
                    body: placard.symbolDescription,
                  ),
                  const SizedBox(height: 10),
                  _InfoCard(
                    label: 'DESCRIPTION',
                    body: placard.description,
                  ),
                  const SizedBox(height: 10),
                  _InfoCard(
                    label: 'HANDLING NOTES',
                    body: placard.handlingNotes,
                    accent: HMColors.dangerRed,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: HMColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: HMColors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'COMMON UN NUMBERS',
                          style: HMTextStyles.sectionHeader.copyWith(
                            color: HMColors.hazardYellow,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: placard.commonUnNumbers
                              .map((u) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: HMColors.panelBg,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          color: HMColors.panelBorder),
                                    ),
                                    child: Text(
                                      'UN$u',
                                      style: HMTextStyles.codeLabel
                                          .copyWith(fontSize: 13),
                                    ),
                                  ))
                              .toList(),
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

class _InfoCard extends StatelessWidget {
  final String label;
  final String body;
  final Color accent;

  const _InfoCard({
    required this.label,
    required this.body,
    this.accent = HMColors.hazardYellow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HMColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accent.withAlpha(60), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: accent.withAlpha(20),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
            ),
            child: Text(
              label,
              style: HMTextStyles.sectionHeader.copyWith(
                color: accent,
                fontSize: 10,
                letterSpacing: 2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(
              body,
              style: const TextStyle(
                fontSize: 13,
                color: HMColors.primaryText,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
