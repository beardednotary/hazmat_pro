import 'package:flutter/material.dart';
import '../data/placards_data.dart';
import '../theme/hazmat_theme.dart';
import '../widgets/field_card.dart';
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
                  FieldCard(
                    label: 'SYMBOL',
                    child: Text(
                      placard.symbolDescription,
                      style: HMTextStyles.dimBody.copyWith(height: 1.6),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FieldCard(
                    label: 'DESCRIPTION',
                    child: Text(
                      placard.description,
                      style: HMTextStyles.bodyText.copyWith(height: 1.6),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FieldCard(
                    label: 'HANDLING NOTES',
                    accent: HMColors.dangerRed,
                    child: Text(
                      placard.handlingNotes,
                      style: HMTextStyles.bodyText.copyWith(height: 1.6),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FieldCard(
                    label: 'COMMON UN NUMBERS',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: placard.commonUnNumbers
                          .map((u) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: HMColors.headerBg,
                                  border: Border.all(color: HMColors.border),
                                ),
                                child: Text(
                                  'UN$u',
                                  style: HMTextStyles.codeLabel
                                      .copyWith(fontSize: 13),
                                ),
                              ))
                          .toList(),
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
