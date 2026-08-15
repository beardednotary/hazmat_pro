import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../data/placards_data.dart';
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
  String _query = '';
  bool _starredOnly = false;

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

  List<UnEntry> get _visibleResults {
    var results = _query.isEmpty
        ? kUnNumbers
        : kUnNumbers.where((e) => e.matchesQuery(_query)).toList();
    if (_starredOnly) {
      results = results.where((e) => StarService.instance.isStarred(e.unNumber)).toList();
    }
    return results;
  }

  void _onSearch(String q) {
    setState(() => _query = q);
    if (q.isNotEmpty && _visibleResults.isNotEmpty) {
      ReviewService.instance.onSearchSuccess();
    }
  }

  void _toggleStarredOnly() {
    setState(() => _starredOnly = !_starredOnly);
  }

  Future<void> _onStarTap(String unNumber) async {
    await StarService.instance.toggle(unNumber);
    if (StarService.instance.count >= 3) {
      ReviewService.instance.onStarThreshold();
    }
  }

  @override
  Widget build(BuildContext context) {
    final results = _visibleResults;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: HazmatSearchBar(
                  controller: _controller,
                  hint: 'Search UN number, name, or ERG guide…',
                  onChanged: _onSearch,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _toggleStarredOnly,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _starredOnly ? HMColors.hazardYellow : HMColors.surface,
                    border: Border.all(
                      color: _starredOnly ? HMColors.hazardYellow : HMColors.border,
                    ),
                  ),
                  child: Icon(
                    _starredOnly ? Icons.star : Icons.star_outline,
                    size: 20,
                    color: _starredOnly ? Colors.black : HMColors.dimText,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (results.isEmpty)
          Expanded(
            child: Center(
              child: Text(
                _starredOnly ? 'NO STARRED ENTRIES' : 'NO RESULTS',
                style: HMTextStyles.sectionHeader,
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 32),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final entry = results[index];
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
        border: Border(
          top: const BorderSide(color: HMColors.divider),
          right: const BorderSide(color: HMColors.divider),
          bottom: const BorderSide(color: HMColors.divider),
          left: BorderSide(
            color: isStarred ? HMColors.hazardYellow : HMColors.divider,
            width: isStarred ? 4 : 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PlacardThumb(division: entry.hazardClass),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.displayNumber, style: HMTextStyles.codeLabel.copyWith(fontSize: 13)),
                const SizedBox(height: 2),
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

class _PlacardThumb extends StatelessWidget {
  final String division;
  const _PlacardThumb({required this.division});

  @override
  Widget build(BuildContext context) {
    final placard = placardForDivision(division);
    return SizedBox(
      width: 36,
      height: 36,
      child: placard != null
          ? SvgPicture.asset(placard.assetPath, fit: BoxFit.contain)
          : null,
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
