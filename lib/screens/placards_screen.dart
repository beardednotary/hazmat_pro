import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../data/placards_data.dart';
import '../services/review_service.dart';
import '../theme/hazmat_theme.dart';
import '../widgets/hazmat_search_bar.dart';
import 'placard_detail_screen.dart';

class PlacardsScreen extends StatefulWidget {
  const PlacardsScreen({super.key});

  @override
  State<PlacardsScreen> createState() => _PlacardsScreenState();
}

class _PlacardsScreenState extends State<PlacardsScreen> {
  final _controller = TextEditingController();
  List<Placard> _results = kPlacards;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch(String q) {
    setState(() {
      _results = q.isEmpty
          ? kPlacards
          : kPlacards.where((p) => p.matchesQuery(q)).toList();
    });
    if (q.isNotEmpty && _results.isNotEmpty) {
      ReviewService.instance.onSearchSuccess();
    }
  }

  void _openPlacard(Placard placard) {
    HapticFeedback.selectionClick();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PlacardDetailScreen(placard: placard)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: HazmatSearchBar(
            controller: _controller,
            hint: 'Search class, division, or UN number…',
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
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 32),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.82,
              ),
              itemCount: _results.length,
              itemBuilder: (context, i) {
                return _PlacardTile(
                  placard: _results[i],
                  onTap: () => _openPlacard(_results[i]),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _PlacardTile extends StatelessWidget {
  final Placard placard;
  final VoidCallback onTap;

  const _PlacardTile({required this.placard, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: HMColors.surface,
          border: Border.all(color: HMColors.divider),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: SvgPicture.asset(placard.assetPath, fit: BoxFit.contain),
            ),
            const SizedBox(height: 8),
            Text(
              placard.name.toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: HMTextStyles.sectionHeader.copyWith(
                fontSize: 9,
                letterSpacing: 0.5,
                color: HMColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
