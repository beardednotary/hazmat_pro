import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../data/placards_data.dart';
import '../data/un_numbers_data.dart';
import '../theme/hazmat_theme.dart';
import '../widgets/field_card.dart';
import '../widgets/hazmat_header.dart';

class PlacardDetailScreen extends StatelessWidget {
  final Placard placard;

  const PlacardDetailScreen({required this.placard, super.key});

  void _openUnNumber(BuildContext context, String unNumber) {
    final entry = unEntryForNumber(unNumber);
    if (entry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('UN$unNumber isn\'t in the UN Numbers list yet.')),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: HMColors.surface,
      builder: (_) => _UnEntrySheet(entry: entry),
    );
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
                          .map((u) => GestureDetector(
                                onTap: () => _openUnNumber(context, u),
                                child: Container(
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

class _UnEntrySheet extends StatelessWidget {
  final UnEntry entry;
  const _UnEntrySheet({required this.entry});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(entry.displayNumber, style: HMTextStyles.screenTitle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(entry.properShippingName, style: HMTextStyles.bodyText),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Chip(label: 'CLASS ${entry.hazardClass}'),
                if (entry.packingGroup != null) _Chip(label: 'PG ${entry.packingGroup}'),
                _Chip(label: 'GUIDE ${entry.ergGuideNumber}', accent: true),
              ],
            ),
            const SizedBox(height: 14),
            Text(entry.notes, style: HMTextStyles.dimBody.copyWith(height: 1.5)),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool accent;
  const _Chip({required this.label, this.accent = false});

  @override
  Widget build(BuildContext context) {
    final color = accent ? HMColors.hazardYellow : HMColors.secondaryText;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        label,
        style: HMTextStyles.sectionHeader.copyWith(color: color, fontSize: 10, letterSpacing: 0.5),
      ),
    );
  }
}
