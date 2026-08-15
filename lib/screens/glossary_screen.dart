import 'package:flutter/material.dart';
import '../data/glossary_data.dart';
import '../theme/hazmat_theme.dart';
import '../widgets/hazmat_search_bar.dart';

class GlossaryScreen extends StatefulWidget {
  const GlossaryScreen({super.key});

  @override
  State<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends State<GlossaryScreen> {
  final _controller = TextEditingController();
  List<GlossaryEntry> _results = _sorted;

  static final _sorted = List<GlossaryEntry>.from(kGlossary)
    ..sort((a, b) => a.term.compareTo(b.term));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch(String q) {
    setState(() {
      _results = q.isEmpty
          ? _sorted
          : _sorted.where((e) => e.matchesQuery(q)).toList();
    });
  }

  bool _isSearching() => _controller.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: HazmatSearchBar(
            controller: _controller,
            hint: 'Search terms or definitions…',
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
            child: _isSearching()
                ? _FlatList(entries: _results)
                : _GroupedList(entries: _results),
          ),
      ],
    );
  }
}

class _FlatList extends StatelessWidget {
  final List<GlossaryEntry> entries;
  const _FlatList({required this.entries});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 32),
      itemCount: entries.length,
      itemBuilder: (_, i) => _GlossaryTile(entry: entries[i]),
    );
  }
}

class _GroupedList extends StatelessWidget {
  final List<GlossaryEntry> entries;
  const _GroupedList({required this.entries});

  @override
  Widget build(BuildContext context) {
    final items = <Object>[];
    String? lastLetter;
    for (final e in entries) {
      final letter = e.term[0].toUpperCase();
      if (letter != lastLetter) {
        items.add(letter);
        lastLetter = letter;
      }
      items.add(e);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 32),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];
        if (item is String) {
          return _SectionHeader(letter: item);
        }
        return _GlossaryTile(entry: item as GlossaryEntry);
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String letter;
  const _SectionHeader({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          Text(letter, style: HMTextStyles.placardDisplay(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(child: Container(height: 1, color: HMColors.divider)),
        ],
      ),
    );
  }
}

class _GlossaryTile extends StatelessWidget {
  final GlossaryEntry entry;
  const _GlossaryTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HMColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: HMColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(entry.term, style: HMTextStyles.termLabel),
          const SizedBox(height: 4),
          Text(entry.definition, style: HMTextStyles.bodyText),
        ],
      ),
    );
  }
}
