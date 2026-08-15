import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../data/placards_data.dart';
import '../theme/hazmat_theme.dart';
import '../widgets/field_card.dart';
import '../widgets/hazmat_header.dart';

class PlacardDetailScreen extends StatelessWidget {
  final Placard placard;

  const PlacardDetailScreen({required this.placard, super.key});

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
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: HMColors.surface,
                      border: Border.all(color: HMColors.border, width: 1.5),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 140,
                          height: 140,
                          child: SvgPicture.asset(placard.assetPath, fit: BoxFit.contain),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          placard.name.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: HMTextStyles.sectionHeader.copyWith(
                            color: HMColors.primaryText,
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
