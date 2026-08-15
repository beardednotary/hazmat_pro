import 'package:flutter/material.dart';
import '../data/un_numbers_data.dart';
import '../services/review_service.dart';
import '../services/star_service.dart';
import '../theme/hazmat_theme.dart';
import '../widgets/hazmat_search_bar.dart';

class UnNumbersScreen extends StatefulWidget {
  const UnNumbersScreen({super.key});

  @override
  State<UnNumbersScreen> createState() => _UnNumbersScreenState();
}

class _UnNumbersScreenState extends State<UnNumbersScreen> {
  final _controller = TextEditingController();
  List<UnEntry> _results = kUnNumbers;

  @override
  void initState() {
    super.initState();
    StarService.instance.addListener(_rebuild);
  }

  @override
  void dispose() {
    StarService.instance.removeListener(_rebuild);
    _controller.dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  void _onSearch(String q) {
    setState(() {
      _results = q.isEmpty
          ? kUnNumbers
          : kUnNumbers.where((e) => e.matchesQuery(q)).toList();
    });
    if (q.isNotEmpty && _results.isNotEmpty) {
      ReviewService.instance.onSearchSuccess();
    }
  }

  Future<void> _onStarTap(String unNumber) async {
    await StarService.instance.toggle(unNumber);
    if (StarService.instance.count >= 3) {
      ReviewService.instance.onStarThreshold();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: HazmatSearchBar(
            controller: _controller,
            hint: 'Search UN number, name, or ERG guide…',
            onChanged: _onSearch,
          ),
        ),
        if (_results.isEmpty)
          Expanded(
            child: Center(
              child: Text('NO RESULTS', style: HMTextStyles.sectionHeader),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 32),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final entry = _results[index];
                return _UnTile(
                  entry: entry,
                  isStarred: StarService.instance.isStarred(entry.unNumber),
                  onStar: () => _onStarTap(entry.unNumber),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _UnTile extends StatelessWidget {
  final UnEntry entry;
  final bool isStarred;
  final VoidCallback onStar;

  const _UnTile({
    required this.entry,
    required this.isStarred,
    required this.onStar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        color: HMColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isStarred ? HMColors.hazardYellow.withAlpha(60) : HMColors.divider,
          width: isStarred ? 1.5 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(entry.displayNumber, style: HMTextStyles.codeLabel.copyWith(fontSize: 14)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.properShippingName, style: HMTextStyles.bodyText),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: [
                    _Badge(label: 'CLASS ${entry.hazardClass}'),
                    if (entry.packingGroup != null) _Badge(label: 'PG ${entry.packingGroup}'),
                    _Badge(label: 'GUIDE ${entry.ergGuideNumber}', accent: true),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onStar,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 4, 0),
              child: Icon(
                isStarred ? Icons.star : Icons.star_outline,
                size: 18,
                color: isStarred
                    ? HMColors.hazardYellow.withAlpha(200)
                    : HMColors.dimText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final bool accent;
  const _Badge({required this.label, this.accent = false});

  @override
  Widget build(BuildContext context) {
    final color = accent ? HMColors.hazardYellow : HMColors.secondaryText;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        label,
        style: HMTextStyles.sectionHeader.copyWith(color: color, fontSize: 8.5, letterSpacing: 0.5),
      ),
    );
  }
}
